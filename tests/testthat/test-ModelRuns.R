test_that("Test model run accessors", {
  skip_on_cran()
  model_name <- get_models()$Name[[1]]
  run_name <- get_model_runs(model_name)$Name[[1]]
  expect_type(get_run(model_name, run_name), 'list')
})
