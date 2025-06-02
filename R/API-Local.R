#' OpenM++ Local API Connection
#'
#' Register a local connection to the OpenM++ Web Services (OMS) Application
#'   Programming Interface (API). Currently, two different API connections
#'   "local" and "remote" are available. Note that "local" and "remote"
#'   describe where the API is running relative to the machine running the R
#'   session. Those who use a machine running on their local network may use
#'   a remote connection to connect with a cloud-based API, for example.
#'   Users running OpenM++ locally or who are logged into a remote virtual
#'   machine running OpenM++ will use the local API connection.
#'
#' @param url URL for making API requests. See `Details` for more
#'   instructions.
#' @param ... Not currently used.
#'
#' @details We recommend declaring the API URL in your global or
#'   project-specific `.Renviron` file. For local and remote API connections,
#'   set the following environment variable in your `.Renviron` files:
#'
#'   - `OPENMPP_LOCAL_URL`: URL for a local API connection. Default is to use
#'     http://localhost:4040.
#'
#' @return Nothing, invisibly. Behind-the-scenes, an instance of the
#'   `OpenMppLocal` R6 class is created. These objects should not be accessed
#'   directly by the user, instead, the package internally uses these
#'   connections to communicate with the OpenM++ API.
#'
#' @md
#'
#' @examples
#' if (FALSE) {
#'   use_OpenMpp_local()
#' }
#'
#' @export
use_OpenMpp_local <- function(url = Sys.getenv('OPENMPP_LOCAL_URL'), ...) {
  rlang::check_dots_empty()
  if (nchar(url) == 0L) url <- 'http://localhost:4040'
  con <- OpenMppLocal$new(url)
  assign('API', con, OpenMpp)
  invisible()
}

OpenMppLocal <-
  R6::R6Class(
    classname = 'OpenMppLocal',
    inherit = OpenMppConnection,
    public = list(
      url = NULL,
      initialize = function(url) {
        self$url <- url
        invisible(self)
      },
      build_request = function() {
        httr2::request(self$url) |>
          httr2::req_url_path_append('api')
      }
    )
  )

OpenMppConnection <-
  R6::R6Class(
    classname = 'OpenMppConnection',
    public = list(
      build_request = function() {
        rlang::abort('Please register an API connection using `openmpp::use_OpenMpp_local()` or `openmpp::use_OpenMpp_remote()`.')
      }
    )
  )
