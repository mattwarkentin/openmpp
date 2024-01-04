#' OpenM++ ModelRunSet Class
#'
#' @param model Model name or digest.
#' @param runs Character vector of model run names, digests, or stamps.
#'
#' @details `load_runs()` is an alias for `load_model_runs()`.
#'
#' @return An `OpenMppModelRunSet` instance.
#'
#' @include Utils.R
#'
#' @export
load_model_runs <- function(model, runs) {
  OpenMppModelRunSet$new(model, runs)
}

#' @rdname load_model_runs
#' @export
load_runs <- load_model_runs

#' @rdname load_model_runs
#' @export
OpenMppModelRunSet <-
  R6::R6Class(
    classname = 'OpenMppModelRunSet',
    cloneable = FALSE,
    portable = FALSE,
    lock_objects = FALSE,
    public = list(

      #' @field ModelDigest Model digest.
      ModelDigest = NULL,

      #' @field ModelName Model name.
      ModelName = NULL,

      #' @field ModelVersion Model version.
      ModelVersion = NULL,

      #' @field Type Object type (used for `print()`).
      Type = 'ModelRunSet',

      #' @field Tables Run tables
      Tables = rlang::env(),

      #' @description
      #' Create a new OncoSimXModelRunSet object.
      #' @param model Model digest or name.
      #' @param runs Run digests, run stamps, or run names.
      #' @return A new `OncoSimXModelSet` object.
      initialize = function(model, runs) {
        private$.set_runs(model, runs)
        private$.set_runs_metadata()
        private$.load_table_bindings()
      },

      #' @description
      #' Print a `OncoSimXModelRunSet` object.
      #' @param ... Not currently used.
      #' @return  Self, invisibly.
      print = function(...) {
        names <- glue::glue_collapse(self$RunNames, sep = ', ')
        RunNames = glue::glue('[{names}]')

        digests <- glue::glue_collapse(self$RunDigests, sep = ', ')
        RunDigests = glue::glue('[{digests}]')

        cli::cat_rule(glue::glue('OpenM++ {self$Type}'))
        cli::cli_alert(paste0('ModelName: ', self$ModelName))
        cli::cli_alert(paste0('ModelVersion: ', self$ModelVersion))
        cli::cli_alert(paste0('ModelDigest: ', self$ModelDigest))
        cli::cli_alert(paste0('RunNames: ', RunNames))
        cli::cli_alert(paste0('RunDigests: ', RunDigests))
        invisible(self)
      },

      #' @description
      #' Retrieve a table.
      #' @param name Table name.
      #' @return A `tibble`.
      get_table = function(name) {
        purrr::map(private$.runs, \(run) run$get_table(name)) |>
          purrr::list_rbind(names_to = 'RunName')
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
        if (fs::dir_exists(dir)) {
          purrr::walk(
            .x = private$.tables,
            .f = \(t) {
              file <- glue::glue('{dir}/{t}.csv')
              self$write_table(t, file)
            }
          )
        }
        invisible(self)
      }
    ),
    private = list(
      .runs = NULL,
      .tables = NULL,
      .set_runs = function(model, runs) {
        private$.runs <- vector('list', length(runs))
        private$.runs <- purrr::map(runs, \(r) OpenMppModelRun$new(model, r))
        private$.runs <- rlang::set_names(private$.runs, self$RunNames)
      },
      .set_runs_metadata = function() {
        first_run <- private$.runs[[1]]
        self$ModelName <- first_run$ModelName
        self$ModelDigest <- first_run$ModelDigest
        self$ModelVersion <- first_run$ModelVersion
      },
      .add_table = function(name) {
        curr <- private$.tables
        total <- sort(unique(c(curr, name)))
        private$.tables <- total
      },
      .load_table_bindings = function() {
        purrr::walk(private$.runs[[1]]$private$.run$Table, \(table) {
          private$.add_table(table$Name)
          f <- function() {
            table_name <- table$Name
            self$get_table(table_name)
          }
          rlang::env_bind_active(self$Tables, '{table$Name}' := f)
        })
      }
    ),
    active = list(
      #' @field RunNames Run names.
      RunNames = function() {
        purrr::map_chr(private$.runs, \(x) x$RunName)
      },

      #' @field RunDigests Run digests.
      RunDigests = function() {
        purrr::map_chr(private$.runs, \(x) x$RunDigest)
      },

      #' @field RunStamps Run stamps.
      RunStamps = function() {
        purrr::map_chr(private$.runs, \(x) x$RunStamp)
      },

      #' @field RunStatuses Run statuses.
      RunStatuses = function() {
        purrr::map_chr(private$.runs, \(x) x$RunStatus)
      },

      #' @field RunMetadatas Run metadatas.
      RunMetadatas = function() {
        purrr::map(private$.runs, \(x) x$RunMetadata)
      }
    )
  )
