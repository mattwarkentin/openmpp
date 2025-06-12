#' Update Workset Metadata
#'
#' Functions for creating, copying, merging, retrieving, and deleting
#'   worksets. More information about these API endpoints can be found at
#'   [here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#update-model-workset-set-of-input-parameters).
#'
#' @param from Source workset name.
#' @param readonly Boolean. Should workset be read-only?
#' @param csv CSV file path.
#' @param workset Workset metadata.
#' @param data Data used for the body of the request.
#' @inheritParams get_workset_param
#' @inheritParams get_model
#' @inheritParams get_run_microdata
#'
#' @return A `list`, `tibble`, or nothing (invisibly).
#'
#' @examples
#' \dontrun{
#' use_OpenMpp_local()
#' set_workset_readonly("RiskPaths", "Default", TRUE)
#' }
#'
#' @export
set_workset_readonly <- function(model, set, readonly) {
  api_path <- glue::glue('/api/model/{model}/workset/{set}/readonly/{readonly}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname set_workset_readonly
#' @export
new_workset <- function(data) {
  api_path <- glue::glue('/api/workset-create')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data, auto_unbox = TRUE) |>
    httr2::req_method('PUT') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname set_workset_readonly
#' @export
merge_workset <- function(workset) {
  api_path <- glue::glue('/api/workset-merge')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_multipart(
      workset = jsonlite::toJSON(workset, auto_unbox = TRUE)
    ) |>
    httr2::req_method('PATCH') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname set_workset_readonly
#' @export
update_workset_param_csv <- function(workset, csv) {
  api_path <- glue::glue('/api/workset-merge')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_multipart(
      workset = jsonlite::toJSON(workset, auto_unbox = TRUE),
      `parameter-csv` = curl::form_file(csv)
    ) |>
    httr2::req_method('PATCH') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname set_workset_readonly
#' @export
replace_workset <- function(workset) {
  api_path <- glue::glue('/api/workset-replace')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_multipart(
      workset = jsonlite::toJSON(workset, auto_unbox = TRUE)
    ) |>
    httr2::req_method('PUT') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname set_workset_readonly
#' @export
delete_workset <- function(model, set) {
  api_path <- glue::glue('/api/model/{model}/workset/{set}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}

#' @rdname set_workset_readonly
#' @export
delete_scenario <- delete_workset

#' @rdname set_workset_readonly
#' @export
delete_workset_param <- function(model, set, name) {
  api_path <- glue::glue('/api/model/{model}/workset/{set}/parameter/{name}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}

#' @rdname set_workset_readonly
#' @export
update_workset_param <- function(model, set, name, data) {
  api_path <- glue::glue(
    '/api/model/{model}/workset/{set}/parameter/{name}/new/value'
  )
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data, auto_unbox = TRUE) |>
    httr2::req_method('PATCH') |>
    httr2::req_perform()
  invisible()
}

#' @rdname set_workset_readonly
#' @export
copy_param_run_to_workset <- function(model, set, name, run) {
  api_path <- glue::glue(
    '/api/model/{model}/workset/{set}/copy/parameter/{name}/from-run/{run}'
  )
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PUT') |>
    httr2::req_perform()
  invisible()
}

#' @rdname set_workset_readonly
#' @export
merge_param_run_to_workset <- function(model, set, name, run) {
  api_path <- glue::glue(
    '/api/model/{model}/workset/{set}/merge/parameter/{name}/from-run/{run}'
  )
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PATCH') |>
    httr2::req_perform()
  invisible()
}

#' @rdname set_workset_readonly
#' @export
copy_param_workset_to_workset <- function(model, set, name, from) {
  api_path <- glue::glue(
    '/api/model/{model}/workset/{set}/copy/parameter/{name}/from-workset/{from}'
  )
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PUT') |>
    httr2::req_perform()
  invisible()
}

#' @rdname set_workset_readonly
#' @export
merge_param_workset_to_workset <- function(model, set, name, from) {
  api_path <- glue::glue(
    '/api/model/{model}/workset/{set}/merge/parameter/{name}/from-workset/{from}'
  )
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PATCH') |>
    httr2::req_perform()
  invisible()
}

#' @rdname set_workset_readonly
#' @export
upload_workset_params <- function(model, set, data) {
  api_path <- glue::glue('/api/upload/model/{model}/workset')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_multipart(
      filename = curl::form_file(data)
    ) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}
