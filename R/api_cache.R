#' @export
cache_init <- function(path = cache_dir()){
  
  dir.create(path = path, recursive = TRUE)
  
}

#' @export
cache_ls <- function(path = cache_dir()){
  
  list.files(
    path = path
  )
  
}

#' @export
cache_rm <- function(pattern, path = cache_dir(), ...){
  
  unlink(
    x = file.path(path, pattern),
    ...
  )
  
}

#' @export
cache_dir <- function(){
  
  tools::R_user_dir(
    package = 'clindata', 
    which = 'cache'
  )
  
}
