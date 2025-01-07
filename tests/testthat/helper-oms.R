local_initiate_oms <- function(path) {
  pid <-
    withr::with_dir(
      new = path,
      code = sys::exec_background(cmd = './bin/oms', std_out = FALSE)
    )
  Sys.sleep(0.5)
  withr::defer_parent(tools::pskill(pid))
  pid
}
