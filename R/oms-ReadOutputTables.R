#' Read Output Tables
#'
#' Functions for retrieving output tables from model runs. More information
#'   about these API endpoints can be found at [here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#read-parameters-output-tables-or-microdata-values).
#'
#' @inheritParams get_model
#' @param run Model run digest, run stamp or run name, modeling task run
#'   stamp or task run name.
#' @param name Output table name.
#' @param calc Name of calculation. One of `"avg"`, `"sum"`, `"count"`, `"max"`,
#'   `"min"`, `"var"`, `"sd"`, `"se"`, or `"cv"`.
#' @param compare Comparison to calculate. One of `"diff"`, `"ratio"`, or
#'   `"percent"`. Comparisons are for the base run relative to the variant
#'   run (i.e., for `"diff"` it is the difference of values represented as
#'   Variant - Base).
#' @param variant Run digest, name, or stamp for the variant model run.
#'
#' @return A `list` or `tibble`.
#'
#' @examples
#' \dontrun{
#' use_OpenMpp_local()
#' get_run_table_csv("RiskPaths", "53300e8b56eabdf5e5fb112059e8c137", "T01_LifeExpectancy")
#' }
#'
#' @export
get_run_table <- function(model, run, name) {
  api_path <- glue::glue(
    'api/model/{model}/run/{run}/table/{name}/exprstart/0/count/0'
  )
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_run_table
#' @export
get_run_table_csv <- function(model, run, name) {
  api_path <- glue::glue('api/model/{model}/run/{run}/table/{name}/expr/csv')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv(show_col_types = FALSE, progress = FALSE)
}

#' @rdname get_run_table
#' @export
get_run_table_acc_csv <- function(model, run, name) {
  api_path <- glue::glue('api/model/{model}/run/{run}/table/{name}/all-acc/csv')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv(show_col_types = FALSE, progress = FALSE)
}

#' @rdname get_run_table
#' @export
get_run_table_calc_csv <- function(model, run, name, calc) {
  rlang::arg_match(
    calc,
    c('avg', 'sum', 'count', 'max', 'min', 'var', 'sd', 'se', 'cv')
  )

  api_path <- glue::glue(
    'api/model/{model}/run/{run}/table/{name}/calc/{calc}/csv'
  )
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv(show_col_types = FALSE, progress = FALSE)
}

#' @rdname get_run_table
#' @export
get_run_table_comparison_csv <- function(model, run, name, compare, variant) {
  rlang::arg_match(compare, c('diff', 'ratio', 'percent'))

  api_path <- glue::glue(
    'api/model/{model}/run/{run}/table/{name}/compare/{compare}/variant/{variant}/csv'
  )
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv(show_col_types = FALSE, progress = FALSE)
}

utils::globalVariables(c('data'))
