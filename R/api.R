#' @export
get_data <- function(data, use_cache = FALSE,...){
  
  if(use_cache){
    cache_dir <- get_cache_dir()
    if(dir.exists(cache_dir)){
      items <- tools::file_path_sans_ext(list.files(cache_dir))
      if(data %in% items){
        data_path <- file.path(cache_dir, sprintf("%s.rds",data))
        message(sprintf('Retrieving %s from cache', data))
        return(readRDS(data_path))
      }else{
        message(sprintf('%s not in cache', data))
        return(invisible(NULL))
      }
    }    
  }else{
    return(get(data, asNamespace('clindata')) )
  }
  
}

#' @export
load_data <- function(data, env = parent.frame(),...){
  invisible(Map(function(x) {assign(x,get_data(x, ...), envir = env)}, x = data))
}

#' @export
cache_data <- function(data){
  cache_dir <- get_cache_dir()
  if(!dir.exists(cache_dir))
    initiate_cache()
  saveRDS(get_data(data), file = file.path(cache_dir, sprintf("%s.rds",data)))
}

#' @export
list_data <- function(){
  data(package='clindata')[['results']][,'Item']
}

#' @export
initiate_cache <- function(){
  dir.create(get_cache_dir(), recursive = TRUE)
}

get_cache_dir <- function(){
  tools::R_user_dir('clindata', which = 'cache')
}
