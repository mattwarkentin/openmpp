#' OpenM++ Model Task
#'
#' Functions for getting creating, updating, retrieving, and deleting
#'   model tasks.
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
#' @inheritParams get_run_microdata
#' @param task Modeling task.
#'
#' @return A `list`, `tibble`, or nothing (invisibly).
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
  get_model_tasks_list(model) |>
    tibblify::tibblify() |>
    suppressMessages()
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

#' @rdname get_model_task
#' @export
create_task <- function(model, data) {
  api_path <- glue::glue('/api/task-new')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data, auto_unbox = TRUE) |>
    httr2::req_method('PUT') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
update_task <- function(model, data) {
  api_path <- glue::glue('/api/task')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data, auto_unbox = TRUE) |>
    httr2::req_method('PATCH') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
delete_task <- function(model, task) {
  api_path <- glue::glue(' /api/model/{model}/task/{task}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
}
