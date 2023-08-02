#' Upload model runs or worksets
#'
#' Functions to upload model run results or input parameters (worksets).
#'
#' @param folder Upload folder file name.
#' @inheritParams get_model
#' @inheritParams get_workset_param
#'
#' @return Nothing, invisibly.
#'
#' @export
initiate_run_upload <- function(model, run, data) {
  api_path <- glue::glue('/api/upload/model/{model}/run/{run}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname initiate_run_upload
#' @export
initiate_workset_upload <- function(model, set, data) {
  api_path <- glue::glue('/api/upload/model/{model}/workset/{set}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname initiate_run_upload
#' @export
delete_upload_files <- function(folder) {
  api_path <- glue::glue('/api/upload/delete/{folder}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}
