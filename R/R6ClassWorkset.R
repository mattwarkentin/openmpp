#' OncoSimX Workset Class
#'
#' @inheritParams get_model
#' @inheritParams get_param_values
#' @param ... Not currently used.
#'
#' @export
load_workset <- function(model, set, ...) {
  OncoSimXWorkset$new(model, set)
}

#' @rdname load_workset
#' @export
OncoSimXWorkset <-
  R6::R6Class(
    classname = 'OncoSimXWorkset',
    inherit = OncoSimXModel,
    public = list(
      initialize = function(model, set) {
        super$initialize(model)
        private$.workset = get_workset(model, set)
      }
    ),
    private = list(
      .workset = NULL
    ),
    active = list()
  )
