test_that("Retrieve models list", {
  expect_type(get_models_list(), 'list')
  expect_type(get_models(), 'list')
  expect_s3_class(get_models(), 'data.frame')
})
