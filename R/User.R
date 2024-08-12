#' Manage OpenM++ User Files or Settings
#'
#' Functions for getting, setting, and deleting user configuration settings.
#'
#' @param data Data used for the body of the request.
#' @param ext Comma-separated string of file extensions. Default is `"*"` which
#'   returns all files.
#' @param path Optional file path. Default is `""` (empty) and returns the
#'   entire tree of user files.
#' @inheritParams get_model
#' @inheritParams get_workset_param
#' @inheritParams get_run_microdata
#'
#' @return A `list` from JSON response object or nothing (invisibly).
#'
#' @export
get_user_views <- function(model) {
  api_path <- glue::glue('/api/user/view/model/{model}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_user_views
#' @export
set_user_views <- function(model, data) {
  api_path <- glue::glue('/api/user/view/model/{model}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data, auto_unbox = TRUE) |>
    httr2::req_method('PUT') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_user_views
#' @export
delete_user_views <- function(model) {
  api_path <- glue::glue('/api/user/view/model/{model}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_user_views
#' @export
get_user_files <- function(ext = "*", path = "") {
  api_path <- glue::glue('/api/files/file-tree/{ext}/path/{path}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
