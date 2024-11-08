#' @importFrom stats rnorm rmultinom rbinom model.matrix
#' @importFrom tibble tibble

# Helper function for generating covariates.
bcva_generate_covariates <- function(n_obs, n_visits = 10) {
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

bcva_model_mat <- function(data) {
  # Construct the model matrix.
  model_mat <- stats::model.matrix(~ base_bcva + strata + trt * visit_num, data = data)
}

bcva_coefs <- function(intercept = 5,
                       base_bcva_coef = 1,
                       strata_2_coef = -1,
                       strata_3_coef = 1,
                       trt_coef = 1,
                       visit_coef = 0.25,
                       trt_visit_coef = 0.25){

  c(intercept, base_bcva_coef, strata_2_coef, strata_3_coef,
    trt_coef, visit_coef, trt_visit_coef)

}

bcva_coefs_var <- function(intercept = 0.2,
                           base_bcva_coef = 0.05,
                           strata_2_coef = 0.05,
                           strata_3_coef = 0.05,
                           trt_coef = 0.05,
                           visit_coef = 0.05,
                           trt_visit_coef = 0.05) {

  c(intercept, base_bcva_coef, strata_2_coef, strata_3_coef,
    trt_coef, visit_coef, trt_visit_coef)

}

bcva_lin_pred <- function(covars_df, coef_visit, coef_trt) {

  -(5 - 0.01 * covars_df$base_bcva + 0.5 * (covars_df$strata == 2) +
      1 * (covars_df$strata == 3) + coef_visit * covars_df$visit_num +
      coef_trt * (covars_df$trt == 0))
}
