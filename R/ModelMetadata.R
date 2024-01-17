#' OpenM++ Model Metadata
#'
#' Functions to get the list of models and load a specific model definition.
#'
#' @param model Model digest or model name.
#'
#' @return A `list` or `tibble`.
#'
#' @md
#'
#' @export
get_model <- function(model) {
  if (!rlang::is_scalar_character(model)) {
    rlang::abort('`model` must be a string.')
  }
  api_path <- glue::glue('api/model/{model}/text')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model
#' @export
get_models <- function() {
  get_models_list() |>
    purrr::map(\(x) x$Model) |>
    purrr::map(tibble::as_tibble) |>
    purrr::list_rbind()
}

#' @rdname get_model
#' @export
get_models_list <- function() {
  api_path <- 'api/model-list/text'
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
