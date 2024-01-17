#' OpenM++ Administrative Tasks
#'
#' Functions for performing administrative tasks.
#'
#' @param pause Logical. Whether to pause or resume model runs queue processing.
#'
#' @return Nothing, invisibly.
#'
#' @export
admin_refresh_models <- function() {
  api_path <- 'api/admin/all-models/refresh'
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname admin_refresh_models
#' @export
admin_close_models <- function() {
  api_path <- 'api/admin/all-models/close'
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname admin_refresh_models
#' @export
admin_pause_models <- function(pause) {
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

#' @rdname admin_refresh_models
#' @export
admin_pause_all_models <- function(pause) {
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

#' @rdname admin_refresh_models
#' @export
admin_shutdown_service <- function() {
  api_path <- 'api/admin/shutdown'
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PUT') |>
    httr2::req_perform()
  invisible()
}
