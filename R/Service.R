#' OpenM++ Service State
#'
#' Functions for retrieving or deleting service information.
#'
#' @param job Model run submission time stamp.
#' @param pos Position.
#'
#' @return A `list` from a JSON response object, or nothing (invisibly).
#'
#' @export
get_service_config <- function() {
  api_path <- 'api/service/config'
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_service_config
#' @export
get_service_state <- function() {
  api_path <- 'api/service/state'
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_service_config
#' @export
get_active_job_state <- function(job) {
  api_path <- glue::glue('api/service/job/active/{job}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_service_config
#' @export
get_queue_job_state <- function(job) {
  api_path <- glue::glue('api/service/job/queue/{job}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_service_config
#' @export
get_hist_job_state <- function(job) {
  api_path <- glue::glue('api/service/job/history/{job}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_service_config
#' @export
set_queue_job_pos <- function(pos, job) {
  api_path <- glue::glue('api/service/job/move/{pos}/{job}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PUT') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_service_config
#' @export
delete_job_hist <- function(job) {
  api_path <- glue::glue('api/service/job/delete/history/{job}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_service_config
#' @export
get_archive_state <- function() {
  api_path <- glue::glue('api/archive/state')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
