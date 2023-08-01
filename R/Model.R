#' Model
#'
#' Functions to get the complete list of models and load
#'   a specific model.
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
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model
#' @export
get_models <- function() {
  get_model_list() |>
    tibblify::tibblify() |>
    tidyr::unnest(tidyr::everything())
}

#' @rdname get_model
#' @export
get_models_list <- function() {
  api_path <- 'api/model-list/text'
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
