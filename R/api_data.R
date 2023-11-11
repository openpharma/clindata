#' @export
read_data <- function(data, filetype = 'rds', use_cache = FALSE,...){
  
  if(use_cache){
    cache_dir <- cache_dir()
    if(dir.exists(cache_dir)){
      items <- tools::file_path_sans_ext(list.files(cache_dir))
      if(data %in% items){
        data_path <- file.path(cache_dir, sprintf("%s.%s",data, filetype))
        message(sprintf('Retrieving %s from cache', data))
        if(filetype=='rds'){
          data_out <- readRDS(data_path)
        }
      }else{
        message(sprintf('%s not in cache', data))
      }
    }    
  }else{
    data_out <- get(data, asNamespace('clindata'))
  }
  
  return(data_out)
  
}

#' @export
load_data <- function(data, env = parent.frame(),...){
  
  invisible(
    Map(function(x) {
      assign(x, read_data(x, ...), envir = env)
    }, 
    x = data
    )
  )
  
}

#' @export
cache_data <- function(data, filetype = 'rds'){
  
  cache_dir <- cache_dir()
  
  if(!dir.exists(cache_dir)){
    cache_init()
  }
  
  if(filetype=='rds'){
    saveRDS(
      object = read_data(data), 
      file = file.path(cache_dir, sprintf("%s.%s",data, filetype))
    )    
  }
  
}

#' @export
list_data <- function(){
  
  data(package='clindata')[['results']][,'Item']
  
}
