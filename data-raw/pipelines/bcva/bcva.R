source(here::here('data-raw/pipelines/bcva/bcva-helpers.R'))

# BCVA data-generating process.

pipe_bcva <- list(
  # Define Scenario for Example Data.
  tar_target(scenario,{
    tibble::tibble(
      n_obs = 1000,
      trt_coef = 0.25,
      visit_coef = 0.25,
      trt_visit_coef = 0.25,
      missing_type = "moderate"
    )
  }),
  # Generate Covariate Matrix
  tar_target(outcome_covar_mat, compute_unstructured_matrix()),
  # Generate the covariates.
  tar_target(covars_tbl,{
    generate_covariates(
      n_obs = scenario$n_obs,
      n_visits = nrow(outcome_covar_mat)
    )
  }),
  # Generate the outcomes.
  tar_target(bcva_outcomes,{
    generate_outcomes(
      covars_df = covars_tbl,
      cov_mat = outcome_covar_mat,
      trt_coef = scenario$trt_coef,
      visit_coef = scenario$visit_coef,
      trt_visit_coef = scenario$trt_visit_coef
    )
  }),
  # Assemble into a tibble.
  tar_target(bcva_tbl,{
    covars_tbl |>
      dplyr::select(
        participant, base_bcva, strata, trt, visit_num
      ) |>
      dplyr::mutate(
        bcva_change = bcva_outcomes - base_bcva
      )
  }),
  # Delete observations at random.
  tar_target(bcva_tbl_mising,{
    missing_at_random(bcva_tbl, type = scenario$missing_type)
  }),
  # Format to resemble FEV dataset.
  tar_target(bcva_data,{
    bcva_tbl_mising |>
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
  tar_target(bcva_deploy,{
    usethis::use_data(bcva_data, overwrite = TRUE)
  })
)
