#' Update Model Profile
#'
#' Functions for creating, modifying, and deleting profiles and profile options.
#'   More information about these API endpoints can be found at
#'   [here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#update-model-profile-set-of-key-value-options).
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
#' @inheritParams get_run_microdata
#' @param profile Profile name.
#' @param key Option key.
#' @param value Option value.
#' @param data Data used for the body of the request.
#'
#' @return A `list` from a JSON response object or nothing (invisibly).
#'
#' @examples
#' \dontrun{
#' use_OpenMpp_local()
#' touch_model_profile(
#'   "RiskPaths",
#'   list(Name = "profile1", Opts = list(Parameter.StartingSeed = "192"))
#' )
#' delete_model_profile("RiskPaths", "profile1")
#' }
#'
#' @export
touch_model_profile <- function(model, data) {
  api_path <- glue::glue('api/model/{model}/profile')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_body_json(data, auto_unbox = TRUE) |>
    httr2::req_method('PATCH') |>
    httr2::req_perform()
  invisible()
}

#' @rdname touch_model_profile
#' @export
delete_model_profile <- function(model, profile) {
  api_path <- glue::glue('api/model/{model}/profile/{profile}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}

#' @rdname touch_model_profile
#' @export
set_model_profile_opt <- function(model, profile, key, value) {
  api_path <- glue::glue(
    'api/model/{model}/profile/{profile}/key/{key}/value/{value}'
  )
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('POST') |>
    httr2::req_perform()
  invisible()
}

#' @rdname touch_model_profile
#' @export
delete_model_profile_opt <- function(model, profile, key) {
  api_path <- glue::glue('api/model/{model}/profile/{profile}/key/{key}')
  OpenMpp$API$build_request() |>
    httr2::req_url_path(api_path) |>
    httr2::req_method('DELETE') |>
    httr2::req_perform()
  invisible()
}
