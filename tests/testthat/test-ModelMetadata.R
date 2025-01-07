test_that("Model loads", {
  skip_on_cran()
  local_initiate_oms(oms_path)
  use_OpenMpp_local()
  model_name <- get_models()$Name[[1]]
  expect_type(get_model(model_name), 'list')
})
