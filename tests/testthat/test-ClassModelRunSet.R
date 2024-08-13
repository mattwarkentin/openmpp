test_that("OpenMppModelRunSet class works", {
  skip_on_cran()
  skip_on_os('windows')

  # Setup
  use_OpenMpp_remote()
  model_name <- get_models()$Name[[1]]
  run_name <- get_model_runs(model_name)$Name[[1]]
  runset <- load_model_runs(model_name, c(run_name, run_name))

  # Tests
  expect_no_error(load_runs(model_name, c(run_name, run_name)))
  expect_type(runset, 'environment')
  expect_s3_class(runset, c("OpenMppModelRunSet", "R6"), TRUE)
  expect_type(runset$Tables, 'environment')
  expect_type(runset$RunMetadatas, 'list')
  expect_type(runset$RunStatuses, 'character')
  expect_type(runset$RunStamps, 'character')
  expect_type(runset$RunDigests, 'character')
  expect_type(runset$RunNames, 'character')
  expect_type(runset$OpenMppType, 'character')
  expect_equal(runset$OpenMppType, 'ModelRunSet')
  expect_type(runset$ModelVersion, 'character')
  expect_type(runset$ModelName, 'character')
  expect_type(runset$ModelDigest, 'character')
  expect_output(runset$print())
})
