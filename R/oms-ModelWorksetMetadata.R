#' Model Workset Metadata
#'
#' Functions for creating, copying, merging, retrieving, and deleting
#'   worksets. More information about these API endpoints can be found at
#'   [here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#get-model-workset-metadata-set-of-input-parameters).
#'
#' @inheritParams get_workset_param
#' @inheritParams get_model
#' @inheritParams get_run_microdata
#'
#' @return A `list`, `tibble`, or nothing (invisibly).
#'
#' @examples
#' if (FALSE) {
#'   get_worksets("RiskPaths")
#'   get_scenarios("RiskPaths")
#'   get_workset("RiskPaths", "Default")
#' }
#'
#'
#' @export
get_workset <- function(model, set) {
  api_path <- glue::glue('api/model/{model}/workset/{set}/text')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_workset
#' @export
get_worksets_list <- function(model) {
  api_path <- glue::glue('api/model/{model}/workset-list/text')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_workset
#' @export
get_worksets <- function(model) {
  get_worksets_list(model) |>
    purrr::map(purrr::compact) |>
    purrr::map(tibble::as_tibble) |>
    purrr::list_rbind()
}

#' @rdname get_workset
#' @export
get_scenarios <- get_worksets

#' @rdname get_workset
#' @export
get_workset_status <- function(model, set) {
  api_path <- glue::glue('api/model/{model}/workset/{set}/status')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' @rdname get_workset
#' @export
get_workset_status_default <- function(model) {
  api_path <- glue::glue('api/model/{model}/workset/status/default')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
