check_oms_running <- function(url = Sys.getenv('OPENMPP_LOCAL_URL')) {
  if (nchar(url) == 0L) {
    url <- 'http://localhost:4040'
  }
  port <- as.integer(gsub('http://localhost:', '', url))
  status <- pingr::is_up('localhost', port)
  if (status) {
    return(TRUE)
  }
  rlang::abort('OpenM++ Web Service (OMS) is not running.')
}

ensure_oms_running <-
  purrr::insistently(
    f = check_oms_running,
    rate = purrr::rate_delay(pause = 0.5, max_times = 5)
  )

test_connection <- function(oms_path) {
  tryCatch(
    {
      ensure_oms_running()
      return(TRUE)
    },
    error = function(e) {
      FALSE
    }
  )
}
