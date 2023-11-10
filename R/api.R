#' @export
get_data <- function(data){
  get(data, asNamespace('clindata'))
}

#' @export
list_data <- function(){
  data(package='clindata')[['results']][,'Item']
}
