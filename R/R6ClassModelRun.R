#' OncoSimX Model Run Class
#'
#' @inheritParams get_model_list
#' @inheritParams get_param_values
#'
#' @export
load_model_run <- function(model, run) {
  OncoSimXModelRun$new(model, run)
}

#' @rdname load_model_run
#' @export
OncoSimXModelRun <-
  R6::R6Class(
    classname = 'OncoSimXModelRun',
    inherit = OncoSimXModel,
    public = list(
      initialize = function(model, run) {
        super$initialize(model)
        private$.run = get_model_run(model, run)
      }
    ),
    private = list(
      .run = NULL
    ),
    active = list()
  )
