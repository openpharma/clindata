#' @title Read data
#' @description Read data directly into a global environment
#' @param data character, name of data object
#' @param filetype character, extension type of the data. Default: 'rds'
#' @param use_cache boolean, use the data stored in cache? Default: FALSE
#' @return data.frame
#' @details
#'   Currently only loading of rds files is supported
#' @examples
#'  read_data('fev_data')
#'  read_data('bcva_data')
#' @rdname data_api
#' @export
#' @importFrom tools file_path_sans_ext
read_data <- function(data, filetype = 'rds', use_cache = FALSE){

  if(use_cache){
    cache_dir <- cache_dir()
    if(dir.exists(cache_dir)){
      items <- tools::file_path_sans_ext(list.files(cache_dir))
      if(data %in% items){
        data_path <- file.path(cache_dir, sprintf("%s.%s",data, filetype))
        message(sprintf('Retrieving %s from cache', data))
        if(filetype == 'rds'){
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

#' @title Load data
#' @description Load data directly into an enivornment
#' @param data character, name of data object
#' @param env environment, Default: parent.frame()
#' @param ... arguments passed to assign [assign][base::assign]
#' @return NULL
#' @details
#'   By default the data is loaded into the parent frame from which it is called.
#' @examples
#'  load_data('fev_data')
#' @rdname load_data
#' @export
load_data <- function(data, env = parent.frame(), ...){

  invisible(
    Map(function(x) {
      assign(x, read_data(x, ...), envir = env)
    },
    x = data
    )
  )

}

#' @title Store data
#' @description Store data in the cache
#' @param data character, name of the object to store
#' @param filetype character, extension of the 
#'   filetype to save the data. Default: 'rds'
#' @return NULL
#' @details
#'   Currently only rds is supported
#' @examples
#'   # initialize the cache directory
#'   cache_init()
#'
#'   # populate the cache
#'   cache_data('fev_data')
#'   cache_ls()
#'
#'   # cleanup
#'    cache_destroy()
#' @rdname cache_data
#' @export 
cache_data <- function(data, filetype = 'rds'){

  cache_dir <- cache_dir()

  if(!dir.exists(cache_dir)){
    cache_init()
  }

  if(filetype == 'rds'){
    saveRDS(
      object = read_data(data), 
      file = file.path(cache_dir, sprintf("%s.%s", data, filetype))
    )
  }

}

#' @title List data 
#' @description List the clinical data stored in the package
#' @return character
#' @examples
#'  list_data()
#' @rdname list_data
#' @importFrom utils data
#' @export 
list_data <- function(){

  utils::data(package='clindata')[['results']][,'Item']

}
