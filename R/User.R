#' Manage OpenM++ User Settings
#'
#' Functions for getting, setting, and deleting user configuration settings.
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
#' @inheritParams get_run_microdata
#'
#' @return A `list` from JSON response object or nothing (invisibly).
#'
#' @export
get_user_views <- function(model) {
  api_path <- glue::glue('/api/user/view/model/{model}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_user_views
#' @export
set_user_views <- function(model, data) {
  api_path <- glue::glue('/api/user/view/model/{model}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data = data) |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_user_views
#' @export
del_user_views <- function(model) {
  api_path <- glue::glue('/api/user/view/model/{model}')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}
