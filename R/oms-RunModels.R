#' Run Models and Monitor Progress
#'
#' More information about these API endpoints can be found at
#' [here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#run-models-run-models-and-monitor-progress).
#'
#' @param data Data used for the body of the POST request.
#' @param model Model digest or name.
#' @param stamp Model run stamp.
#'
#' @return A `list` or nothing, invisibly.
#'
#' @examples
#' if (FALSE) {
#'   get_model_run_state("RiskPaths", "2025_01_28_21_00_48_385")
#' }
#'
#' @export
run_model <- function(data) {
  api_path <- '/api/run'
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data, auto_unbox = TRUE) |>
    httr2::req_method('POST') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname run_model
#' @export
get_model_run_state <- function(model, stamp) {
  api_path <- glue::glue('/api/run/log/model/{model}/stamp/{stamp}/start/0/count/0')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname run_model
#' @export
get_run_state <- get_model_run_state

#' @rdname run_model
#' @export
stop_model_run <- function(model, stamp) {
  api_path <- '/api/run/stop/model/{model}/stamp/{stamp}'
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PUT') |>
    httr2::req_perform()
  invisible()
}

#' @rdname run_model
#' @export
stop_run <- stop_model_run
