#' @importFrom stats rnorm rmultinom rbinom cov2cor model.matrix plogis
#' @importFrom tibble tibble
#' @importFrom MASS mvrnorm

# Helper function for generating covariates.
fev_generate_covariates <- function(n_obs, n_visits = 4) {
  # Participant ID.
  usubjid <- seq_len(n_obs)

  # Baseline fev1.
  base_fev <- stats::rnorm(n = n_obs, mean = 40, sd = 10)

  # Stratification factor.
  race_label <- factor(c("Asian", "Black or African American", "White"))
  race <- sample(
    race_label,
    size = n_obs,
    replace = TRUE,
    prob = c(0.35, 0.35, 0.25)
  )

  # Treatment indicator.
  trt_label <- c("PBO", "TRT")
  trtn <- stats::rbinom(n = n_obs, size = 1, prob = 0.5)
  trt <- factor(trtn, labels = c("PBO", "TRT"))

  # Gender
  sex_label <- c("Male", "Female")
  sexn <- stats::rbinom(n = n_obs, size = 1, prob = 0.5)
  sex <- factor(sexn, labels = sex_label)

  # Visit number.
  visits <- tibble::tibble(
    VISITN = seq_len(n_visits),
    AVISIT = factor(sprintf("VIS%s", seq_len(n_visits)))
  )

  # Assemble into a covariates data frame.
  demog <- tibble::tibble(
    USUBJID = sprintf("PT%s",usubjid),
    ARMCD = trt,
    RACE = race,
    SEX = sex,
    FEV1_BL = base_fev
  )

  cov_tbl <- tidyr::expand_grid(demog, visits)
  cov_tbl$WEIGHT <- stats::runif(n = nrow(cov_tbl), min = 0.1, max = 0.9)
  cov_tbl
}

fev_model_mat <- function(data){
  # Construct the model matrix.
  model_mat <- stats::model.matrix(~ FEV1_BL + RACE + SEX + ARMCD * AVISIT, data = data)

}

fev_coefs <- function(intercept = 25,
                      baseline = 0.1,
                      race_2_coef = 1,
                      race_3_coef = 5,
                      sex_coef = 0,
                      trt_coef = 5,
                      visit_2_coef = 5,
                      visit_3_coef = 10,
                      visit_4_coef = 15,
                      trt_visit_2_coef = 0,
                      trt_visit_3_coef = -1,
                      trt_visit_4_coef = 1){

  c(intercept, baseline, race_2_coef, race_3_coef, sex_coef,
    trt_coef, visit_2_coef, visit_3_coef, visit_4_coef,
    trt_visit_2_coef, trt_visit_3_coef, trt_visit_4_coef)

}

fev_coefs_var <- function(intercept = 1.5,
                      baseline = 0.025,
                      race_2_coef = 0.5,
                      race_3_coef = 0.5,
                      sex_coef = 0.5,
                      trt_coef = 1,
                      visit_2_coef = 0.75,
                      visit_3_coef = 0.75,
                      visit_4_coef = 1.5,
                      trt_visit_2_coef = 1,
                      trt_visit_3_coef = 1,
                      trt_visit_4_coef = 2){

 c(intercept, baseline, race_2_coef, race_3_coef, sex_coef,
    trt_coef, visit_2_coef, visit_3_coef, visit_4_coef,
    trt_visit_2_coef, trt_visit_3_coef, trt_visit_4_coef)

}
