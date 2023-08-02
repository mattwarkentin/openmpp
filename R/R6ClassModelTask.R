#' OncoSimX Model Task Class
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
#' @param task Modeling task name.
#'
#' @return An `OncoSimXModelTask` instance.
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
    public = list(
      #' @description
      #' Create a new OncoSimXModelTask object.
      #' @param model Model digest or name.
      #' @param task Taks name.
      #' @return A new `OncoSimXModel` object.
      initialize = function(model, task) {
        private$.task = get_model_task(model, task)
      }
    ),
    private = list(
      .task = NULL
    ),
    active = list()
  )
