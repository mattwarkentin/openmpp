#' OncoSimX Workset Class
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
#'
#' @import tidyr tidyselect
#'
#' @return An `OncoSimXWorkset` instance.
#'
#' @details `load_scenario()` is an alias for `load_workset()`.
#'
#' @export
load_workset <- function(model, set) {
  OncoSimXWorkset$new(model, set)
}

#' @rdname load_workset
#' @export
load_scenario <- load_workset

#' @rdname load_workset
#' @export
OncoSimXWorkset <-
  R6::R6Class(
    classname = 'OncoSimXWorkset',
    inherit = OncoSimXModel,
    cloneable = FALSE,
    portable = FALSE,
    lock_objects = FALSE,
    public = list(
      #' @field WorksetName Workset name.
      WorksetName = NULL,

      #' @field WorksetMetadata Workset metadata.
      WorksetMetadata = NULL,

      #' @field WorksetDir Workset directory.
      WorksetDir = NULL,

      #' @field BaseRunDigest Base run digest for input parameters.
      BaseRunDigest = NULL,

      #' @field Type Object type (used for `print()`).
      Type = 'Workset',

      #' @description
      #' Create a new OncoSimXWorkset object.
      #' @param model Model digest or name.
      #' @param set Workset name.
      #' @return A new `OncoSimXWorkset` object.
      initialize = function(model, set) {
        super$initialize(model)
        private$.set_workset(model, set)
        private$.set_workset_metadata()
        private$.load_param_bindings()
      },

      #' @description
      #' Set the base run digest.
      #' @param base Base run digest.
      #' @return Self, invisibly.
      set_base_digest = function(base) {
        if (rlang::is_scalar_character(base)) {
          self$BaseRunDigest <- base
        }
        invisible(self)
      },

      #' @description
      #' Set the workset archive.
      #' @param dir Root directory for scenario.
      #' @return Self, invisibly.
      set_workset_archive = function(dir) {
        if (!rlang::is_scalar_character(dir)) {
          return(self)
        }
        dir <- fs::path_real(dir)
        if (!fs::dir_exists(dir)) {
          rlang::abort('Invalid directory path')
        }
        self$WorksetDir <- dir
        invisible(self)
      },

      #' @description
      #' Print a `OncoSimXWorkset` object.
      #' @param ... Not currently used.
      #' @return Self, invisibly.
      print = function(...) {
        super$print()
        cli::cli_alert(paste0('WorksetName: ', self$WorksetName))
        cli::cli_alert(paste0('BaseRunDigest: ', self$BaseRunDigest))
        invisible(self)
      },

      #' @description
      #' Retrieve a parameter table.
      #' @param name Parameter name.
      #' @return A `tibble`.
      get_param = function(name) {
        if (name %in% private$.params) {
          return(private$.pivot_wide(get_workset_param_csv(self$ModelDigest, self$WorksetName, name)))
        }
        abort_msg <- glue::glue('Parameter `{name}` is not available in this workset.')
        rlang::abort(abort_msg)
      },

      #' @description
      #' Retrieve a parameter table.
      #' @param name Parameter name.
      #' @param data New parameter data.
      #' @return A `tibble`.
      set_param = function(name, data) {
        if (rlang::is_null(self$WorksetDir)) {
          rlang::abort('Cannot find workset directory.')
        }

        is_compatible(data, self$get_param(name))

        readr::write_csv(
          x = data,
          file = glue::glue('{self$WorksetDir}/set.{self$WorksetName}/{name}.csv')
        )
        private$.add_extracted(name)
        invisible(self)
      },

      #' @description
      #' Copy a parameter from a base scenario.
      #' @param names Character vector of parameter names.
      #' @return Self, invisibly.
      copy_params = function(names) {
        if (rlang::is_null(self$BaseRunDigest) |
            nchar(self$BaseRunDigest) == 0) {
          rlang::abort('Cannot copy parameters without a base scenario. Consider setting a base scenario with `$set_base_digest()`.')
        }

        purrr::walk(
          .x = names,
          .f = \(name) copy_param_run_to_workset(
            model = self$ModelDigest,
            set = self$WorksetName,
            name = name,
            run = self$BaseRunDigest
          )
        )

        private$.set_workset(self$ModelName, self$WorksetName)
        private$.load_param_bindings()
        invisible(self)
      },

      #' @description
      #' Create archive for scenario parameters.
      #' @param dir Root directory for scenario.
      #' @return Self, invisibly.
      create_archive = function(dir = '.') {
        dir <- fs::path_real(dir)
        if (!fs::dir_exists(dir)) {
          rlang::abort('Invalid directory path')
        }

        dir_path <- glue::glue('{dir}/{self$ModelName}.set.{self$WorksetName}')

        dir_to_create <- glue::glue('{dir_path}/set.{self$WorksetName}')

        fs::dir_create(dir_to_create)
        self$set_workset_archive(dir_path)
        invisible(self)
      },

      #' @description
      #' Write a parameter to disk (CSV format).
      #' @param names Parameter names.
      #' @return Self, invisibly.
      extract_params = function(names) {
        if (rlang::is_null(self$WorksetDir)) {
          rlang::abort('Cannot find workset directory.')
        }
        purrr::walk(names, \(name) {
          data <- self$get_param(name)
          readr::write_csv(data, glue::glue('{self$WorksetDir}/set.{self$WorksetName}/{name}.csv'))
        })
        private$.add_extracted(names)
        invisible(self)
      },

      #' @description
      #' Upload parameters from a directory.
      #' @return Self, invisibly.
      upload_params = function() {
        not_ex <- setdiff(private$.params, private$.extracted)
        self$extract_params(not_ex)
        zip_dir <- private$.prepare_upload()
        upload_workset_params(self$ModelName, self$WorksetName, zip_dir)
        invisible(self)
      },

      #' @description
      #' Run scenario
      #' @param name Run name.
      #' @param opts Run options.
      #' @param wait Logical. Should we wait until the model run is done?
      #' @param wait_time Number of seconds to wait between status checks.
      #' @return Self, invisibly.
      run = function(name, opts = opts_run(), wait = FALSE, wait_time = 0.1) {
        if (rlang::is_false(self$ReadOnly)) {
          rlang::abort('Workset must be read-only to initiate a run.')
        }

        if (!inherits(opts, 'OpenMRunOpts')) {
          rlang::abort('`opts` argument must be an `oncosimx::opts_run()` object')
        }

        opts$Opts$OpenM.RunName = name
        opts$ModelDigest = self$ModelDigest
        opts$Opts$OpenM.BaseRunDigest = self$BaseRunDigest
        opts$Opts$OpenM.SetName = self$WorksetName
        run_info <- run_model(opts)

        sp <- cli::make_spinner(template = 'Running Model {spin}')

        is_running <- TRUE
        if (wait) {
          while (is_running) {
            sp$spin()
            Sys.sleep(wait_time)
            status <- get_model_run_status(run_info$ModelDigest, name)$Status
            is_running <- status != 's'
          }
        }
        sp$finish()
        invisible(self)
      }
    ),
    private = list(
      .workset = NULL,
      .params = NULL,
      .extracted = NULL,
      .set_workset_metadata = function() {
        self$WorksetName = private$.workset$Name
        self$WorksetMetadata = purrr::discard_at(private$.workset, 'Param')
        self$BaseRunDigest <- private$.workset$BaseRunDigest
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
      .add_extracted = function(names) {
        current <- private$.extracted
        total <- sort(unique(c(current, names)))
        private$.extracted <- total
        invisible(self)
      },
      .load_param_bindings = function() {
        purrr::walk(private$.workset$Param, \(param) {
          private$.add_params(param$Name)
          f <- function(data) {
            param_name <- param$Name
            if (missing(data)) return(self$get_param(param_name))
            self$set_param(param_name, data)
            invisible(self)
          }
          rlang::env_bind_active(self, '{param$Name}' := f)
        })
      },
      .pivot_wide = function(param) {
        pivot_col <- tidyselect::eval_select(tidyselect::last_col(1), param)
        non_pivot_cols <- tidyselect::eval_select(tidyselect::everything(), param, exclude = c('param_value', names(pivot_col)))
        pwide <-
          param |>
          tidyr::pivot_wider(
            values_from = param_value,
            names_from = tidyselect::any_of(names(pivot_col))
          )
        ats <- attributes(pwide)
        ats[['pivot_col']] <- pivot_col
        ats[['non_pivot_cols']] <- non_pivot_cols
        attributes(pwide) <- ats
        pwide
      },
      .pivot_long = function(param) {
        param |>
        tidyr::pivot_longer(
          cols = -tidyselect::all_of(names(attr(param, 'non_pivot_cols'))),
          names_to = names(attr(param, 'pivot_col')),
          values_to = 'param_value'
        )
      },
      .prepare_upload = function() {
        if (rlang::is_null(self$WorksetDir)) {
          rlang::abort('Cannot find a workset directory to archive.')
        }
        tmp <- tempdir()
        tmp_scene <- glue::glue('{tmp}/{self$ModelName}.set.{self$WorksetName}/set.{self$WorksetName}')
        fs::dir_create(tmp_scene)

        csvs <- fs::dir_ls(self$WorksetDir, recurse = TRUE, glob = '*.csv')
        csvs_files <- fs::path_file(csvs)
        pars <- fs::path_ext_remove(csvs_files)

        data_wide <- purrr::map(csvs, \(d) readr::read_csv(d, progress = FALSE, show_col_types = FALSE))

        data_long <- purrr::map2(pars, data_wide, \(n, d) {
          attributes(d) <- attributes(self$get_param(n))
          private$.pivot_long(d)
        })

        purrr::walk2(csvs_files, data_long, \(n, d) {
          to_create <- glue::glue('{tmp_scene}/{n}')
          readr::write_csv(d, to_create)
        })

        dir_file <- fs::path_file(self$WorksetDir)
        zip_file <- glue::glue('{dir_file}.zip')
        zip_path <- glue::glue('{tmp}/{zip_file}')

        zip::zip(
          zipfile = zip_file,
          files = dir_file,
          root = tmp
        )
        invisible(zip_path)
      }
    ),
    active = list(
      #' @field ReadOnly Workset read-only status.
      ReadOnly = function(x) {
        if (missing(x)) return(private$.workset$IsReadonly)
        if (!rlang::is_scalar_logical(x)) {
          rlang::abort('Must be a scalar logical (TRUE or FALSE).')
        }
        set_workset_readonly(self$ModelDigest, self$WorksetName, as.integer(x))
        private$.set_workset(self$ModelName, self$WorksetName)
        private$.set_workset_metadata()
        invisible(self)
      }
    )
  )
