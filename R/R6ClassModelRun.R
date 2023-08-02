#' OncoSimX Model Run Class
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
#'
#' @return An `OncoSimXModelRun` instance.
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

      #' @field RunName Run name.
      RunName = NULL,

      #' @field RunDigest Run digest.
      RunDigest = NULL,

      #' @field RunStatus Run status.
      RunStatus = NULL,

      #' @field RunMetadata Run metadata.
      RunMetadata = NULL,

      #' @field Type Object type (used for `print()`).
      Type = 'ModelRun',

      #' @description
      #' Create a new OncoSimXModelRun object.
      #' @param model Model digest or name.
      #' @param run Run digest, run stamp, or run name.
      #' @return A new `OncoSimXModel` object.
      initialize = function(model, run) {
        super$initialize(model)
        private$.run = get_model_run(model, run)
        self$RunName = private$.run$Name
        self$RunDigest = private$.run$RunDigest
        self$RunStatus = private$.run$Status
        self$RunMetadata = purrr::discard_at(private$.run, c('Param', 'Table'))
      },

      #' @description
      #' Load all tables.
      #' @return Self, invisibly.
      populate_tables = function() {
        tbl_names <- names(self$Tables)
        self$Tables = purrr::map(tbl_names, \(x) {
          get_run_table_csv(self$ModelDigest, self$RunDigest, x)
        }, .progress = TRUE)
        self$Tables <- rlang::set_names(self$Tables, tbl_names)
        invisible(self)
      },

      #' @description
      #' Retrieve a table.
      #' @param name Table name.
      #' @return A `tibble`.
      get_table = function(name) {
        if (rlang::is_null(self$Tables[[name]])) {
          self$Tables[[name]] <-
            get_run_table_csv(self$ModelDigest, self$RunDigest, name)
        }
        self$Tables[[name]]
      },

      #' @description
      #' Load all parameters.
      #' @return Self, invisibly.
      populate_params = function() {
        par_names <- names(self$Params)
        self$Params = purrr::map(par_names, \(x) {
          get_run_param_csv(self$ModelDigest, self$RunDigest, x)
        }, .progress = TRUE)
        self$Params <- rlang::set_names(self$Params, par_names)
        invisible(self)
      },

      #' @description
      #' Retrieve a parameter.
      #' @param name Parameter name.
      #' @return A `tibble`.
      get_param = function(name) {
        if (rlang::is_null(self$Params[[name]])) {
          self$Params[[name]] <-
            get_run_param_csv(self$ModelDigest, self$RunDigest, name)
        }
        self$Params[[name]]
      },

      #' @description
      #' Print a OncoSimXModelRun object.
      #' @param ... Not currently used.
      #' @return  Self, invisibly.
      print = function(...) {
        super$print()
        cli::cli_alert(paste0('RunName: ', self$RunName))
        cli::cli_alert(paste0('RunDigest: ', self$RunDigest))
      }
    ),
    private = list(
      .run = NULL
    ),
    active = list()
  )
