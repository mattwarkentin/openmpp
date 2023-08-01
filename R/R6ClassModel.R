#' OncoSimX Model Class
#'
#' @inheritParams get_model_list
#' @param ... Not currently used.
#'
#' @importFrom R6 R6Class
#' @import cli purrr
#'
#' @export
load_model <- function(model, ...) {
  OncoSimXModel$new(model)
}

#' @rdname load_model
#' @export
OncoSimXModel <-
  R6::R6Class(
    classname = 'OncoSimXModel',
    public = list(
      #' @field digest Model digest.
      ModelDigest = NULL,

      #' @field name Model name.
      ModelName = NULL,

      #' @field version Model version.
      ModelVersion = NULL,

      #' @field params Character vector of model parameters.
      params = NULL,

      #' @field tables Character vector of output tables.
      tables = NULL,

      #' @description
      #' Create a new OncoSimXModel object.
      #' @param model Model digest or name.
      #' @return A new `OncoSimXModel` object.
      initialize = function(model) {
        private$.model <- get_model(model)
        self$ModelDigest <- private$.model$Model$Digest
        self$ModelName <- private$.model$Model$Name
        self$ModelVersion <- private$.model$Model$Version
        self$params <- purrr::map_chr(private$.model$ParamTxt, \(x) {
          x$Param$Name
        })
        self$tables <- purrr::map_chr(private$.model$TableTxt, \(x) {
          x$Table$Name
        })
      },

      #' @description
      #' Print a OncoSimXModel object.
      #' @param ... Not currently used.
      #' @return  Nothing, invisibly.
      print = function(...) {
        cli::cat_rule('OncoSimX Model')
        cli::cat_bullet(paste0('Name: ', self$ModelName))
        cli::cat_bullet(paste0('Digest: ', self$ModelDigest))
        cli::cat_bullet(paste0('Version: ', self$ModelVersion))
        cli::cat_rule()
        invisible()
      }
    ),
    private = list(
      .model = NULL
    ),
    active = list(
      run_list = function() get_model_run_list(self$ModelDigest),
      run_status_first = function() get_model_run_status_first(self$ModelDigest),
      run_status_last = function() get_model_run_status_last(self$ModelDigest),
      run_status_compl = function() get_model_run_status_compl(self$ModelDigest),
      task_list = function() get_model_task_list(self$ModelDigest),
      workset_list = function() get_workset_list(self$ModelDigest)
    )
  )
