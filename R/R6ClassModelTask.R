#' OncoSimX Model Task Class
#'
#' @param task Modeling task name.
#' @inheritParams get_model
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
    cloneable = FALSE,
    portable = FALSE,
    public = list(
      #' @description
      #' Create a new `OncoSimXModelTask` object.
      #' @param model Model digest or name.
      #' @param task Task name.
      #' @return A new `OncoSimXModelTask` object.
      initialize = function(model, task) {
        private$.task = get_model_task(model, task)
      }
    ),
    private = list(
      .task = NULL
    ),
    active = list()
  )
