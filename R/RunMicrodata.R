#' OpenM++ Run Microdata
#'
#' Functions for retrieving microdata from model runs.
#'
#' @inheritParams get_model
#' @param run Model run digest, run stamp or run name, modeling task run
#'   stamp, or task run name.
#' @param name Output table name.
#'
#' @return A `list` or `tibble`.
#'
#' @export
get_run_microdata <- function(model, run, name) {
  api_path <- glue::glue('api/model/{model}/run/{run}/microdata/{name}/value/start/0/count/0')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_run_microdata
#' @export
get_run_microdata_csv <- function(model, run, name) {
  api_path <- glue::glue('api/model/{model}/run/{run}/microdata/{name}/csv')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv(show_col_types = FALSE, progress = FALSE)
}

utils::globalVariables(c('data'))
