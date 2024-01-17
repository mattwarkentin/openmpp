#' OpenM++ Workset and Run Parameters
#'
#' Functions for retrieving parameters from worksets or model runs.
#'
#' @inheritParams get_model
#' @param run Model run digest, run stamp or run name, modeling task run
#'   stamp or task run name.
#' @param set Name of workset (input set of model parameters).
#' @param name Output table name.
#'
#' @return A `list` or `tibble`.
#'
#' @export
get_workset_param <- function(model, set, name) {
  api_path <- glue::glue('api/model/{model}/workset/{set}/parameter/{name}/value/start/0/count/0')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_workset_param
#' @export
get_workset_param_csv <- function(model, set, name) {
  api_path <- glue::glue('/api/model/{model}/workset/{set}/parameter/{name}/csv')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv(show_col_types = FALSE, progress = FALSE)
}

#' @rdname get_workset_param
#' @export
get_run_param <- function(model, run, name) {
  api_path <- glue::glue('api/model/{model}/run/{run}/parameter/{name}/value/start/0/count/0')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_workset_param
#' @export
get_run_param_csv <- function(model, run, name) {
  api_path <- glue::glue('/api/model/{model}/run/{run}/parameter/{name}/csv')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv(show_col_types = FALSE, progress = FALSE)
}

utils::globalVariables(c('data'))
