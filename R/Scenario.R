#' Manage Model Scenarios
#'
#' @param model Model name or digest.
#' @param name New scenario name.
#' @param base Base run digest (optional).
#'
#' @return Nothing, invisibly.
#'
#' @examples
#' \dontrun{
#' use_OpenMpp_local()
#' create_scenario("RiskPaths", "NewScenario")
#' }
#'
#'
#' @export
create_scenario <- function(model, name, base = NULL) {
  existing_scenarios <- get_worksets(model)$Name
  if (name %in% existing_scenarios) {
    rlang::abort('Scenario name already in use, choose a different name.')
  }

  is_model_name <- model %in% get_models()$Name

  body <- list(
    ModelName = if (is_model_name) model else get_digest_model(model),
    ModelDigest = if (!is_model_name) model else get_model_digests(model)[[1]],
    Name = name
  )
  if (!rlang::is_null(base)) {
    body$BaseRunDigest <- base
  }
  new_workset(body)
  invisible()
}

#' @rdname create_scenario
#' @export
create_workset <- create_scenario

get_model_digests <- function(name) {
  models <- get_models()
  models[models$Name == name, , drop = FALSE]$Digest
}

get_digest_model <- function(digest) {
  models <- get_models()
  models[models$Digest == digest, , drop = FALSE]$Name
}
