local_initiate_oms <- function(path) {
  cmd <- if (Sys.info()['sysname'] == 'Windows') './bin/oms.exe' else './bin/oms'
  pid <-
    withr::with_dir(
      new = path,
      code = sys::exec_background(cmd = cmd, std_out = FALSE)
    )
  Sys.sleep(0.5)
  withr::defer_parent(tools::pskill(pid))
  pid
}
