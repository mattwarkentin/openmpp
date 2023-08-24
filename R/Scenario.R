#' Manage Model Scenarios
#'
#' @param model Model name or digest.
#' @param name New scenario name.
#' @param base Base run digest.
#'
#' @export
create_scenario <- function(model, name, base = NULL) {
  body <- list(ModelName = model, Name = name)
  if (!rlang::is_null(base)) body[['BaseRunDigest']] <- base
  create_workset(body)
}

#' @rdname get_workset
#' @export
delete_scenario <- delete_workset
