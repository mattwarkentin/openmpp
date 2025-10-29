#' OpenM++ CPAC API Connection
#'
#' Register a connection to the OpenM++ Web Services (OMS) Application
#'   Programming Interface (API) running on the CPAC cloud-based server.
#'
#' @param url URL for making API requests. See `Details` for more
#'   instructions.
#' @param key API Key for making requests.
#' @param ... Not currently used.
#'
#' @details An API key is sensitive information and should not be shared.
#'   To avoid hard-coding your user name and password into your R scripts, we
#'   recommend declaring this information in your global or project-specific
#'   `.Renviron` file. The same approach may be used to declare
#'   your URL for making API requests. While the URL us typically not
#'   sensitive information, keeping all of this information in one place makes
#'   sense for consistency. For remote API connections to CPAC, set the
#'   following environment variables in your `.Renviron` files:
#'
#'   - `OPENMPP_CPAC_URL`: URL for making remote API requests.
#'   - `OPENMPP_CPAC_KEY`: API key for making remote API requests.
#'
#' @return Nothing, invisibly. Behind-the-scenes, an instance of the
#'   `OpenMppCPAC` R6 class is created. This objects should not be accessed
#'   directly by the user, instead, the package internally uses these
#'   connections to communicate with the OpenM++ API.
#'
#' @md
#'
#' @examples
#' \dontrun{
#' use_OpenMpp_CPAC()
#' }
#'
#' @export
#' @rdname use_OpenMpp_CPAC
#' @export
use_OpenMpp_CPAC <- function(
  url = Sys.getenv('OPENMPP_CPAC_URL'),
  key = Sys.getenv('OPENMPP_CPAC_KEY'),
  ...
) {
  rlang::check_dots_empty()

  con <- OpenMppCustom$new(CPAC_API_request(url, key))
  assign('API', con, OpenMpp)
  invisible()
}


CPAC_API_request <- function(url, key) {
  function(auth) {
    httr2::request(url) |>
      httr2::req_headers_redacted("X-Api-Key" = key)
  }
}
