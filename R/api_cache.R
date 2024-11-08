#' @title Data Caching API
#' @description Functions to manage cache data across sessions.
#' @param path character, path to cache directory, Default: `cache_dir()`
#' @param \dots arguments passed to [list.files()]
#' @param verbose logical, show message on success of [cache_destroy()]
#' @return character
#' @details
#'   If the environment variable CLINDATA_CACHE_DIR is set then [cache_dir()] will use the value.
#'
#'   If the environment variable CLINDATA_CACHE_DIR is not set then [cache_dir()] will
#'   default to the internal mechanism via [R_user_dir][tools::R_user_dir].
#' @examples
#'  cache_dir()
#'  cache_init()
#'  cache_ls()
#'  cache_destroy()
#' @rdname cache_api
#' @export
cache_init <- function(path = cache_dir()) {

  dir.create(path = path, recursive = TRUE, showWarnings = FALSE)

}

#' @rdname cache_api
#' @export
cache_ls <- function(path = cache_dir(), ...) {

  list.files(path = path, ...)

}

#' @rdname cache_api
#' @export
cache_dir <- function() {
  if (nzchar(Sys.getenv("CLINDATA_CACHE_DIR")))
    return(Sys.getenv("CLINDATA_CACHE_DIR"))

  tools::R_user_dir(
    package = "clindata",
    which = "cache"
  )

}

#' @title Clear data cache
#' @description Clear file(s) from the cache path.
#' @param files character, files to be removed,
#'   Default: [cache_ls][cache_ls](full.names = TRUE)
#' @param recursive boolean. Should directories be deleted recursively?
#' @param force boolean. Should permissions be changed (if possible) to
#'   allow the file or directory to be removed?
#' @return NULL
#' @examples
#'   # initialize the cache directory
#'   cache_init()
#'
#'   # populate the cache
#'   cache_data("fev_data")
#'   cache_data("cars")
#'
#'   # list files in the cache
#'   cache_ls()
#'
#'   # clear all the files in the cache
#'   cache_rm()
#'   cache_ls()
#'
#'  # remove a single file based on a pattern
#'   cache_data("fev_data")
#'   cache_data("cars")
#'   cache_rm(cache_ls(pattern = "fev", full.names = TRUE))
#'   cache_ls()
#'
#'  # cleanup
#'   cache_destroy()
#' @export
cache_rm <- function(
    files = cache_ls(full.names = TRUE),
    recursive = FALSE,
    force = FALSE) {

  invisible(
    lapply(files,
           function(f) {
             unlink(x = f, recursive = recursive, force = force)
           })
  )
}

#' @rdname cache_api
#' @export
cache_destroy <- function(path = cache_dir(), verbose = TRUE) {
  unlink(path, recursive = TRUE, force = TRUE)
  if (verbose)
    message(path, " directory removed")
}
