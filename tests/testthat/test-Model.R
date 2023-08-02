test_that("Retrieve models list", {
  skip_on_ci()
  skip_on_cran()
  expect_type(get_models_list(), 'list')
  expect_type(get_models(), 'list')
  expect_s3_class(get_models(), 'data.frame')
})
