#' Simplify a geometery
#'
#' Sometimes a default shape file is of too high resolution for simple plotting.
#' This function uses \code{rmapshaper} to simplify map geometry.
#'
#' @param map sf object, sf data.frame with column geometry
#' @param keep_proportion number, proportion of map to keep. Must be between 0 - 1
#'
#' @export
bnsw_simplify_map <- function(map, keep_proportion = 0.1){

  stopifnot("map should be an object of class sf" = class(map)[1] == 'sf')
  stopifnot("keep_proportion must be between 0 and 1" = keep_proportion > 0 & keep_proportion < 1)

  rmapshaper::ms_simplify(map, keep = keep_proportion, keep_shapes = T)
}
