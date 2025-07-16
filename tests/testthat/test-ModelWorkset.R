test_that("Workset loads", {
  skip_if_not(test_connection())

  use_OpenMpp_local()
  model_name <- get_models()$Name[[1]]
  workset_name <- get_worksets(model_name)$Name[[1]]
  expect_type(get_workset(model_name, workset_name), 'list')
})
