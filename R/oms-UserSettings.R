#' Manage OpenM++ User Settings
#'
#' Functions for getting, setting, and deleting user settings. More information
#'   about these API endpoints can be found at [here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#user-manage-user-settings).
#'
#' @param data Data used for the body of the request.
#' @inheritParams get_model
#' @inheritParams get_workset_param
#' @inheritParams get_run_microdata
#'
#' @return A `list` from JSON response object or nothing (invisibly).
#'
#' @examples
#' if (FALSE) {
#'   get_user_views("RiskPaths")
#' }
#'
#' @export
get_user_views <- function(model) {
  api_path <- glue::glue('/api/user/view/model/{model}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_user_views
#' @export
set_user_views <- function(model, data) {
  api_path <- glue::glue('/api/user/view/model/{model}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data, auto_unbox = TRUE) |>
    httr2::req_method('PUT') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_user_views
#' @export
delete_user_views <- function(model) {
  api_path <- glue::glue('/api/user/view/model/{model}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}
