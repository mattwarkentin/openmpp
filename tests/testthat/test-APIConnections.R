test_that("API connection fails", {
  expect_error(get_models())
  expect_error(get_models_list())
})

test_that("API connection succeeds", {
  skip_on_cran()
  skip_on_os('windows')
  use_OpenMpp_remote()
  expect_no_error(get_models())
  expect_no_error(get_models_list())
})
