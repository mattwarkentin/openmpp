#' OpenM++ Model Task
#'
#' Functions for getting creating, updating, retrieving, and deleting
#'   model tasks.
#'
#' @param data Data used for the body of the request.
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
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_tasks_list <- function(model) {
  api_path <- glue::glue('api/model/{model}/task-list')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_tasks <- function(model) {
  get_model_tasks_list(model) |>
    purrr::map(tibble::as_tibble) |>
    purrr::list_rbind()
}

#' @rdname get_model_task
#' @export
get_model_task_worksets <- function(model, task) {
  api_path <- glue::glue('api/model/{model}/task/{task}/sets')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_task_hist <- function(model, task) {
  api_path <- glue::glue('api/model/{model}/task/{task}/runs')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_task_status <- function(model, task, run) {
  api_path <- glue::glue('api/model/{model}/task/{task}/run-status/run/{run}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_task_run_list_status <- function(model, task, run) {
  api_path <- glue::glue('api/model/{model}/task/{task}/run-status/list/{run}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_task_run_first <- function(model, task) {
  api_path <- glue::glue('api/model/{model}/task/{task}/run-status/first')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_task_run_last <- function(model, task) {
  api_path <- glue::glue('api/model/{model}/task/{task}/run-status/last')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
get_model_task_run_compl <- function(model, task) {
  api_path <- glue::glue('api/model/{model}/task/{task}/run-status/last-completed')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
create_task <- function(data) {
  api_path <- glue::glue('/api/task-new')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data, auto_unbox = TRUE) |>
    httr2::req_method('PUT') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_task
#' @export
update_task <- function(data) {
  api_path <- glue::glue('/api/task')
  OpenMpp$API$build_request() |>
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
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}
