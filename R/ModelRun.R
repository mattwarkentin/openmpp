#' Model Run
#'
#' Functions to interrogate model runs.
#'
#' @inheritParams get_model
#' @inheritParams get_param_values
#'
#' @return A `list` from a JSON response object.
#'
#' @export
get_model_run_list <- function(model) {
  api_path <- glue::glue('api/model/{model}/run-list')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_run_list
#' @export
get_model_run_status <- function(model, run) {
  api_path <- glue::glue('api/model/{model}/run/{run}/status')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_run_list
#' @export
get_model_run_list_status <- function(model, run) {
  api_path <- glue::glue('api/model/{model}/run/{run}/status/list')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_run_list
#' @export
get_model_run_status_first <- function(model) {
  api_path <- glue::glue('api/model/{model}/run/status/first')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_run_list
#' @export
get_model_run_status_last <- function(model) {
  api_path <- glue::glue('api/model/{model}/run/status/last')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_run_list
#' @export
get_model_run_status_compl <- function(model) {
  api_path <- glue::glue('api/model/{model}/run/status/last-completed')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_run_list
#' @export
get_model_run <- function(model, run) {
  api_path <- glue::glue('api/model/{model}/run/{run}/text')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
