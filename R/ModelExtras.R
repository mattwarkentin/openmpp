#' OpenM++ Model Extras
#'
#' Functions for retrieving extra model information, including language lists,
#'   word lists, profiles, and profile lists.
#'
#' @inheritParams get_model
#' @inheritParams touch_model_profile
#'
#' @return A `list` from a JSON response object.
#'
#' @export
get_model_lang_list <- function(model) {
  api_path <- glue::glue('api/model/{model}/lang-list')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_lang_list
#' @export
get_model_word_list <- function(model) {
  api_path <- glue::glue('api/model/{model}/word-list')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_lang_list
#' @export
get_model_profile <- function(model, profile) {
  api_path <- glue::glue('api/model/{model}/profile/{profile}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model_lang_list
#' @export
get_model_profile_list <- function(model) {
  api_path <- glue::glue('api/model/{model}/profile-list')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
