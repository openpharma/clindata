# Load packages required to define the pipeline:
library(targets)
# library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  # packages that your targets need to run
  packages = c("usethis","tibble","dplyr","stats","clusterGeneration","MASS")
)

pipelines_path <- here::here('data-raw/pipelines')
pipelines_files <- list.files(pipelines_path,pattern = 'R$',full.names = TRUE)

purrr::walk(pipelines_files, source)

tar_option_set(seed = 510)
pipe_bcva
