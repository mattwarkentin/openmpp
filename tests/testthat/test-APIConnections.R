test_that("Should fail with no API connection", {
  expect_error(get_models())
  expect_error(get_models_list())
})

test_that("Should work with no API connection", {
  skip_on_cran()
  use_OpenMpp_remote()
  expect_no_error(get_models())
  expect_no_error(get_models_list())
})
