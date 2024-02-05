source(here::here("data-raw/pipelines/bcva/bcva-helpers.R"))
source(here::here("data-raw/pipelines/helpers.R"))

# BCVA data-generating process.

pipe_bcva <- list(
  # Define Scenario for Example Data.
  tar_target(bcva_scenario, {
    tibble::tibble(
      n_obs = 1000,
      trt_coef = 0.25,
      visit_coef = 0.25,
      trt_visit_coef = 0.25,
      missing_type = "moderate"
    )
  }),
  # Generate Covariate Matrix
  tar_target(bcva_outcome_covar_mat, compute_unstructured_matrix()),
  # Generate the covariates.
  tar_target(bcva_covars_tbl, {
    bcva_generate_covariates(
      n_obs = bcva_scenario$n_obs,
      n_visits = nrow(bcva_outcome_covar_mat)
    )
  }),
  # Generate the outcomes.
  tar_target(bcva_outcomes, {
    generate_outcomes(
      model_mat = bcva_model_mat(bcva_covars_tbl),
      cov_mat = bcva_outcome_covar_mat,
      effect_coefs = bcva_coefs(
        trt_coef = bcva_scenario$trt_coef,
        visit_coef = bcva_scenario$visit_coef,
        trt_visit_coef = bcva_scenario$trt_visit_coef
      ),
      effect_var = bcva_coefs_var()
    )
  }),
  # Assemble into a tibble.
  tar_target(bcva_tbl, {
    bcva_covars_tbl |>
      dplyr::select(
        participant, base_bcva, strata, trt, visit_num
      ) |>
      dplyr::mutate(
        bcva_change = bcva_outcomes - base_bcva
      )
  }),
  # Delete observations at random.
  tar_target(bcva_tbl_missing, {
    mar(bcva_tbl, type = bcva_scenario$missing_type, bcva_lin_pred)
  }),
  # Format to resemble FEV dataset.
  tar_target(bcva_data, {
    bcva_tbl_missing |>
      dplyr::transmute(
        USUBJID = factor(participant),
        VISITN = visit_num,
        AVISIT = paste0("VIS", pad_number(visit_num)),
        AVISIT = factor(
          AVISIT,
          levels = paste0("VIS", pad_number(seq_len(10)))
        ),
        ARMCD = ifelse(trt == 1, "TRT", "CTL"),
        RACE = ifelse(strata == 1, "Black",
                      ifelse(strata == 2, "Asian", "White")
        ),
        BCVA_BL = base_bcva,
        BCVA_CHG = bcva_change
      )
  }),
  tar_target(bcva_deploy, {
    usethis::use_data(bcva_data, overwrite = TRUE)
  })
)
