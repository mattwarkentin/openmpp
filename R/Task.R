#' OncoSimX Model Task
#'
#' @param model Model name.
#' @param name Task name.
#' @param worksets Character vector of worksets.
#'
#' @export
create_project <- function(model, name, worksets = NULL) {
  create_task(
    model = model,
    data = list(
      Name = name,
      Set = worksets
    )
  )
  load_model_task(model, name)
}
