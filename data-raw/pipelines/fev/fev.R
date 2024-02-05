source(here::here('data-raw/pipelines/helpers.R'))
source(here::here('data-raw/pipelines/fev/fev-helpers.R'))

# FEV1 data-generating process.

pipe_fev <- list(
  # Define Scenario for Example Data.
  tar_target(fev_scenario, {
    tibble::tibble(
      n_obs = 800,
      trt_coef = 4,
      missing_percent = 0.3
    )
  }),
  # Generate Covariate Matrix
  tar_target(fev_outcome_covar_mat, {
    v11 <- rnorm(1, 40, 0.1)
    vars <- v11 * c(1, 2/3, 1/3, 5/2)
    compute_unstructured_matrix(vars)
  }),
  # Generate the covariates.
  tar_target(fev_covars_tbl, {
    fev_generate_covariates(
      n_obs = fev_scenario$n_obs,
      n_visits = nrow(fev_outcome_covar_mat)
    )
  }),
  # Generate the outcomes.
  tar_target(fev_outcomes, {
    generate_outcomes(
      model_mat = fev_model_mat(fev_covars_tbl),
      cov_mat = fev_outcome_covar_mat,
      effect_coefs = fev_coefs(trt_coef = fev_scenario$trt_coef),
      effect_var = fev_coefs_var()
    )
  }),
  # Assemble into a tibble.
  tar_target(fev_tbl, {
    fev_covars_tbl |>
      dplyr::mutate(
        FEV1 = fev_outcomes
      )
  }),
  # Delete observations at random.
  tar_target(fev_data, {
    mcar(fev_tbl, "FEV1", fev_scenario$missing_percent)
  }),
  tar_target(fev_deploy, {
    usethis::use_data(fev_data, overwrite = TRUE)
  })
)
