#' OpenM++ ModelRun Class
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
#'
#' @details `load_run()` is an alias for `load_model_run()`.
#'
#' @return An `OpenMppModelRun` instance.
#'
#' @include Utils.R
#'
#' @export
load_model_run <- function(model, run) {
  runs <- get_runs(model)
  valid_runs <- c(runs$Name, runs$RunDigest)
  if (!(run %in% valid_runs)) {
    rlang::abort(glue::glue('Model run "{run}" does not exist for model "{model}".'))
  }
  OpenMppModelRun$new(model, run)
}

#' @rdname load_model_run
#' @export
load_run <- load_model_run

#' @rdname load_model_run
#' @export
OpenMppModelRun <-
  R6::R6Class(
    classname = 'OpenMppModelRun',
    inherit = OpenMppModel,
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

      #' @field Parameters Model run parameters.
      Parameters = NULL,

      #' @field Tables Model run output tables
      Tables = NULL,

      #' @field OpenMppType OpenM++ object type (used for `print()`).
      OpenMppType = 'ModelRun',

      #' @description
      #' Create a new OpenMppModelRun object.
      #' @param model Model digest or name.
      #' @param run Run digest, run stamp, or run name.
      #' @return A new `OpenMppModelRun` object.
      initialize = function(model, run) {
        super$initialize(model)
        private$.set_run(model, run)
        private$.set_run_metadata()
        private$.load_table_bindings()
        private$.load_run_param_bindings()
      },

      #' @description
      #' Print a `OpenMppModelRun` object.
      #' @param ... Not currently used.
      #' @return  Self, invisibly.
      print = function(...) {
        super$print()
        cli::cli_alert(paste0('RunName: ', self$RunName))
        cli::cli_alert(paste0('RunDigest: ', self$RunDigest))
        invisible(self)
      },

      #' @description
      #' Retrieve a table.
      #' @param name Table name.
      #' @return A `tibble`.
      get_table = function(name) {
        if (name %in% private$.tables) {
          tbl <- get_run_table_csv(self$ModelDigest, self$RunDigest, name)
          suppressWarnings(tbl$expr_value <- as.numeric(tbl$expr_value))
          return(tbl)
        }
        abort_msg <- glue::glue('Table `{name}` is not available for model run.')
        rlang::abort(abort_msg)
      },

      #' @description
      #' Retrieve a table calculation.
      #' @param name Table name.
      #' @param calc Name of calculation. One of `"avg"`, `"sum"`, `"count"`,
      #'   `"max"`, `"min"`, `"var"`, `"sd"`, `"se"`, or `"cv"`.
      #' @return A `tibble`.
      get_table_calc = function(name, calc) {
        if (name %in% private$.tables) {
          tbl <- get_run_table_calc_csv(self$ModelDigest, self$RunDigest, name, calc)
          suppressWarnings(tbl$calc_value <- as.numeric(tbl$calc_value))
          return(tbl)
        }
        abort_msg <- glue::glue('Table `{name}` is not available for model run.')
        rlang::abort(abort_msg)
      },

      #' @description
      #' Retrieve a table comparison.
      #' @param name Table name.
      #' @param compare Comparison to calculate. One of `"diff"`, `"ratio"`, or
      #'   `"percent"`.
      #' @param variant Run digest, name, or stamp for the variant model run.
      #' @return A `tibble`.
      get_table_comparison = function(name, compare, variant) {
        if (name %in% private$.tables) {
          tbl <- get_run_table_comparison_csv(self$ModelDigest, self$RunDigest, name, compare, variant)
          suppressWarnings(tbl$calc_value <- as.numeric(tbl$calc_value))
          return(tbl)
        }
        abort_msg <- glue::glue('Table `{name}` is not available for model run.')
        rlang::abort(abort_msg)
      },

      #' @description
      #' Write an output table to disk (CSV).
      #' @param name Table name.
      #' @param file File path.
      #' @return  Self, invisibly.
      write_table = function(name, file) {
        readr::write_csv(self$get_table(name), file)
        invisible(self)
      },

      #' @description
      #' Write all output tables to disk (CSV).
      #' @param dir Directory path.
      #' @return  Self, invisibly.
      write_tables = function(dir) {
        if (dir.exists(dir)) {
          purrr::walk(
            .x = private$.tables,
            .f = \(t) {
              file <- glue::glue('{dir}/{t}.csv')
              self$write_table(t, file)
            }
          )
        }
        invisible(self)
      },

      #' @description
      #' Get console log for model run.
      #' @return  Self, invisibly.
      get_log = function() {
        get_model_run_state(self$ModelDigest, self$RunStamp)$Lines |>
          glue::glue_collapse(sep = '\n')
      },

      #' @description
      #' Write console log for model run to disk.
      #' @param dir Directory to save log file.
      #' @return  Self, invisibly.
      write_log = function(dir) {
        if (dir.exists(dir)) {
          file_name <- get_model_run_state(self$ModelDigest, self$RunStamp)$LogFileName
          file_path <- glue::glue('{dir}/{file_name}')
          writeLines(self$get_log(), file_path)
        }
        invisible(self)
      }
    ),
    private = list(
      .run = NULL,
      .tables = NULL,
      .set_run = function(model, run) {
        private$.run <- get_model_run(model, run)
      },
      .set_run_metadata = function() {
        self$RunName <- private$.run$Name
        self$RunDigest <- private$.run$RunDigest
        self$RunStamp <- self$RunStatusInfo$RunStamp
        self$RunMetadata <- purrr::discard_at(private$.run, c('Param', 'Table'))
      },
      .add_table = function(name) {
        curr <- private$.tables
        total <- sort(unique(c(curr, name)))
        private$.tables <- total
      },
      .load_table_bindings = function() {
        self$Tables <- rlang::env()
        purrr::walk(private$.run$Table, \(table) {
          private$.add_table(table$Name)
          f <- function() {
            table_name <- table$Name
            self$get_table(table_name)
          }
          rlang::env_bind_active(self$Tables, '{table$Name}' := f)
        })
      },
      .load_run_param_bindings = function() {
        self$Parameters <- rlang::env()
        purrr::walk(private$.run$Param, \(param) {
          f <- function() {
            param_name <- param$Name
            get_run_param_csv(self$ModelDigest, self$RunDigest, param_name) |>
              private$.pivot_wide()
          }
          rlang::env_bind_active(self$Parameters, '{param$Name}' := f)
        })
      },
      .pivot_wide = pivot_wide_impl,
      .pivot_long = pivot_long_impl
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
