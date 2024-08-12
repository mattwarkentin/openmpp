test_that("Get model", {
  skip_on_cran()
  skip_on_ci()
  model_name <- get_models()$Name[[1]]
  expect_type(get_model(model_name), 'list')
})
