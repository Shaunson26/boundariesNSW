#' Preparation of `lhd2010`

bnsw_id = 'lhd2010'

kml <- readLines(bnsw_download_urls$lhd2010)

dir.create('data-raw/downloads/LHD2010')
writeLines(kml, con = 'data-raw/downloads/LHD2010/LHD2010.kml')

shp_layers <- sf::st_layers('data-raw/downloads/LHD2010/LHD2010.kml')

shp <-
  dplyr::bind_rows(
    sf::read_sf('data-raw/downloads/LHD2010/LHD2010.kml',
                layer = shp_layers$name[1]) |>
      dplyr::mutate(Description = shp_layers$name[1])
    ,
    sf::read_sf('data-raw/downloads/LHD2010/LHD2010.kml',
                layer = shp_layers$name[2]) |>
      dplyr::mutate(Description = shp_layers$name[2])
  )

lhd_codes <-
  tibble::tribble(
    ~LHD_CODE10, ~LHD_NAME10,
    'X700',	'Sydney LHD',
    'X710',	'South Western Sydney LHD',
    'X720',	'South Eastern Sydney LHD',
    'X730',	'Illawarra Shoalhaven LHD',
    'X740',	'Western Sydney LHD',
    'X750',	'Nepean Blue Mountains LHD',
    'X760',	'Northern Sydney LHD',
    'X770',	'Central Coast LHD',
    'X800',	'Hunter New England LHD',
    'X810',	'Northern NSW LHD',
    'X820',	'Mid North Coast LHD',
    'X830',	'Southern NSW LHD',
    'X840',	'Murrumbidgee LHD',
    'X850',	'Western NSW LHD',
    'X860',	'Far West LHD',
    'X630',	'Sydney Children’s Hospitals Network',
    'X690',	'St Vincent’s Health Network',
    'X180',	'Forensic Mental Health Network',
    'X170',	'Justice Health',
    'X910',	'NSW not further specified',
    'X920',	'Victoria',
    'X921',	'Albury Wodonga Health (Network with Victoria)',
    'X930',	'Queensland',
    'X940',	'South Australia',
    'X950',	'Western Australia',
    'X960',	'Tasmania',
    'X970',	'Northern Territory',
    'X980',	'Australian Capital Territory',
    'X990',	'Other Australian Territories',
    'X997',	'Overseas Locality',
    'X998',	'No Fixed Address',
    '9999',	'Missing'
  )

shp_nsw <-
  shp |>
  dplyr::mutate(
    LHD_NAME10 = dplyr::case_when(
      grepl('Albury Wodonga Health', Name) ~ Name,
      .default = paste(Name, 'LHD')
    )
  ) |>
  dplyr::left_join(
    lhd_codes, by = "LHD_NAME10"
  ) |>
  dplyr::select(LHD_CODE10, LHD_NAME10)


# Visualise
shp_nsw |>
  leaflet::leaflet() |>
  leaflet::addProviderTiles(leaflet::providers$OpenStreetMap) |>
  leaflet::addPolygons(label = ~LHD_NAME10)

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
  to = 'inst/extdata',
  overwrite = T
)

#usethis::use_data(poa2021, overwrite = TRUE)
