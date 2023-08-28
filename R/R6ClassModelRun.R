#' OncoSimX ModelRun Class
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
#'
#' @details `load_run()` is an alias for `load_model_run()`.
#'
#' @return An `OncoSimXModelRun` instance.
#'
#' @export
load_model_run <- function(model, run) {
  OncoSimXModelRun$new(model, run)
}

#' @rdname load_model_run
#' @export
load_run <- load_model_run

#' @rdname load_model_run
#' @export
OncoSimXModelRun <-
  R6::R6Class(
    classname = 'OncoSimXModelRun',
    inherit = OncoSimXModel,
    cloneable = FALSE,
    portable = FALSE,
    lock_objects = FALSE,
    public = list(

      #' @field RunName Run name.
      RunName = NULL,

      #' @field RunDigest Run digest.
      RunDigest = NULL,

      #' @field RunStamp Run stamp.
      RunStamp = NULL,

      #' @field RunMetadata Run metadata.
      RunMetadata = NULL,

      #' @field Type Object type (used for `print()`).
      Type = 'ModelRun',

      #' @description
      #' Create a new OncoSimXModelRun object.
      #' @param model Model digest or name.
      #' @param run Run digest, run stamp, or run name.
      #' @return A new `OncoSimXModelRun` object.
      initialize = function(model, run) {
        super$initialize(model)
        private$.run <- get_model_run(model, run)
        self$RunName <- private$.run$Name
        self$RunDigest <- private$.run$RunDigest
        self$RunStamp <- self$RunStatusInfo$RunStamp
        self$RunMetadata <- purrr::discard_at(private$.run, c('Param', 'Table'))
        private$.load_table_bindings()
      },

      #' @description
      #' Retrieve a table.
      #' @param name Table name.
      #' @return A `tibble`.
      get_table = function(name) {
        get_run_table_csv(self$ModelDigest, self$RunDigest, name)
      },

      #' @description
      #' Print a `OncoSimXModelRun` object.
      #' @param ... Not currently used.
      #' @return  Self, invisibly.
      print = function(...) {
        super$print()
        cli::cli_alert(paste0('RunName: ', self$RunName))
        cli::cli_alert(paste0('RunDigest: ', self$RunDigest))
        invisible(self)
      },

      #' @description
      #' Write an output table to disk (CSV).
      #' @param name Table name.
      #' @param file File path.
      #' @return  Self, invisibly.
      extract_table = function(name, file) {
        readr::write_csv(self$get_table(name), file)
        invisible(self)
      }
    ),
    private = list(
      .run = NULL,
      .load_table_bindings = function() {
        purrr::walk(private$.run$Table, \(table) {
          f <- function() {
            table_name <- table$Name
            self$get_table(table_name)
          }
          rlang::env_bind_active(self, '{table$Name}' := f)
        })
      }
    ),
    active = list(
      #' @field RunStatusInfo Run status information.
      RunStatusInfo = function() {
        get_model_run_status(self$ModelDigest, self$RunDigest)
      },
      #' @field RunStatus Run status.
      RunStatus = function() {
        get_model_run_status(self$ModelDigest, self$RunDigest)$Status
      }
    )
  )
