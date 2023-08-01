#' Output Tables
#'
#' Functions for retrieving parameters, output tables, and microdata from
#'   models, model runs, and worksets.
#'
#' @inheritParams get_model
#' @param run Model run digest, run stamp or run name, modeling task run
#'   stamp or task run name.
#' @param data Data used for the body of the POST request.
#' @param calc Name of additional measure to calculate.
#' @param name Output table name.
#'
#' @return A `list` from a JSON response object.
#'
#' @export
get_run_table_values <- function(model, run, data) {
  api_path <- glue::glue('api/model/{model}/run/{run}/table/value')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_run_table_values
#' @export
get_run_table_calc <- function(model, run, data) {
  api_path <- glue::glue('api/model/{model}/run/{run}/table/calc')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_run_table_values
#' @export
get_model_table_expr <- function(model, run, name, data) {
  api_path <- glue::glue('api/model/{model}/run/{run}/table/{name}/expr')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_run_table_values
#' @export
get_model_table_expr_calc <- function(model, run, name, calc, data) {
  api_path <- glue::glue('api/model/{model}/run/{run}/table/{name}/calc/{calc}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_run_table_values
#' @export
get_model_table_acc <- function(model, run, name, data) {
  api_path <- glue::glue('api/model/{model}/run/{run}/table/{name}/acc')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_run_table_values
#' @export
get_model_table_all_acc <- function(model, run, name, data) {
  api_path <- glue::glue('api/model/{model}/run/{run}/table/{name}/all-acc')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_run_table_values
#' @export
get_run_table_expr_csv <- function(model, run, name) {
  api_path <- glue::glue('api/model/{model}/run/{run}/table/{name}/expr/csv')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv()
}

#' @rdname get_run_table_values
#' @export
get_run_table_calc_csv <- function(model, run, name, calc) {
  api_path <- glue::glue('api/model/{model}/run/{run}/table/{name}/calc/{calc}/csv')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv()
}

#' @rdname get_run_table_values
#' @export
get_model_table_acc_csv <- function(model, run, name, data) {
  api_path <- glue::glue('api/model/{model}/run/{run}/table/{name}/acc/csv')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv()
}

#' @rdname get_run_table_values
#' @export
get_model_table_all_acc_csv <- function(model, run, name, data) {
  api_path <- glue::glue('api/model/{model}/run/{run}/table/{name}/all-acc/csv')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv()
}

utils::globalVariables(c('data'))
