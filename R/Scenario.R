#' Manage Model Scenarios
#'
#' @param model Model name or digest.
#' @param name New scenario name.
#' @param base Base run digest.
#'
#' @return Nothing, invisibly.
#'
#' @export
create_scenario <- function(model, name, base) {
  body <- list(ModelName = model, Name = name, BaseRunDigest = base)
  create_workset(body)
  invisible()
}

#' @rdname get_workset
#' @export
delete_scenario <- delete_workset
