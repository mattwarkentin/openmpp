#' OncoSimX Model Worksets
#'
#' Functions for creating, copying, merging, retrieving, and deleting
#'   worksets.
#'
#' @param from Source workset name.
#' @param readonly Boolean. Should workset be read-only?
#' @inheritParams get_workset_param
#' @inheritParams get_model
#' @inheritParams get_run_microdata
#'
#' @return A `list`, `tibble`, or nothing (invisibly).
#'
#' @export
get_workset <- function(model, set) {
  api_path <- glue::glue('api/model/{model}/workset/{set}/text')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_workset
#' @export
get_worksets_list <- function(model) {
  api_path <- glue::glue('api/model/{model}/workset-list/text')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_workset
#' @export
get_worksets <- function(model) {
  get_worksets_list(model) |>
    tibblify::tibblify() |>
    suppressMessages()
}

#' @rdname get_workset
#' @export
get_workset_status <- function(model, set) {
  api_path <- glue::glue('api/model/{model}/workset/{set}/status')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_workset
#' @export
get_workset_status_default <- function(model, set) {
  api_path <- glue::glue('api/model/{model}/workset/status/default')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_workset
#' @export
set_workset_readonly <- function(model, set, readonly) {
  api_path <- glue::glue('/api/model/{model}/workset/{set}/readonly/{readonly}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform()
}

#' @rdname get_workset
#' @export
create_workset <- function(data) {
  api_path <- glue::glue('/api/workset-create')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data) |>
    httr2::req_method('PUT') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_workset
#' @export
replace_workset <- function(data) {
  api_path <- glue::glue('/api/workset-replace')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data) |>
    httr2::req_method('PUT') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_workset
#' @export
delete_workset <- function(model, set) {
  api_path <- glue::glue('/api/model/{model}/workset/{set}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_workset
#' @export
delete_workset_param <- function(model, set, name) {
  api_path <- glue::glue('/api/model/{model}/workset/{set}/parameter/{name}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_workset
#' @export
update_workset_param <- function(model, set, name, data) {
  api_path <- glue::glue('/api/model/{model}/workset/{set}/parameter/{name}/new/value')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data) |>
    httr2::req_method('PATCH') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_workset
#' @export
copy_param_run_to_workset <- function(model, set, name, run) {
  api_path <- glue::glue('/api/model/{model}/workset/{set}/copy/parameter/{name}/from-run/{run}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PUT') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_workset
#' @export
merge_param_run_to_workset <- function(model, set, name, run) {
  api_path <- glue::glue('/api/model/{model}/workset/{set}/merge/parameter/{name}/from-run/{run}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PATCH') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_workset
#' @export
copy_param_workset_to_workset <- function(model, set, name, from) {
  api_path <- glue::glue('/api/model/{model}/workset/{set}/copy/parameter/{name}/from-workset/{from}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PUT') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_workset
#' @export
merge_param_workset_to_workset <- function(model, set, name, from) {
  api_path <- glue::glue('/api/model/{model}/workset/{set}/merge/parameter/{name}/from-workset/{from}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PATCH') |>
    httr2::req_perform()
  invisible()
}
