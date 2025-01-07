#' Manage OpenM++ User Files
#'
#' Functions for getting, setting, and deleting user file.
#'
#' @param ext Comma-separated string of file extensions. Default is `"*"` which
#'   returns all files.
#' @param path Optional file path. Default is `""` (empty) and returns the
#'   entire tree of user files.
#'
#' @return A `list` from JSON response object or nothing (invisibly).
#'
#' @export
get_user_files <- function(ext = "*", path = "") {
  api_path <- glue::glue('/api/files/file-tree/{ext}/path/{path}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_user_files
#' @export
upload_user_files <- function(path) {
  api_path <- glue::glue('/api/files/file/{path}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PUT') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_user_files
#' @export
create_user_files_folder <- function(path) {
  api_path <- glue::glue('/api/files/folder/{path}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PUT') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_user_files
#' @export
delete_user_files <- function(path) {
  api_path <- glue::glue('/api/files/delete/{path}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}

#' @rdname get_user_files
#' @export
delete_user_files_all <- function() {
  api_path <- glue::glue('/api/files/delete-all')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}
