local_initiate_oms <- function(oms_path, env = rlang::caller_env()) {
  cmd <- if (Sys.info()['sysname'] == 'Windows') '.\\bin\\oms.exe' else 'bin/oms'
  pid <-
    withr::with_dir(
      new = oms_path,
      code = sys::exec_background(cmd = cmd, std_out = FALSE)
    )
  withr::defer(tools::pskill(pid), envir = env)
  ensure_oms_running()
  pid
}

check_oms_running <- function(url = Sys.getenv('OPENMPP_LOCAL_URL')) {
  if (nchar(url) == 0L) url <- 'http://localhost:4040'
  port <- as.integer(gsub('http://localhost:', '', url))
  status <- pingr::is_up('localhost', port)
  if (status) return(TRUE)
  rlang::abort('OpenM++ Web Service (OMS) is not running.')
}

ensure_oms_running <-
  purrr::insistently(
    f = check_oms_running,
    rate = purrr::rate_delay(pause = 0.1, max_times = 100)
  )
