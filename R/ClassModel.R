#' OpenM++ Model Class
#'
#' @inheritParams get_model
#'
#' @importFrom R6 R6Class
#' @import cli purrr
#'
#' @return An `OpenMppModel` instance.
#'
#' @include Utils.R
#'
#' @examples
#' \dontrun{
#' use_OpenMpp_local()
#' load_model("RiskPaths")
#' }
#'
#' @export
load_model <- function(model) {
  models <- get_models()
  valid_ids <- c(models$Name, models$Digest)
  if (!(model %in% valid_ids)) {
    rlang::abort(glue::glue('Model "{model}" does not exist.'))
  }
  OpenMppModel$new(model)
}

#' @rdname load_model
#' @export
OpenMppModel <-
  R6::R6Class(
    classname = 'OpenMppModel',
    cloneable = FALSE,
    portable = FALSE,
    public = list(
      #' @field OpenMppType OpenM++ object type (used for `print()` method).
      OpenMppType = 'Model',

      #' @field ModelDigest Model digest.
      ModelDigest = NULL,

      #' @field ModelName Model name.
      ModelName = NULL,

      #' @field ModelVersion Model version.
      ModelVersion = NULL,

      #' @field ModelMetadata Model metadata.
      ModelMetadata = NULL,

      #' @field ParamsInfo Input parameter information.
      ParamsInfo = NULL,

      #' @field TablesInfo Output table information.
      TablesInfo = NULL,

      #' @description
      #' Create a new OpenMppModel object.
      #' @param model Model digest or name.
      #' @return A new `OpenMppModel` object.
      initialize = function(model) {
        private$.set_model(model)
        private$.set_model_metadata()
        private$.set_param_info()
        private$.set_table_info()
      },

      #' @description
      #' Print a OpenMppModel object.
      #' @param ... Not currently used.
      #' @return  Self, invisibly.
      print = function(...) {
        cli::cat_rule(glue::glue('OpenM++ {self$OpenMppType}'))
        cli::cli_alert(paste0('ModelName: ', self$ModelName))
        cli::cli_alert(paste0('ModelVersion: ', self$ModelVersion))
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
        self$ParamsInfo <-
          purrr::map(private$.model$ParamTxt, \(x) {
            purrr::discard_at(x, 'ParamDimsTxt') |>
              purrr::list_flatten(name_spec = '{inner}')
          }) |>
          purrr::map(tibble::as_tibble) |>
          purrr::list_rbind()
      },
      .set_table_info = function() {
        self$TablesInfo <-
          purrr::map(private$.model$TableTxt, \(x) {
            purrr::discard_at(
              x,
              c('TableDimsTxt', 'TableAccTxt', 'TableExprTxt')
            ) |>
              purrr::list_flatten(name_spec = '{inner}')
          }) |>
          purrr::map(tibble::as_tibble) |>
          purrr::list_rbind()
      },
      .set_model_metadata = function() {
        self$ModelMetadata <- private$.model$Model
        self$ModelDigest <- private$.model$Model$Digest
        self$ModelName <- private$.model$Model$Name
        self$ModelVersion <- private$.model$Model$Version
      }
    ),
    active = list(
      #' @field ModelWorksets Data frame of worksets.
      ModelWorksets = function() get_worksets(self$ModelDigest),

      #' @field ModelScenarios Data frame of scenarios.
      ModelScenarios = function() get_worksets(self$ModelDigest),

      #' @field ModelRuns Data frame of model runs.
      ModelRuns = function() get_model_runs(self$ModelDigest),

      #' @field ModelTasks Data frame of model tasks.
      ModelTasks = function() get_model_tasks(self$ModelDigest)
    )
  )
