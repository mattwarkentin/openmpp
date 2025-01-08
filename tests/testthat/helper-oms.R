local_initiate_oms <- function(path, env = rlang::caller_env()) {
  cmd <- if (Sys.info()['sysname'] == 'Windows') '.\\bin\\oms.exe' else 'bin/oms'
  pid <-
    withr::with_dir(
      new = path,
      code = sys::exec_background(cmd = cmd, std_out = FALSE)
    )
  withr::defer(tools::pskill(pid), envir = env)
  ensure_oms_running(pid)
  allow_startup()
  pid
}

check_oms_running <- function(pid) {
  status <- sys::exec_status(pid, wait = FALSE)
  if (rlang::is_na(status)) return(TRUE)
  rlang::abort('OpenM++ Web Service (OMS) is not running.')
}

ensure_oms_running <-
  purrr::insistently(
    f = \(x) check_oms_running(x),
    rate = purrr::rate_delay(pause = 0.1, max_times = 10)
  )

allow_startup <- function(time = 1L) {
  Sys.sleep(time)
}
