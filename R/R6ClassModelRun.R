#' OncoSimX Model Run Class
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

      #' @field Params List of parameters.
      Params = NULL,

      #' @field Tables List of output tables.
      Tables = NULL,

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
        self$Params <- vector('list', length(private$.run$Param))
        self$Params <- rlang::set_names(self$Params, purrr::map_chr(private$.run$Param, \(x) x$Name))
        self$Tables <- vector('list', length(private$.run$Table))
        self$Tables <- rlang::set_names(self$Tables, purrr::map_chr(private$.run$Table, \(x) x$Name))
      },

      #' @description
      #' Load a tables.
      #' @param name Table name.
      #' @return Self, invisibly.
      load_table = function(name) {
        self$Tables[[name]] = get_run_table_csv(self$ModelDigest, self$RunDigest, name)
        invisible(self)
      },

      #' @description
      #' Load all tables.
      #' @return Self, invisibly.
      load_tables = function() {
        if (!private$.tables_loaded) {
          tbl_names <- names(self$Tables)
          purrr::walk(tbl_names, load_table, .progress = 'Loading Tables')
          private$.tables_loaded <- TRUE
        }
        invisible(self)
      },

      #' @description
      #' Retrieve a table.
      #' @param name Table name.
      #' @return A `tibble`.
      get_table = function(name) {
        if (rlang::is_null(self$Tables[[name]])) self$load_table(name)
        self$Tables[[name]]
      },

      #' @description
      #' Load a parameter.
      #' @param name Parameter name.
      #' @return Self, invisibly.
      load_param = function(name) {
        self$Params[[name]] = get_run_param_csv(self$ModelDigest, self$RunDigest, name)
        invisible(self)
      },

      #' @description
      #' Load all parameters.
      #' @return Self, invisibly.
      load_params = function() {
        if (!private$.params_loaded) {
          par_names <- names(self$Params)
          purrr::walk(par_names, load_param, .progress = 'Loading Parameters')
          private$.params_loaded <- TRUE
        }
        invisible(self)
      },

      #' @description
      #' Retrieve a parameter.
      #' @param name Parameter name.
      #' @return A `tibble`.
      get_param = function(name) {
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
      },

      #' @description
      #' Write a parameter to disk (CSV).
      #' @param name Parameter name.
      #' @param file Not currently used.
      #' @return  `name`, invisibly.
      extract_param = function(name, file) {
        readr::write_csv(self$get_param(name), file)
      },

      #' @description
      #' Write an output table to disk (CSV).
      #' @param name Table name.
      #' @param file Not currently used.
      #' @return  `name`, invisibly.
      extract_table = function(name, file) {
        readr::write_csv(self$get_table(name), file)
      }
    ),
    private = list(
      .run = NULL,
      .params_loaded = FALSE,
      .tables_loaded = FALSE
    ),
    active = list()
  )
