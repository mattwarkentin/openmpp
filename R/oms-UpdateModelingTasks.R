#' Update Modeling Tasks
#'
#' Functions for updating modeling tasks. More information about these API
#'   endpoints can be found at [here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#update-modeling-tasks).
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
create_task <- function(data) {
  api_path <- glue::glue('/api/task-new')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data, auto_unbox = TRUE) |>
    httr2::req_method('PUT') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname create_task
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

#' @rdname create_task
#' @export
delete_task <- function(model, task) {
  api_path <- glue::glue(' /api/model/{model}/task/{task}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}
