#' Unzip/extract a downloaded boundary archive
#'
#' @param zip path to zip file
#' @param overwrite boolean, whether to overwrite files if already present
#'
#' @return character vector, path to extracted files
bnsw_unzip <- function(zip, overwrite = FALSE){

  file_absent <- !file.exists(zip)

  if (file_absent){
    stop('File not found')
    return()
  }

  message('Extracting ', zip)

  extract_path <- sub('\\.zip', '', zip)
  utils::unzip(zip, exdir = extract_path, overwrite = overwrite)

  message('Archive extracted to ', extract_path)
  extract_path

}
