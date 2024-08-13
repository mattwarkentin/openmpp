test_that("Model loads", {
  skip_on_cran()
  skip_on_os('windows')
  model_name <- get_models()$Name[[1]]
  expect_type(get_model(model_name), 'list')
})
