#' OpenM++ Custom API Connection
#'
#' Register a custom connection to the OpenM++ Web Services (OMS) Application
#'   Programming Interface (API). A custom conneciton is typically comprised of
#'   two main tasks: (1) authentication and (2) building the request. To create
#'   your own custom connection, you simply need to create a function (`req`)
#'   that performs authentication (if needed) and builds the initial portion the
#'   API request using the authentication information.
#'
#' @param req A function that that performs any required user authentication
#'   with the API and builds the initial part of the API request
#'   including handling the authentication. Calling `req()` should return a
#'   `httr2_request` object.
#' @param ... Not currently used.
#'
#' @return Nothing, invisibly. Behind-the-scenes, an instance of the
#'   `OpenMppCustom` R6 class is created. These objects should not be accessed
#'   directly by the user, instead, the package internally uses these
#'   connections to communicate with the OpenM++ OMS API.
#'
#' @md
#'
#' @export
use_OpenMpp_custom <- function(req, ...) {
  rlang::check_dots_empty()
  con <- OpenMppCustom$new(req)
  assign(x = 'API', value = con, envir = OpenMpp)
  invisible()
}

OpenMppCustom <-
  R6::R6Class(
    classname = 'OpenMppCustom',
    inherit = OpenMppConnection,
    public = list(
      req = NULL,
      initialize = function(req) {
        self$req <- req
        self
      },
      build_request = function() {
        self$req()
      }
    )
  )
