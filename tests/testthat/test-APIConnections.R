test_that("API connection succeeds", {
  skip_on_cran()
  local_initiate_oms(oms_path)
  use_OpenMpp_local()
  expect_no_error(get_models())
  expect_no_error(get_models_list())
})
