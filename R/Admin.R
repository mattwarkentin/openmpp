#' OpenM++ Administrative Tasks
#'
#' Functions for performing administrative tasks.
#'
#' @param pause Logical. Whether to pause or resume model runs queue processing.
#' @param path Path to model database file relative to the `models/bin` folder.
#'   For example, the name of the model with a `".sqlite"` extension.
#' @param name Model name. Optional for `admin_database_cleanup()`.
#' @param model Model digest or model name.
#' @param digest Model digest. Optional for `admin_database_cleanup()`.
#'
#' @return A `list` or nothing, invisibly.
#'
#' @details
#' To find the relative `path` to a database file for cleanup with
#'   `admin_database_cleanup(path)` or opening a database file with
#'   `admin_database_open(path)`, users can run the `get_models_list()`
#'   function to retrieve the list of model information and find the `DbPath`
#'   list item. `DbPath` is the relative path to the database file. You
#'   must replace the forward-slashes in the relative path with asterisks.
#'
#' @export
admin_models_refresh <- function() {
  api_path <- 'api/admin/all-models/refresh'
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname admin_models_refresh
#' @export
admin_models_close <- function() {
  api_path <- 'api/admin/all-models/close'
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname admin_models_refresh
#' @export
admin_database_close <- function(model) {
  api_path <- glue::glue('/api/admin/model/{model}/close')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname admin_models_refresh
#' @export
admin_database_open <- function(path) {
  api_path <- glue::glue('api/admin/db-file-open/{path}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname admin_models_refresh
#' @export
admin_database_cleanup <- function(path, name = NULL, digest = NULL) {
  api_path <- glue::glue('api/admin/db-cleanup/{path}')

  if (!rlang::is_null(name) & rlang::is_null(digest)) {
    api_path <- glue::glue('{api_path}/name/{name}')
  }

  if (!rlang::is_null(name) & !rlang::is_null(digest)) {
    api_path <- glue::glue('{api_path}/name/{name}/digest/{digest}')
  }

  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname admin_models_refresh
#' @export
admin_cleanup_logs <- function() {
  api_path <- '/api/admin/db-cleanup/log-all'
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname admin_models_refresh
#' @export
admin_cleanup_log <- function(name) {
  api_path <- glue::glue('/api/admin/db-cleanup/log/{name}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname admin_models_refresh
#' @export
admin_jobs_pause <- function(pause) {
  if (!rlang::is_scalar_logical(pause)) {
    rlang::abort('`pause` must be a logical (TRUE or FALSE).')
  }
  api_path <- glue::glue('api/admin/jobs-pause/{pause}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname admin_models_refresh
#' @export
admin_jobs_pause_all <- function(pause) {
  if (!rlang::is_scalar_logical(pause)) {
    rlang::abort('`pause` must be a logical (TRUE or FALSE).')
  }
  api_path <- glue::glue('/api/admin-all/jobs-pause/{pause}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname admin_models_refresh
#' @export
admin_service_shutdown <- function() {
  api_path <- 'shutdown'
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PUT') |>
    httr2::req_perform()
  invisible()
}
