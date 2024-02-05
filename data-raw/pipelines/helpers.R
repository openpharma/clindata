#' @importFrom stats cov2cor plogis rbinom
#' @importFrom clusterGeneration genPositiveDefMat
#' @importFrom MASS mvrnorm

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

pad_number <- function(x, width = 2, pad = "0") {
  fmt <- sprintf("%%%s%ss", pad, width)
  sprintf(fmt, x)
}

# MCAR helper function.
mcar <- function(data, col, p) {
  missing_vec <- stats::rbinom(nrow(data), 1, p)
  data[missing_vec == 1, col] <- NA_real_
  data
}

# MAR helper function.
mar <- function(data, type, fn = NULL) {
  # Compute missingness probabilities.

  if (type == "none") {

    prob_miss <- 0

  } else {

    coefs <- switch(type,
      "mild" = c(-0.3, -0.2),
      "moderate" = c(-0.4, -0.5),
      "high" = c(-0.5, -1.0)
    )

    prob_miss <- stats::plogis(fn(data, coefs[1], coefs[2]))
  }

  # Generate vector of missingness indicators.
  missing_ind <- stats::rbinom(nrow(data), 1, prob_miss)

  # Only keep non-missing visits.
  data[missing_ind == 0, ]
}

# Helper function for generating data.
generate_outcomes <- function(model_mat, cov_mat, effect_coefs, effect_var) {

  # Generate the outcomes.
  n_visits <- nrow(cov_mat)
  n_obs <- nrow(model_mat) / n_visits

  rbetas <- MASS::mvrnorm(1, effect_coefs, diag(effect_var))
  mu <- as.numeric(model_mat %*% rbetas)

  resid <- as.numeric(MASS::mvrnorm(n_obs, rep(0, n_visits), cov_mat))
  y_hat <- mu + resid
  as.vector(y_hat)
}
