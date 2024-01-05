#' OpenM++ Models
#'
#' Functions to get the complete list of models and load, run, or stop
#'   a specific model.
#'
#' @param model Model digest or model name.
#' @param stamp Model run stamp or modeling task run stamp.
#' @inheritParams get_run_microdata
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
  get_models_list() |>
    purrr::map(\(x) x$Model) |>
    tibblify::tibblify() |>
    suppressMessages()
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

#' @rdname get_model
#' @export
run_model <- function(data) {
  api_path <- '/api/run'
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data, auto_unbox = TRUE) |>
    httr2::req_method('POST') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model
#' @export
get_model_run_state <- function(model, stamp) {
  api_path <- glue::glue('/api/run/log/model/{model}/stamp/{stamp}/start/0/count/0')
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_model
#' @export
get_run_state <- get_model_run_state

#' @rdname get_model
#' @export
stop_model_run <- function(model, stamp) {
  api_path <- '/api/run/stop/model/{model}/stamp/{stamp}'
  httr2::request(api_url()) |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('PUT') |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
