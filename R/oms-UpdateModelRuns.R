#' Update Model Runs
#'
#' Functions to update model runs. More information about these API endpoints
#'   can be found at [here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#update-model-runs).
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
#'
#' @return A `list`, `tibble`, or nothing (invisibly).
#'
#' @examples
#' \dontrun{
#' use_OpenMpp_local()
#' delete_model_run("RiskPaths", "53300e8b56eabdf5e5fb112059e8c137")
#' }
#'
#' @export
delete_model_run <- function(model, run) {
  api_path <- glue::glue('/api/model/{model}/run/{run}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}

#' @rdname delete_model_run
#' @export
delete_run <- delete_model_run

#' @rdname delete_model_run
#' @export
delete_model_runs <- function(model) {
  api_path <- glue::glue('/api/model/{model}/delete-runs')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname delete_model_run
#' @export
delete_runs <- delete_model_runs
