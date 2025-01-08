#' OpenM++ API Connections
#'
#' Register a connection to the OpenM++ Web Services (OMS) Application
#'   Programming Interface (API). Currently, two different API connections
#'   "local" and "remote" are available. Note that "local" and "remote"
#'   describe where the API is running relative to the machine running the R
#'   session. Those who use a machine running on their local network may use
#'   a remote connection to connect with a cloud-based API. Users running
#'   OpenM++ locally or who are logged into a remote virtual machine running
#'   OpenM++ will use the local API connection.
#'
#' @param url URL for making API requests. See `Details` for more
#'   instructions.
#' @param user User name for logging into remote API. See `Details` for more
#'   instructions.
#' @param pwd Password for logging into remote API. See `Details` for more
#'   instructions.
#' @param ... Not currently used.
#'
#' @details A `user` name and password (`pwd`) are sensitive information and
#'   should not be shared. To avoid hard-coding your user name and password into
#'   your R scripts, we recommend declaring this information in your global or
#'   project-specific `.Renviron` file. The same approach may be used to declare
#'   your URLs for making API requests. While these URLs are typically not
#'   sensitive information, keeping all of this information in one place makes
#'   sense for consistency. For local and remote API connections, set the
#'   following environment variables in your `.Renviron` files:
#'
#'   - `OPENMPP_LOCAL_URL`: URL for a local API connection. Default is to use
#'     http://localhost:4040.
#'   - `OPENMPP_REMOTE_URL`: URL for a remote API connection.
#'   - `OPENMPP_REMOTE_USER`: User name for logging into a remote API
#'     connection.
#'   - `OPENMPP_REMOTE_PWD`: Password for logging into a remote API connection.
#'
#' @return Nothing, invisibly. Behind-the-scenes, an instance of the
#' `OpenMppLocal` or `OpenMppRemote` R6 classes are created. These
#'   objects should not be accessed directly by the user, instead, the package
#'   internally uses these connections to communicate with the OpenM++ API.
#'
#' @md
#'
#' @export
use_OpenMpp_local <- function(url = Sys.getenv('OPENMPP_LOCAL_URL'), ...) {
  rlang::check_dots_empty()
  if (nchar(url) == 0L) url <- 'http://localhost:4040'
  con <- OpenMppLocal$new(url)
  assign('API', con, OpenMpp)
  invisible()
}

#' @rdname use_OpenMpp_local
#' @export
use_OpenMpp_remote <- function(
    url = Sys.getenv('OPENMPP_REMOTE_URL'),
    user = Sys.getenv('OPENMPP_REMOTE_USER'),
    pwd = Sys.getenv('OPENMPP_REMOTE_PWD'),
    ...
) {
  rlang::check_dots_empty()
  con <- OpenMppRemote$new(url, user, pwd)
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

OpenMppRemote <-
  R6::R6Class(
    classname = 'OpenMppRemote',
    inherit = OpenMppLocal,
    public = list(
      url = NULL,
      token = NULL,
      initialize = function(url, user, pwd) {
        super$initialize(url)
        private$login(user, pwd)
        self
      },
      build_request = function() {
        httr2::request(self$url) |>
          httr2::req_url_path_append('api') |>
          httr2::req_auth_bearer_token(self$token)
      }
    ),
    private = list(
      login = function(user, pwd) {
        self$token <-
          httr2::request(self$url) |>
          httr2::req_url_path_append('login') |>
          httr2::req_body_form(
            username = user,
            password = pwd
          ) |>
          httr2::req_perform() |>
          httr2::resp_body_string()
        invisible()
      },
      logout = function() {
        httr2::request(self$url) |>
          httr2::req_url_path_append('login') |>
          httr2::req_url_query(logout = 'true') |>
          httr2::req_auth_bearer_token(self$token) |>
          httr2::req_perform()
        invisible()
      },
      finalize = function() private$logout()
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
