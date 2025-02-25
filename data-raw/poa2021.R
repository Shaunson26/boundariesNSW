#' Preparation of `poa2021`

bnsw_id = 'poa2021'

zip_path <-
  bnsw_download_map(
    url = download_urls$poa2021,
    dest_path ='data-raw/downloads'
  )

shp_path <-
  bnsw_unzip(zip_path)

shp_path <- "data-raw/downloads/POA_2021_AUST_GDA2020_SHP/"

shp_file <-
  grep('shp$', list.files(shp_path, full.names = T), value = T)

shp_file = "data-raw/downloads/POA_2021_AUST_GDA2020_SHP/POA_2021_AUST_GDA2020.shp"

shp <-
  sf::read_sf(shp_file)

# Postcode starting with 2 is NSW
shp_nsw <-
  shp |>
  dplyr::filter(grepl('^2', POA_CODE21)) |>
  dplyr::select(POA_CODE21)

# Visualise
shp_nsw |>
  leaflet::leaflet() |>
  leaflet::addProviderTiles(leaflet::providers$OpenStreetMap) |>
  leaflet::addPolygons()

# Output
dir.create(file.path('data-raw/nsw-geojson', bnsw_id))

filename_geojson = paste0(bnsw_id, '.geojson')

shp_nsw |>
  sf::write_sf(
    dsn = file.path('data-raw/nsw-geojson', bnsw_id, filename_geojson)
  )

shp_nsw |>
  sf::write_sf(
    dsn = file.path('data-raw/nsw-geojson/poa2021/poa2021.gpkg')
  )

# Zip
filename_zip = paste0(bnsw_id, '-geojson.gzip')

zip(
  zipfile = file.path('data-raw/nsw-geojson', bnsw_id, filename_zip),
  files = file.path('data-raw/nsw-geojson', bnsw_id, filename_geojson)
)

zip(
  zipfile = file.path('data-raw/nsw-geojson/poa2021/poa2021-gpkg.gzip'),
  files = file.path('data-raw/nsw-geojson/poa2021/poa2021.gpkg')
)

# Move to extdata
file.copy(
  from = file.path('data-raw/nsw-geojson', bnsw_id, filename_zip),
  to = 'inst/extdata'
)

#usethis::use_data(poa2021, overwrite = TRUE)
