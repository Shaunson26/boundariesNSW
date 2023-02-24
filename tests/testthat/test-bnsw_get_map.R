test_that("throw error with incorrect boundary", {
  expect_error(bnsw_get_map(boundary = 'lga1234'))
})

test_that("works", {

  res <- bnsw_get_map(boundary = 'lga2019')

  expect_true(
    all(names(res) %in% c("LGA_CODE19", "LGA_NAME19", "geometry"))
  )

  res <- bnsw_get_map(boundary = 'lga2016')

  expect_true(
    all(names(res) %in% c("LGA_CODE16", "LGA_NAME16", "geometry"))
  )

})
