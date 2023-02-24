#' Import NSW map into R session
#'
#' This function returns a chosen map an `sf` object. The maps are stored as compressed
#' geojsons within this package. You can chose whether to extract that geojson to a
#' chosen destination (geojson_extract_location), or allow the function to extract to a temporary
#' folder for import of the geojson into R using [sf::st_read()]
#'
#' @param boundary character, code for selected boundary
#' @param geojson_extract_location character, a path for extracted geojson. If missing a \code{tempdir()} will be used
#' @param return_sf_object boolean, whether to return the map as an `sf` object
#'
#' @export
#' @examples {
#' # Import LGA19 as sf object to R session
#' lga2019 <- bnsw_get_map('lga2019')
#'
#' # Extract LGA19 geojson to working directory
#' lga2019 <- bnsw_get_map('lga2019', return_sf_object = FALSE)
#' }
bnsw_get_map <- function(boundary = c('lga2016', 'lga2019', 'lhd2010', 'poa2016', 'gccsa2016'),
                    geojson_extract_location,
                    return_sf_object = TRUE){

  boundary <- match.arg(boundary, choices = c('lga2016', 'lga2019', 'lhd2010', 'poa2016', 'gccsa2016'))

  # Make a file table - zip, filename, alias,
  file <-
    switch(boundary,
           lga2019 = 'lga2019-geojson.gzip',
           lga2016 = 'lga2016-geojson.gzip',
           lhd2010 = 'lhd2010-geojson.gzip',
           poa2016 = 'poa2016-geojson.gzip',
           gccsa2016 = 'gccsa2016-geojson.gzip')

  file_path <- system.file(package = 'boundariesNSW', 'extdata', file)

  if (missing(geojson_extract_location)) {
    geojson_extract_location <- tempdir()
  }

  utils::untar(file_path, exdir = geojson_extract_location)

  message(paste0(file, ' extracted to ', geojson_extract_location))

  file_untar <- grep(boundary, list.files(geojson_extract_location), value = T)

  file_untar_path <- file.path(geojson_extract_location, file_untar)

  if (return_sf_object){
    return(sf::st_read(file_untar_path))
  }

  # Return NULL if only extracting
  invisible(NULL)

}

