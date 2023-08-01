#' Workset Parameters
#'
#' Functions for retrieving parameters from worksets.
#'
#' @inheritParams get_model
#' @param run Model run digest, run stamp or run name, modeling task run
#'   stamp or task run name.
#' @param set Name of workset (input set of model parameters).
#' @param data Data used for the body of the POST request.
#' @param name Output table name.
#'
#' @return A `list` from a JSON response object.
#'
#' @export
get_param_values <- function(model, set, data) {
  api_path <- glue::glue('api/model/{model}/workset/{set}/parameter/value')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_param_values
#' @export
get_run_param_values <- function(model, run, data) {
  api_path <- glue::glue('api/model/{model}/run/{run}/parameter/value')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_param_values
#' @export
get_workset_param_values <- function(model, set, name) {
  api_path <- glue::glue('api/model/{model}/workset/{set}/parameter/{name}/value')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_param_values
#' @export
get_model_run_param_values <- function(model, run, name, data) {
  api_path <- glue::glue('api/model/{model}/run/{run}/parameter/{name}/value')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_param_values
#' @export
get_workset_param_values_csv <- function(model, set, name, data) {
  api_path <- glue::glue('/api/model/{model}/workset/{set}/parameter/{name}/csv')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv()
}

#' @rdname get_param_values
#' @export
get_run_param_values_csv <- function(model, run, name, data) {
  api_path <- glue::glue('/api/model/{model}/run/{run}/parameter/{name}/csv')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv()
}

utils::globalVariables(c('data'))
