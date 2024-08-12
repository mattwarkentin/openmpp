test_that("Tests OpenMppModel class", {
  skip_on_cran()

  # Setup
  use_OpenMpp_remote()
  model_name <- get_models()$Name[[1]]
  model <- load_model(model_name)

  # Test
  expect_type(model, 'environment')
  expect_s3_class(model, c("OpenMppModel", "R6"), TRUE)
  expect_s3_class(model$TablesInfo, 'data.frame')
  expect_s3_class(model$ParamsInfo, 'data.frame')
  expect_s3_class(model$ModelTasks, 'data.frame')
  expect_s3_class(model$ModelRuns, 'data.frame')
  expect_s3_class(model$ModelScenarios, 'data.frame')
  expect_s3_class(model$ModelWorksets, 'data.frame')
  expect_type(model$ModelMetadata, 'list')
  expect_type(model$ModelVersion, 'character')
  expect_type(model$ModelName, 'character')
  expect_type(model$ModelDigest, 'character')
  expect_type(model$OpenMppType, 'character')
  expect_equal(model$OpenMppType, 'Model')
  expect_output(model$print())
})
