#' OpenM++ CPAC API Connection
#'
#' Register a connection to the OpenM++ Web Services (OMS) Application
#'   Programming Interface (API) running on the CPAC cloud-based server.
#'
#' @param url URL for making login requests. See `Details` for more
#'   instructions.
#' @param api URL for making API requests. See `Details` for more instructions.
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
#'   sense for consistency. For remote API connections to CPAC, set the
#'   following environment variables in your `.Renviron` files:
#'
#'   - `OPENMPP_CPAC_URL`: URL for a local API connection.
#'   - `OPENMPP_CPAC_API`: URL for a remote API connection.
#'   - `OPENMPP_CPAC_USER`: User name for logging into the remote API
#'     connection.
#'   - `OPENMPP_CPAC_PWD`: Password for logging into the remote API connection.
#'
#' @return Nothing, invisibly. Behind-the-scenes, an instance of the
#'   `OpenMppCPAC` R6 classe is created. This objects should not be accessed
#'   directly by the user, instead, the package internally uses these
#'   connections to communicate with the OpenM++ API.
#'
#' @md
#'
#' @export
#' @rdname use_OpenMpp_CPAC
#' @export
use_OpenMpp_CPAC <- function(
    url = Sys.getenv('OPENMPP_CPAC_URL'),
    api = Sys.getenv('OPENMPP_CPAC_API'),
    user = Sys.getenv('OPENMPP_CPAC_USER'),
    pwd = Sys.getenv('OPENMPP_CPAC_PWD'),
    ...
) {
  rlang::check_dots_empty()
  con <- OpenMppCPAC$new(url, api, user, pwd)
  assign('API', con, OpenMpp)
  invisible()
}

OpenMppCPAC <-
  R6::R6Class(
    classname = 'OpenMppCPAC',
    inherit = OpenMppLocal,
    public = list(
      url = NULL,
      api = NULL,
      token = NULL,
      initialize = function(url, api, user, pwd) {
        super$initialize(url)
        self$api <- api
        private$login(user, pwd)
        self
      },
      build_request = function() {
        httr2::request(self$api) |>
          httr2::req_url_path_append('api') |>
          httr2::req_cookies_set(jwt_token = self$token)
      }
    ),
    private = list(
      login = function(user, pwd) {
        self$token <-
          httr2::request(self$url) |>
          httr2::req_url_path_append('login') |>
          httr2::req_headers(
            "Accept" = "application/json",
            "Content-Type" = "application/json"
          ) |>
          httr2::req_body_json(list(
            username = user,
            password = pwd,
            realm = 'local'
          )) |>
          httr2::req_method('POST') |>
          httr2::req_perform() |>
          httr2::resp_body_json() |>
          purrr::chuck('token')
        invisible()
      },
      logout = function() {
        httr2::request(self$url) |>
          httr2::req_url_path_append('logout') |>
          httr2::req_auth_bearer_token(self$token) |>
          httr2::req_perform()
        invisible()
      },
      finalize = function() private$logout()
    )
  )
