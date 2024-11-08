# Helper function for randomly generating unstructured covariance matrix.
#' @export
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

#' @export
compute_ar1_matrix <- function(sigma = 20, rho = 0.6, visits = 10) {
  this_grid <- expand.grid(row = seq(visits), col = seq(visits))
  pow_mat <- with(this_grid, {
    matrix(abs(row - col), visits, visits)
  })

  sigma_mat <- matrix(sigma, visits, visits)

  rho_mat <- matrix(rho, visits, visits)

  sigma_mat * rho_mat^pow_mat
}


# MCAR helper function.
#' @export
mcar <- function(data, col, p) {
  missing_vec <- stats::rbinom(nrow(data), 1, p)
  data[missing_vec == 1, col] <- NA_real_
  data
}

# Helper function for generating data.
#' @export
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

# MAR helper function.
#' @export
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
