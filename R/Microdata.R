#' Parameters, Output Tables, or Microdata
#'
#' Functions for retrieving parameters, output tables, and microdata from
#'   models, model runs, and worksets.
#'
#' @inheritParams get_model
#' @param run Model run digest, run stamp or run name, modeling task run
#'   stamp or task run name.
#' @param data Data used for the body of the POST request.
#' @param name Output table name.
#'
#' @return A `list` from a JSON response object.
#'
#' @export
get_run_micro_values <- function(model, run, data) {
  api_path <- glue::glue('api/model/{model}/run/{run}/microdata/value')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_run_micro_values
#' @export
get_model_mirco_value <- function(model, run, name, data) {
  api_path <- glue::glue('api/model/{model}/run/{run}/microdata/{name}/value')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
#' @rdname get_run_micro_values
#' @export
get_model_mirco_value_csv <- function(model, run, name, data) {
  api_path <- glue::glue('api/model/{model}/run/{run}/microdata/{name}/csv')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv()
}

utils::globalVariables(c('data'))
