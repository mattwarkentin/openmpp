test_that("Test run options", {
  skip_on_cran()
  opts <- opts_run()
  expect_s3_class(opts, c("OpenMppRunOpts", "list"))
  expect_output(print(opts))
})
