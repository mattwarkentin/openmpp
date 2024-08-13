test_that("OpenMppModelRun class works", {
  skip_on_cran()
  skip_on_os('windows')

  # Setup
  use_OpenMpp_remote()
  model_name <- get_models()$Name[[1]]
  run_name <- get_model_runs(model_name)$Name[[1]]
  run <- load_model_run(model_name, run_name)

  # Tests
  expect_no_error(load_run(model_name, run_name))
  expect_type(run, 'environment')
  expect_s3_class(run, c("OpenMppModelRun", "OpenMppModel", "R6"), TRUE)
  expect_s3_class(run$TablesInfo, 'data.frame')
  expect_s3_class(run$ParamsInfo, 'data.frame')
  expect_s3_class(run$ModelTasks, 'data.frame')
  expect_s3_class(run$ModelRuns, 'data.frame')
  expect_s3_class(run$ModelScenarios, 'data.frame')
  expect_s3_class(run$ModelWorksets, 'data.frame')
  expect_type(run$Parameters, 'environment')
  expect_type(run$Tables, 'environment')
  expect_type(run$ModelMetadata, 'list')
  expect_type(run$RunMetadata, 'list')
  expect_type(run$ModelVersion, 'character')
  expect_type(run$ModelName, 'character')
  expect_type(run$RunName, 'character')
  expect_type(run$ModelDigest, 'character')
  expect_type(run$RunDigest, 'character')
  expect_type(run$RunStamp, 'character')
  expect_type(run$RunStatus, 'character')
  expect_type(run$RunStatusInfo, 'list')
  expect_type(run$OpenMppType, 'character')
  expect_type(run$RunDigest, 'character')
  expect_equal(run$OpenMppType, 'ModelRun')
  expect_output(run$print())
})
