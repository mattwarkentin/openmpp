#' OpenM++ Workset Class
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
#'
#' @import tidyr tidyselect
#'
#' @return An `OpenMppWorkset` instance.
#'
#' @details `load_scenario()` is an alias for `load_workset()`.
#'
#' @include Utils.R
#'
#' @examples
#' \dontrun{
#' use_OpenMpp_local()
#' load_workset("RiskPaths", "Default")
#' load_scenario("RiskPaths", "Default")
#' }
#'
#'
#' @export
load_workset <- function(model, set) {
  if (!(set %in% get_worksets(model)$Name)) {
    rlang::abort(glue::glue(
      'Workset "{set}" does not exist for model "{model}".'
    ))
  }
  OpenMppWorkset$new(model, set)
}

#' @rdname load_workset
#' @export
load_scenario <- load_workset

#' @rdname load_workset
#' @export
OpenMppWorkset <-
  R6::R6Class(
    classname = 'OpenMppWorkset',
    inherit = OpenMppModel,
    cloneable = FALSE,
    portable = FALSE,
    lock_objects = FALSE,
    public = list(
      #' @field WorksetName Workset name.
      WorksetName = NULL,

      #' @field WorksetMetadata Workset metadata.
      WorksetMetadata = NULL,

      #' @field OpenMppType OpenM++ object type (used for `print()`).
      OpenMppType = 'Workset',

      #' @field Parameters Workset parameters.
      Parameters = NULL,

      #' @description
      #' Create a new OpenMppWorkset object.
      #' @param model Model digest or name.
      #' @param set Workset name.
      #' @return A new `OpenMppWorkset` object.
      initialize = function(model, set) {
        super$initialize(model)
        private$.set_workset(model, set)
        private$.set_workset_metadata()
        private$.load_param_bindings()
      },

      #' @description
      #' Print a `OpenMppWorkset` object.
      #' @param ... Not currently used.
      #' @return Self, invisibly.
      print = function(...) {
        type <- if (self$ReadOnly) {
          glue::glue('{self$OpenMppType} (ReadOnly)')
        } else {
          self$OpenMppType
        }
        cli::cat_rule(glue::glue('OpenM++ {type}'))
        cli::cli_alert(paste0('ModelName: ', self$ModelName))
        cli::cli_alert(paste0('ModelVersion: ', self$ModelVersion))
        cli::cli_alert(paste0('ModelDigest: ', self$ModelDigest))
        cli::cli_alert(paste0('WorksetName: ', self$WorksetName))
        cli::cli_alert(paste0('BaseRunDigest: ', self$BaseRunDigest))
        invisible(self)
      },

      #' @description
      #' Set the base run digest.
      #' @param base Base run digest.
      #' @return Self, invisibly.
      set_base_digest = function(base) {
        private$.check_modifiable()
        if (rlang::is_scalar_character(base)) {
          json <- list(
            ModelName = self$ModelName,
            ModelDigest = self$ModelDigest,
            Name = self$WorksetName,
            BaseRunDigest = base
          )
          merge_workset(json)
          private$.set_workset(self$ModelDigest, self$WorksetName)
          private$.set_workset_metadata()
        }
        invisible(self)
      },

      #' @description
      #' Delete the base run digest.
      #' @return Self, invisibly.
      delete_base_digest = function() {
        private$.check_modifiable()
        json <- list(
          ModelName = self$ModelName,
          ModelDigest = self$ModelDigest,
          Name = self$WorksetName,
          BaseRunDigest = "",
          IsCleanBaseRun = TRUE
        )
        merge_workset(json)
        private$.set_workset(self$ModelDigest, self$WorksetName)
        private$.set_workset_metadata()
        invisible(self)
      },

      #' @description
      #' Copy parameters from a base scenario.
      #' @param names Character vector of parameter names.
      #' @return Self, invisibly.
      copy_params = function(names) {
        private$.check_modifiable()
        if (
          rlang::is_null(self$BaseRunDigest) |
            nchar(self$BaseRunDigest) == 0
        ) {
          rlang::abort(
            'Cannot copy parameters without a base scenario. Consider setting a base scenario with `$set_base_digest()`.'
          )
        }

        if (any(names %in% private$.params)) {
          rlang::abort('Parameter(s) already exist in workset.')
        }

        purrr::walk(
          .x = names,
          .f = \(name) {
            copy_param_run_to_workset(
              model = self$ModelDigest,
              set = self$WorksetName,
              name = name,
              run = self$BaseRunDigest
            )
          }
        )

        private$.set_workset(self$ModelDigest, self$WorksetName)
        private$.load_param_bindings()
        invisible(self)
      },

      #' @description
      #' Delete parameters from scenario.
      #' @param names Character vector of parameter names.
      #' @return Self, invisibly.
      delete_params = function(names) {
        private$.check_any_params()
        private$.check_modifiable()
        purrr::map(names, \(x) {
          private$.check_param_exists(x, rlang::caller_env(3))
        })
        purrr::walk(
          .x = names,
          .f = \(name) {
            if (name %in% private$.params) {
              delete_workset_param(self$ModelDigest, self$WorksetName, name)
              rm(list = name, envir = self)
            }
          }
        )
        private$.set_workset(self$ModelDigest, self$WorksetName)
        private$.load_param_bindings()
        invisible(self)
      },

      #' @description
      #' Retrieve a parameter.
      #' @param name Parameter name.
      #' @return A `tibble`.
      get_param = function(name) {
        private$.check_any_params()
        private$.check_param_exists(name)
        private$.pivot_wide(get_workset_param_csv(
          self$ModelDigest,
          self$WorksetName,
          name
        ))
      },

      #' @description
      #' Set a parameter.
      #' @param name Parameter name.
      #' @param data New parameter data.
      #' @return Self, invisibly.
      set_param = function(name, data) {
        private$.check_any_params()
        private$.check_modifiable()
        private$.check_param_exists(name)

        old <- self$get_param(name)

        is_compatible(data, old)

        attributes(data) <- attributes(self$get_param(name))
        data <- private$.pivot_long(data)

        tmp_csv <- glue::glue('{tempdir()}/{name}.csv')

        readr::write_csv(data, tmp_csv, progress = FALSE)

        ws <- list(
          ModelName = self$ModelName,
          ModelDigest = self$ModelDigest,
          Name = self$WorksetName,
          Param = list(list(
            Name = name,
            SubCount = 1,
            DeafultSubId = 0
          ))
        )

        update_workset_param_csv(ws, tmp_csv)

        invisible(self)
      },

      #' @description
      #' Initiate a model run for the model workset/scenario.
      #' @param name Run name.
      #' @param opts Run options. See [opts_run()] for more details.
      #' @param wait Logical. Should we wait until the model run is done?
      #' @param wait_time Number of seconds to wait between status checks.
      #' @param progress Logical. Should a progress bar be shown?
      #' @return Self, invisibly.
      run = function(
        name,
        opts = opts_run(),
        wait = FALSE,
        wait_time = 0.2,
        progress = TRUE
      ) {
        if (rlang::is_false(self$ReadOnly)) {
          rlang::abort('Workset must be read-only to initiate a run.')
        }

        rlang::check_required(name)

        if (name %in% self$ModelRuns$Name) {
          rlang::abort('ModelRun name already in use, choose a different name.')
        }

        if (!inherits(opts, 'OpenMppRunOpts')) {
          rlang::abort(
            '`opts` argument must be an `openmpp::opts_run()` object'
          )
        }

        if (
          rlang::is_null(self$BaseRunDigest) | nchar(self$BaseRunDigest) == 0
        ) {
          rlang::warn(
            'Cannot find base run. Consider setting a base run with `$set_base_digest()`.'
          )
        } else {
          opts$Opts$OpenM.BaseRunDigest <- self$BaseRunDigest
        }

        opts$Opts$OpenM.RunName <- name
        opts$ModelDigest <- self$ModelDigest
        opts$Opts$OpenM.SetName <- self$WorksetName

        run_model(opts)

        run_stamp <- opts$RunStamp
        max_sim <- as.integer(opts$Opts$Parameter.SimulationCases)

        if (wait) {
          if (progress) {
            cli::cli_progress_bar(
              total = max_sim,
              format = 'Running Simulation {cli::pb_bar}{cli::pb_percent} [{cli::pb_elapsed}]'
            )
          }

          is_done <- private$.get_run_done(self$ModelDigest, run_stamp)
          is_simulating <- TRUE
          shown_finalizer <- FALSE

          while (!is_done) {
            if (is_simulating & progress) {
              prog <- .get_run_progress(self$ModelDigest, run_stamp)
              cli::cli_progress_update(set = prog)
              is_simulating <- prog < max_sim
            }

            if (!is_simulating & progress & !shown_finalizer) {
              cli::cli_progress_message('Finalizing model run...')
              shown_finalizer <- TRUE
            }

            is_done <- private$.get_run_done(self$ModelDigest, run_stamp)
            Sys.sleep(wait_time)
          }
        }
        invisible(self)
      }
    ),
    private = list(
      .workset = NULL,
      .params = NULL,
      .set_workset_metadata = function() {
        self$WorksetName = private$.workset$Name
        self$WorksetMetadata = purrr::discard_at(private$.workset, 'Param')
      },
      .set_workset = function(model, set) {
        private$.workset = get_workset(model, set)
      },
      .add_params = function(names) {
        current <- private$.params
        total <- sort(unique(c(current, names)))
        private$.params <- total
        invisible(self)
      },
      .load_param_bindings = function() {
        private$.params <- NULL
        self$Parameters <- rlang::env()
        purrr::walk(private$.workset$Param, \(param) {
          private$.add_params(param$Name)
          f <- function(data) {
            param_name <- param$Name
            if (missing(data)) {
              return(self$get_param(param_name))
            }
            self$set_param(param_name, data)
            invisible(self)
          }
          rlang::env_bind_active(self$Parameters, '{param$Name}' := f)
        })
      },
      .pivot_wide = pivot_wide_impl,
      .pivot_long = pivot_long_impl,
      .get_run_progress = function(model, run) {
        safe_status <- purrr::possibly(
          \(m, r) {
            get_model_run_status(m, r)$Progress |>
              purrr::map_int(\(x) x$Value) |>
              sum()
          },
          otherwise = 0L
        )
        safe_status(model, run)
      },
      .get_run_done = function(model, run) {
        get_model_run_state(model, run)$IsFinal
      },
      .check_modifiable = function(call = rlang::caller_env()) {
        if (rlang::is_true(self$ReadOnly)) {
          rlang::abort(
            message = 'Cannot modify a read-only workset.',
            call = call
          )
        }
      },
      .check_param_exists = function(param, call = rlang::caller_env()) {
        if (!param %in% private$.params) {
          rlang::abort(
            message = glue::glue(
              'Parameter `{param}` does not exist in this workset.'
            ),
            call = call
          )
        }
      },
      .check_any_params = function(call = rlang::caller_env()) {
        if (rlang::is_null(private$.params)) {
          rlang::abort(
            message = 'There are no parameters available in this workset.',
            call = call
          )
        }
      }
    ),
    active = list(
      #' @field ReadOnly Workset read-only status.
      ReadOnly = function(x) {
        if (missing(x)) {
          return(get_workset(self$ModelDigest, self$WorksetName)$IsReadonly)
        }
        if (!rlang::is_scalar_logical(x)) {
          rlang::abort('Must be a scalar logical (TRUE or FALSE).')
        }
        set_workset_readonly(self$ModelDigest, self$WorksetName, as.integer(x))
        invisible(self)
      },

      #' @field BaseRunDigest Base run digest for input parameters.
      BaseRunDigest = function(base) {
        if (missing(base)) {
          return(private$.workset$BaseRunDigest)
        }
        if (nchar(base) == 0) {
          delete_base_digest()
          return(invisible(self))
        }
        set_base_digest(base)
      }
    )
  )
