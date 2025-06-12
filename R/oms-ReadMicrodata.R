#' Read Run Microdata
#'
#' Functions for retrieving microdata from model runs. More information about
#'   these API endpoints can be found at [here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#read-parameters-output-tables-or-microdata-values).
#'
#' @inheritParams get_model
#' @param run Model run digest, run stamp or run name, modeling task run
#'   stamp, or task run name.
#' @param name Microdata entity name.
#'
#' @return A `list` or `tibble`.
#'
#' @examples
#' \dontrun{
#' use_OpenMpp_local()
#' get_run_microdata_csv("RiskPaths", "53300e8b56eabdf5e5fb112059e8c137", "Person")
#' }
#'
#' @export
get_run_microdata <- function(model, run, name) {
  api_path <- glue::glue(
    'api/model/{model}/run/{run}/microdata/{name}/value/start/0/count/0'
  )
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
