#' OncoSimX Model Task Class
#'
#' @inheritParams get_model_list
#' @inheritParams get_param_values
#' @param task Modeling task name.
#'
#' @export
load_model_task <- function(model, task) {
  OncoSimXModelTask$new(model, task)
}

#' @rdname load_workset
#' @export
OncoSimXModelTask <-
  R6::R6Class(
    classname = 'OncoSimXModelTask',
    inherit = OncoSimXModelRun,
    public = list(
      initialize = function(model, task) {
        super$initialize(model, set)
        get_model_task(model, task)
      }
    ),
    private = list(
      .task = NULL
    ),
    active = list()
  )
