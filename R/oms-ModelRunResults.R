#' Model Run Results Metadata
#'
#' Functions to retrieve model run metadata and delete model runs. More
#'   information about these API endpoints can be found at [here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#get-model-run-results-metadata).
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
#'
#' @return A `list`, `tibble`, or nothing (invisibly).
#'
#' @export
get_model_run <- function(model, run) {
  api_path <- glue::glue('api/model/{model}/run/{run}/text')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_run
#' @export
get_run <- get_model_run

#' @rdname get_model_run
#' @export
get_model_runs_list <- function(model) {
  api_path <- glue::glue('api/model/{model}/run-list')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_run
#' @export
get_model_runs <- function(model) {
  get_model_runs_list(model) |>
    purrr::map(purrr::compact) |>
    purrr::map(tibble::as_tibble) |>
    purrr::list_rbind()
}

#' @rdname get_model_run
#' @export
get_runs <- get_model_runs

#' @rdname get_model_run
#' @export
get_model_run_status <- function(model, run) {
  api_path <- glue::glue('api/model/{model}/run/{run}/status')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_run
#' @export
get_run_status <- get_model_run_status

#' @rdname get_model_run
#' @export
get_model_run_list_status <- function(model, run) {
  api_path <- glue::glue('api/model/{model}/run/{run}/status/list')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_run
#' @export
get_model_run_status_first <- function(model) {
  api_path <- glue::glue('api/model/{model}/run/status/first')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_run
#' @export
get_model_run_status_last <- function(model) {
  api_path <- glue::glue('api/model/{model}/run/status/last')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_run
#' @export
get_model_run_status_compl <- function(model) {
  api_path <- glue::glue('api/model/{model}/run/status/last-completed')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
