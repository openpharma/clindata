#' @importFrom stats rnorm rmultinom rbinom cov2cor model.matrix plogis
#' @importFrom tibble tibble
#' @importFrom clusterGeneration genPositiveDefMat
#' @importFrom MASS mvrnorm

# Helper function for generating covariates.
generate_covariates <- function(n_obs, n_visits = 10) {
  # Participant ID.
  participant <- seq_len(n_obs)

  # Baseline best corrected visual acuity score.
  base_bcva <- stats::rnorm(n = n_obs, mean = 75, sd = 10)

  # Stratification factor.
  strata <- as.vector(
    c(1, 2, 3) %*% stats::rmultinom(n = n_obs, 1, prob = c(0.3, 0.3, 0.4))
  )

  # Treatment indicator.
  trt <- stats::rbinom(n = n_obs, size = 1, prob = 0.5)

  # Visit number.
  visit_num <- rep(seq_len(n_visits), n_obs)

  # Assemble into a covariates data frame.
  tibble::tibble(
    participant = rep(participant, each = n_visits),
    base_bcva = rep(base_bcva, each = n_visits),
    strata = as.factor(rep(strata, each = n_visits)),
    trt = rep(trt, each = n_visits),
    visit_num
  )
}

# Helper function for randomly generating unstructured covariance matrix.
compute_unstructured_matrix <- function(
    vars = seq(from = 1, by = 0.5, length.out = 10)) {
  n_visits <- length(vars)
  corr_mat <- abs(stats::cov2cor(
    clusterGeneration::genPositiveDefMat(dim = n_visits)$Sigma
  ))
  sd_mat <- diag(sqrt(vars))
  us_mat <- sd_mat %*% corr_mat %*% sd_mat
  return(us_mat)
}

# Helper function for generating BCVA data.
generate_outcomes <- function(covars_df,
                              cov_mat,
                              intercept = 5,
                              base_bcva_coef = 1,
                              strata_2_coef = -1,
                              strata_3_coef = 1,
                              trt_coef = 1,
                              visit_coef = 0.25,
                              trt_visit_coef = 0.25) {
  # Construct the model matrix.
  model_mat <- stats::model.matrix(
    ~ base_bcva + strata + trt * visit_num,
    data = covars_df
  )

  # Generate the bvca outcomes.
  n_visits <- nrow(cov_mat)
  n_obs <- nrow(covars_df) / n_visits
  effect_coefs <- c(
    intercept, base_bcva_coef, strata_2_coef, strata_3_coef,
    trt_coef, visit_coef, trt_visit_coef
  )

  xb <- model_mat %*% effect_coefs
  resid_mat <- MASS::mvrnorm(n_obs, rep(0, n_visits), cov_mat)
  resid <- resid_mat |> t() |> as.vector()
  y_hat <- xb + resid
  as.vector(y_hat)
}

# MAR helper function.
missing_at_random <- function(covars_df, type) {
  # Compute missingness probabilities.
  lin_pred <- function(coef_visit, coef_trt) {
    -(5 - 0.01 * covars_df$base_bcva + 0.5 * (covars_df$strata == 2) +
      1 * (covars_df$strata == 3) + coef_visit * covars_df$visit_num +
      coef_trt * (covars_df$trt == 0))
  }
  prob_miss <- if (type == "none") {
    0
  } else if (type == "mild") {
    stats::plogis(lin_pred(-0.3, -0.2))
  } else if (type == "moderate") {
    stats::plogis(lin_pred(-0.4, -0.5))
  } else if (type == "high") {
    stats::plogis(lin_pred(-0.5, -1))
  }

  # Generate vector of missingness indicators.
  missing_ind <- stats::rbinom(nrow(covars_df), 1, prob_miss)

  # Only keep non-missing visits.
  covars_df[missing_ind == 0, ]
}

pad_number <- function(x, width = 2, pad = "0"){
  fmt = sprintf('%%%s%ss', pad, width)
  sprintf(fmt,x)
}
