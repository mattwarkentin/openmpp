#' Model Worksets
#'
#' Functions for getting information about worksets.
#'
#' @inheritParams get_param_values
#' @inheritParams get_model
#'
#' @return A `list` from a JSON response object.
#'
#' @export
get_workset_list <- function(model) {
  api_path <- glue::glue('api/model/{model}/workset-list/text')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_workset_list
#' @export
get_workset_status <- function(model, set) {
  api_path <- glue::glue('api/model/{model}/workset/{set}/status')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_workset_list
#' @export
get_workset_status_default <- function(model, set) {
  api_path <- glue::glue('api/model/{model}/workset/status/default')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_workset_list
#' @export
get_workset <- function(model, set) {
  api_path <- glue::glue('api/model/{model}/workset/{set}/text')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
