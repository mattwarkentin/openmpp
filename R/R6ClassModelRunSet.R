#' OncoSimX ModelRunSet  Class
#'
#' @param model Model name or digest.
#' @param runs Character vector of model run names, digests, or stamps.
#'
#' @details `load_runs()` is an alias for `load_model_runs()`.
#'
#' @return An `OncoSimXModelRunSet` instance.
#'
#' @export
load_model_runs <- function(model, runs) {
  OncoSimXModelRunSet$new(model, runs)
}

#' @rdname load_model_runs
#' @export
load_runs <- load_model_runs

#' @rdname load_model_runs
#' @export
OncoSimXModelRunSet <-
  R6::R6Class(
    classname = 'OncoSimXModelRunSet',
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

      #' @description
      #' Create a new OncoSimXModelRunSet object.
      #' @param model Model digest or name.
      #' @param runs Run digests, run stamps, or run names.
      #' @return A new `OncoSimXModelSet` object.
      initialize = function(model, runs) {
        private$.runs <- vector('list', length(runs))
        private$.runs <- purrr::map(runs, \(r) OncoSimXModelRun$new(model, r))
        private$.runs <- rlang::set_names(private$.runs, self$RunNames)
        first_run <- private$.runs[[1]]
        self$ModelName <- first_run$ModelName
        self$ModelDigest <- first_run$ModelDigest
        self$ModelVersion <- first_run$ModelVersion
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

        cli::cat_rule(glue::glue('OncoSimX {self$Type}'))
        cli::cli_alert(paste0('ModelName: ', self$ModelName))
        cli::cli_alert(paste0('ModelDigest: ', self$ModelDigest))
        cli::cli_alert(paste0('RunNames: ', RunNames))
        cli::cli_alert(paste0('RunDigests: ', RunDigests))
        invisible(self)
      },

      #' @description
      #' Retrieve a table.
      #' @param name Table name.
      #' @param stack Should tables be stacked by model runs? Default is `TRUE`.
      #' @return A `tibble`.
      get_table = function(name, stack = TRUE) {
        tbls <- purrr::map(private$.runs, \(run) run$get_table(name))
        if (stack) tbls <- purrr::list_rbind(tbls, names_to = 'RunName')
        tbls
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
      .runs = NULL,
      .load_table_bindings = function() {
        purrr::walk(private$.runs[[1]]$private$.run$Table, \(table) {
          f <- function() {
            table_name <- table$Name
            self$get_table(table_name)
          }
          rlang::env_bind_active(self, '{table$Name}' := f)
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
