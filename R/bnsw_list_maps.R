#' List map files associated with boundariesNSW
#'
#' A simple wrapper to \code{list.files()} of the packages external data
#'
#' @param full.names a logical value. If TRUE, the directory path is prepended to the file names to give a relative file path. If FALSE, the file names (rather than paths) are returned.
#'
#' @export
bnsw_list_maps <- function(full.names = FALSE){
  list.files(path = system.file(package = 'boundariesNSW', 'extdata'), full.names = full.names, pattern = 'gzip$')
}
