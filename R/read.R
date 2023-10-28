#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param file_name PARAM_DESCRIPTION
#' @param filetype PARAM_DESCRIPTION, Default: c("csv", "json")
#' @param \dots PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  [read_json][jsonlite::read_json]
#'  [read_csv][readr::read_csv]
#' @rdname read
#' @export
#' @importFrom jsonlite read_json
#' @importFrom readr read_csv
clindata_fetch <- function(file_name, filetype = c('csv','json'),...){

  filetype <- match.arg(filetype,choices = c('csv','json'))

  if(! (file_name%in%ls(envir = clindata_list(filetype)))){

    filepath <- file.path(pkg_env$vars$root, filetype, file_name)

    data <- switch (filetype,
                    'json' = {jsonlite::read_json(filepath,...)},
                    'csv' = {readr::read_csv(filepath,...)}
    )

    assign(x = file_name, value = data, pos = , envir = pkg_env[['data']][[filetype]])
  }
}

#' @rdname read
#' @export
clindata_load <- function(key, env = parent.frame(),...){
  invisible(Map(function(x) {assign(basename(x),clindata_read(x, ...), envir = env)}, x = key))
}

#' @rdname read
#' @export
clindata_read <- function(key, filetype = c('csv','json')){
  filetype <- match.arg(filetype,choices = c('csv','json'))
  pkg_env[['data']][[filetype]][[key]]
}

#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param filetype PARAM_DESCRIPTION, Default: c("csv", "json")
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname clindata_list
#' @export
clindata_list <- function(filetype = c('csv','json')){
  filetype <- match.arg(filetype,choices = c('csv','json'))
  ls(envir = pkg_env[['data']][[filetype]])
}
