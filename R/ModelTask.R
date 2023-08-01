#' Model Task
#'
#' Functions for getting information about model tasks.
#'
#' @inheritParams get_model
#' @inheritParams get_param_values
#' @param task Modeling task.
#'
#' @return A `list` from a JSON response object.
#'
#' @export
get_model_task <- function(model, task) {
  api_path <- glue::glue('/api/model/{model}/task/{task}/text')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_tasks_list <- function(model) {
  api_path <- glue::glue('api/model/{model}/task-list')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_tasks <- function(model) {
  api_path <- glue::glue('api/model/{model}/task-list')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    tibblify::tibblify()
}

#' @rdname get_model_task
#' @export
get_model_task_worksets <- function(model, task) {
  api_path <- glue::glue('api/model/{model}/task/{task}/sets')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_task_hist <- function(model, task) {
  api_path <- glue::glue('api/model/{model}/task/{task}/runs')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_task_status <- function(model, task, run) {
  api_path <- glue::glue('api/model/{model}/task/{task}/run-status/run/{run}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_task_run_list_status <- function(model, task, run) {
  api_path <- glue::glue('api/model/{model}/task/{task}/run-status/list/{run}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_task_run_first <- function(model, task) {
  api_path <- glue::glue('api/model/{model}/task/{task}/run-status/first')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_task_run_last <- function(model, task) {
  api_path <- glue::glue('api/model/{model}/task/{task}/run-status/last')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_task_run_compl <- function(model, task) {
  api_path <- glue::glue('api/model/{model}/task/{task}/run-status/last-completed')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
