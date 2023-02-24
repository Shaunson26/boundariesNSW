test_that("bnsw_list_maps returns all gzips", {
  result <- bnsw_list_maps()
  expect_true(all(grepl('geojson.gzip$', result)))
})

test_that("bnsw_list_maps returns all gzip full paths", {
  result <- bnsw_list_maps(full.names = TRUE)
  expect_true(all(grepl('extdata.*geojson.gzip$', result)))
})
