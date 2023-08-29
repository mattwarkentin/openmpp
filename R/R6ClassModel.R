#' OncoSimX Model Class
#'
#' @inheritParams get_model
#'
#' @importFrom R6 R6Class
#' @import cli purrr fs zip
#'
#' @return An `OncoSimXModel` instance.
#'
#' @export
load_model <- function(model) {
  OncoSimXModel$new(model)
}

#' @rdname load_model
#' @export
OncoSimXModel <-
  R6::R6Class(
    classname = 'OncoSimXModel',
    cloneable = FALSE,
    portable = FALSE,
    public = list(
      #' @field Type Object type (used for `print()` method).
      Type = 'Model',

      #' @field ModelDigest Model digest.
      ModelDigest = NULL,

      #' @field ModelName Model name.
      ModelName = NULL,

      #' @field ModelVersion Model version.
      ModelVersion = NULL,

      #' @field ModelMetadata Model metadata.
      ModelMetadata = NULL,

      #' @field ParamInfo Input parameter information.
      ParamInfo = NULL,

      #' @field TableInfo Output table information.
      TableInfo = NULL,

      #' @description
      #' Create a new OncoSimXModel object.
      #' @param model Model digest or name.
      #' @return A new `OncoSimXModel` object.
      initialize = function(model) {
        private$.set_model(model)
        private$.set_model_metadata()
        private$.set_param_info()
        private$.set_table_info()
      },

      #' @description
      #' Print a OncoSimXModel object.
      #' @param ... Not currently used.
      #' @return  Self, invisibly.
      print = function(...) {
        cli::cat_rule(glue::glue('OncoSimX {self$Type}'))
        cli::cli_alert(paste0('ModelName: ', self$ModelName))
        cli::cli_alert(paste0('ModelDigest: ', self$ModelDigest))
        invisible(self)
      }
    ),
    private = list(
      .model = NULL,
      .set_model = function(model) {
        private$.model <- get_model(model)
      },
      .set_param_info = function() {
        self$ParamInfo <-
          purrr::map(private$.model$ParamTxt, \(x) {
            purrr::discard_at(x, 'ParamDimsTxt') |>
              purrr::list_flatten(name_spec = '{inner}')
          }) |>
          tibblify::tibblify() |>
          suppressMessages()
      },
      .set_table_info = function() {
        self$TableInfo <-
          purrr::map(private$.model$TableTxt, \(x) {
            purrr::discard_at(x,  c('TableDimsTxt', 'TableAccTxt', 'TableExprTxt')) |>
              purrr::list_flatten(name_spec = '{inner}')
          }) |>
          tibblify::tibblify() |>
          suppressMessages()
      },
      .set_model_metadata = function() {
        self$ModelMetadata <- private$.model$Model
        self$ModelDigest <- private$.model$Model$Digest
        self$ModelName <- private$.model$Model$Name
        self$ModelVersion <- private$.model$Model$Version
      }
    ),
    active = list(
      #' @field workset_list List of worksets.
      workset_list = function() get_worksets(self$ModelDigest),

      #' @field scenario_list List of scenarios.
      scenario_list = function() get_worksets(self$ModelDigest),

      #' @field run_list List of model runs.
      run_list = function() get_model_runs(self$ModelDigest),

      #' @field task_list List of model tasks.
      task_list = function() get_model_tasks(self$ModelDigest)
    )
  )
