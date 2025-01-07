#' Download Model, Model Run Results, or Input Parameters
#'
#' Functions to download model, model run results, or input parameters. More
#'   information about these API endpoints can be found at
#'   [here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#download-model-model-run-results-or-input-parameters).
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
#' @param folder Download folder file name.
#'
#' @return Nothing, invisibly.
#'
#' @export
initiate_model_download <- function(model) {
  api_path <- glue::glue('api/download/model/{model}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(
      data = list(
        "NoAccumulatorsCsv" = TRUE,
        "NoMicrodata" = TRUE,
        "Utf8BomIntoCsv" = TRUE
      ),
      auto_unbox = TRUE
    ) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname initiate_model_download
#' @export
initiate_run_download <- function(model, run) {
  api_path <- glue::glue('/api/download/model/{model}/run/{run}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(
      data = list(
        "NoAccumulatorsCsv" = TRUE,
        "NoMicrodata" = TRUE,
        "Utf8BomIntoCsv" = TRUE
      ),
      auto_unbox = TRUE
    ) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname initiate_model_download
#' @export
initiate_workset_download <- function(model, set) {
  api_path <- glue::glue('/api/download/model/{model}/workset/{set}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(
      data = list(
        "NoAccumulatorsCsv" = TRUE,
        "NoMicrodata" = TRUE,
        "Utf8BomIntoCsv" = TRUE
      ),
      auto_unbox = TRUE
    ) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname initiate_model_download
#' @export
delete_download_files <- function(folder) {
  api_path <- glue::glue('/api/download/delete/{folder}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}

#' @rdname initiate_model_download
#' @export
delete_download_files_async <- function(folder) {
  api_path <- glue::glue('/api/download/start/delete/{folder}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}

#' @rdname initiate_model_download
#' @export
get_download_log <- function(name) {
  api_path <- glue::glue('/api/download/log/file/{name}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname initiate_model_download
#' @export
get_download_logs_model <- function(model) {
  api_path <- glue::glue('/api/download/log/model/{model}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname initiate_model_download
#' @export
get_download_logs_all <- function() {
  api_path <- glue::glue('/api/download/log/all')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname initiate_model_download
#' @export
get_download_filetree <- function(folder) {
  api_path <- glue::glue('/api/download/file-tree/{folder}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
