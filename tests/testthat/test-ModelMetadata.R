test_that("Model loads", {
  skip_if_not(test_connection())

  use_OpenMpp_local()
  model_name <- get_models()$Name[[1]]
  expect_type(get_model(model_name), 'list')
})
