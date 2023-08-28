#' OncoSimX Model Profile
#'
#' Functions for creating, modifying, and deleting profiles and profile options.
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
#' @inheritParams get_run_microdata
#' @param profile Profile name.
#' @param key Option key.
#' @param value Option value.
#'
#' @return A `list` from a JSON response object or nothing (invisibly).
#'
#' @export
touch_model_profile <- function(model, data) {
  api_path <- glue::glue('api/model/{model}/profile')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data, auto_unbox = TRUE) |>
    httr2::req_method('PATCH') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname touch_model_profile
#' @export
delete_model_profile <- function(model, profile) {
  api_path <- glue::glue('api/model/{model}/profile/{profile}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname touch_model_profile
#' @export
set_model_profile_opt <- function(model, profile, key, value) {
  api_path <- glue::glue('api/model/{model}/profile/{profile}/key/{key}/value/{value}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname touch_model_profile
#' @export
delete_model_profile_opt <- function(model, profile, key) {
  api_path <- glue::glue('api/model/{model}/profile/{profile}/key/{key}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}
