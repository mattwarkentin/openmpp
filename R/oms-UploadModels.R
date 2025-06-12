#' Upload Model Runs or Worksets
#'
#' Functions to upload model run results or input parameters (worksets). More information about these API endpoints can be found at [here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#upload-model-runs-or-worksets).
#'
#' @param folder Upload folder file name.
#' @param data Data used for the body of the request.
#' @inheritParams get_model
#' @inheritParams get_workset_param
#'
#' @return Nothing, invisibly.
#'
#' @examples
#' \dontrun{
#' use_OpenMpp_local()
#' get_upload_logs_all()
#' }
#'
#' @export
initiate_run_upload <- function(model, run, data) {
  api_path <- glue::glue('/api/upload/model/{model}/run/{run}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data, auto_unbox = TRUE) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname initiate_run_upload
#' @export
initiate_workset_upload <- function(model, set, data) {
  api_path <- glue::glue('/api/upload/model/{model}/workset/{set}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data, auto_unbox = TRUE) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname initiate_run_upload
#' @export
delete_upload_files <- function(folder) {
  api_path <- glue::glue('/api/upload/delete/{folder}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}

#' @rdname initiate_run_upload
#' @export
delete_upload_files_async <- function(folder) {
  api_path <- glue::glue('/api/upload/start/delete/{folder}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}

#' @rdname initiate_run_upload
#' @export
get_upload_log <- function(name) {
  api_path <- glue::glue('/api/upload/log/file/{name}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname initiate_run_upload
#' @export
get_upload_logs_model <- function(model) {
  api_path <- glue::glue('/api/upload/log/model/{model}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname initiate_run_upload
#' @export
get_upload_logs_all <- function() {
  api_path <- glue::glue('/api/upload/log-all')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname initiate_run_upload
#' @export
get_upload_filetree <- function(folder) {
  api_path <- glue::glue('/api/upload/file-tree/{folder}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
