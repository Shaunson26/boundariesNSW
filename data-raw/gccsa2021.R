#' Preparation of `gccsa2021`

bnsw_id = 'gccsa2021'

zip_path <-
  bnsw_download_map(
    url = bnsw_download_urls$gccsa2021,
    dest_path ='data-raw/downloads'
  )

shp_path <-
  bnsw_unzip(zip_path)

shp_file <-
  grep('shp$', list.files(shp_path, full.names = T), value = T)

shp <-
  sf::read_sf(shp_file)

# Postcode starting with 2 is NSW
shp_nsw <-
  shp |>
  dplyr::filter(
    STE_NAME21 == "New South Wales",
    !GCC_NAME21 %in% c("No usual address (NSW)", "Migratory - Offshore - Shipping (NSW)")
  ) |>
  dplyr::select(GCC_CODE21, GCC_NAME21)

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

# Zip
filename_zip = paste0(bnsw_id, '-geojson.gzip')

zip(
  zipfile = file.path('data-raw/nsw-geojson', bnsw_id, filename_zip),
  files = file.path('data-raw/nsw-geojson', bnsw_id, filename_geojson)
)

# Move to extdata
file.copy(
  from = file.path('data-raw/nsw-geojson', bnsw_id, filename_zip),
  to = 'inst/extdata'
)

#usethis::use_data(poa2021, overwrite = TRUE)
