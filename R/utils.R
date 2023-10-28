pkg_env <- new.env()
pkg_env$data <- vector(mode = 'list')
pkg_env$data$csv <- new.env()
pkg_env$data$json <- new.env()

pkg_env$vars <- vector(mode = 'list')
pkg_env$vars$root <- 'https://openpharma-clindata.s3.us-east-2.amazonaws.com'
