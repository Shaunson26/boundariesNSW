
res <- bnsw_get_map(boundary = 'lga2019')
bnsw_lga2019_code_names <- sf::st_drop_geometry(res)
usethis::use_data(bnsw_lga2019_code_names)

res <- bnsw_get_map(boundary = 'lga2016')
bnsw_lga2016_code_names <- sf::st_drop_geometry(res)
usethis::use_data(bnsw_lga2016_code_names)
