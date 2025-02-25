#' Download a map from a given URL
#'
#' @param url URL to given download
#' @param dest_path where to save the download
#'
#' @return character vector, path to downloaded file
bnsw_download_map <- function(url, dest_path){

  #url <- "https://www.abs.gov.au/statistics/standards/australian-statistical-geography-standard-asgs-edition-3/jul2021-jun2026/access-and-downloads/digital-boundary-files/LGA_2024_AUST_GDA2020.zip"
  #dest_path <- 'dev/downloads/'

  zip_path = file.path(dest_path, basename(url))

  utils::download.file(url = url,
                destfile = zip_path,
                mode = 'wb')

  zip_absent = !file.exists(zip_path)

  if (zip_absent) {
    stop('Downloading or saving of file from given url failed')
    return()
  }

  message('File downloaded to ', zip_path)

  zip_path

}


