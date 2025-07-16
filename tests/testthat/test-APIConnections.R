test_that("API connection succeeds", {
  skip_if_not(test_connection())

  use_OpenMpp_local()
  expect_no_error(get_models())
  expect_no_error(get_models_list())
})
