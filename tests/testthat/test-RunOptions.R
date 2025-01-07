test_that("Run options work", {
  opts <- opts_run()
  expect_s3_class(opts, c("OpenMppRunOpts", "list"))
})
