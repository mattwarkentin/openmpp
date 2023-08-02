#' Download model, model run results, or input parameters
#'
#' Functions to download model, model run results, or input parameters.
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
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(
      data = list(
        "NoAccumulatorsCsv" = TRUE,
        "NoMicrodata" = TRUE,
        "Utf8BomIntoCsv" = TRUE
      )
    ) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname initiate_model_download
#' @export
initiate_run_download <- function(model, run) {
  api_path <- glue::glue('/api/download/model/{model}/run/{run}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(
      data = list(
        "NoAccumulatorsCsv" = TRUE,
        "NoMicrodata" = TRUE,
        "Utf8BomIntoCsv" = TRUE
      )
    ) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname initiate_model_download
#' @export
initiate_workset_download <- function(model, set) {
  api_path <- glue::glue('/api/download/model/{model}/workset/{set}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(
      data = list(
        "NoAccumulatorsCsv" = TRUE,
        "NoMicrodata" = TRUE,
        "Utf8BomIntoCsv" = TRUE
      )
    ) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname initiate_model_download
#' @export
delete_download_files <- function(folder) {
  api_path <- glue::glue('/api/download/delete/{folder}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}

