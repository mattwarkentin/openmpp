#' OpenM++ Model Run Jobs and Service State
#'
#' Functions for retrieving or deleting service information. More information about these API endpoints can be found at [here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#model-run-jobs-and-service-state).
#'
#' @param job Model run submission time stamp.
#' @param pos Position.
#'
#' @return A `list` from a JSON response object, or nothing (invisibly).
#'
#' @examples
#' \dontrun{
#' use_OpenMpp_local()
#' get_service_config()
#' get_service_state()
#' get_disk_use()
#' }
#'
#' @export
get_service_config <- function() {
  api_path <- 'api/service/config'
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_service_config
#' @export
get_service_state <- function() {
  api_path <- 'api/service/state'
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_service_config
#' @export
get_disk_use <- function() {
  api_path <- 'api/service/disk-use'
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_service_config
#' @export
refresh_disk_use <- function() {
  api_path <- 'api/service/disk-use/refresh'
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_service_config
#' @export
get_active_job_state <- function(job) {
  api_path <- glue::glue('api/service/job/active/{job}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_service_config
#' @export
get_queue_job_state <- function(job) {
  api_path <- glue::glue('api/service/job/queue/{job}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_service_config
#' @export
get_hist_job_state <- function(job) {
  api_path <- glue::glue('api/service/job/history/{job}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_service_config
#' @export
set_queue_job_pos <- function(pos, job) {
  api_path <- glue::glue('api/service/job/move/{pos}/{job}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PUT') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_service_config
#' @export
delete_job_hist <- function(job) {
  api_path <- glue::glue('api/service/job/delete/history/{job}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}
