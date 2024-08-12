test_that("Get workset", {
  skip_on_cran()
  skip_on_ci()
  model_name <- get_models()$Name[[1]]
  workset_name <- get_worksets(model_name)$Name[[1]]
  expect_type(get_workset(model_name, workset_name), 'list')
})
