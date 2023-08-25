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

      #' @field Params List of input parameters.
      Params = NULL,

      #' @description
      #' Create a new OncoSimXWorkset object.
      #' @param model Model digest or name.
      #' @param set Workset name.
      #' @return A new `OncoSimXWorkset` object.
      initialize = function(model, set) {
        super$initialize(model)
        private$.workset = get_workset(model, set)
        self$WorksetName = private$.workset$Name
        self$WorksetMetadata = purrr::discard_at(private$.workset, 'Param')
        self$BaseRunDigest <- private$.workset$BaseRunDigest
        self$Params <- vector('list', length(private$.model$ParamTxt))
        self$Params <- rlang::set_names(self$Params, purrr::map_chr(private$.model$ParamTxt, \(x) x$Param$Name))
      },

      #' @description
      #' Retrieve a parameter table.
      #' @param name Parameter name.
      #' @return A `tibble`.
      get_param = function(name) {
        if (rlang::is_null(self$Params[[name]])) {
          private$.load_param(name)
        }
        self$Params[[name]]
      },

      #' @description
      #' Refresh parameters.
      #' @return Self, invisibly.
      refresh_params = function() {
        to_refresh <- purrr::keep(self$Params, is.data.frame)
        purrr::walk(names(to_refresh), private$.load_param, .progress = 'Refreshing Parameters')
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
      #' Copy a parameter from a base scenario.
      #' @param names Character vector of parameter names.
      #' @return Self, invisibly.
      copy_params = function(names) {
        if (rlang::is_null(self$BaseRunDigest)) {
          rlang::abort('Cannot copy parameters without a base scenario.')
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

        purrr::walk(names, private$.load_param, .progress = 'Copying Parameters')
        invisible(self)
      },

      #' @description
      #' Copy all parameters from a base scenario.
      #' @return Self, invisibly.
      copy_params_all = function() {
        if (rlang::is_null(self$BaseRunDigest)) {
          rlang::abort('Cannot copy parameters without a base scenario.')
        }

        purrr::walk(
          .x = names(self$Params),
          .f = \(name) copy_param_run_to_workset(
            model = self$ModelDigest,
            set = self$WorksetName,
            name = name,
            run = self$BaseRunDigest
          ),
          .progress = 'Copying Parameters'
        )

        purrr::walk(names(self$Params), private$.load_param,
                    .progress = 'Loading Parameters')
        invisible(self)
      },

      #' @description
      #' Create directory for scenario.
      #' @param dir Root directory for scenario.
      #' @return Self, invisibly.
      create_dir = function(dir = '.') {
        dir <- fs::path_real(dir)
        if (!fs::dir_exists(dir)) {
          rlang::abort('Invalid directory path')
        }

        dir_path <- glue::glue('{dir}/{self$ModelName}.set.{self$WorksetName}')

        dir_to_create <- glue::glue('{dir_path}/set.{self$WorksetName}')

        fs::dir_create(dir_to_create)
        self$WorksetDir <- dir_path
        invisible(self)
      },

      #' @description
      #' Write a parameter to disk (CSV format).
      #' @param name Parameter name.
      #' @return Self, invisibly.
      extract_param = function(name) {
        if (rlang::is_null(self$WorksetDir)) {
          rlang::abort('Cannot find workset directory.')
        }

        data <- self$get_param(name)
        if (is.data.frame(data)) {
          readr::write_csv(data, glue::glue('{self$WorksetDir}/set.{self$WorksetName}/{name}.csv'))
        }

        private$.extracted <- append(private$.extracted, name)

        invisible(self)
      },

      #' @description
      #' Write all parameters to disk (CSV format).
      #' @return Self, invisibly.
      extract_params = function() {
        to_extract <- names(purrr::keep(self$Params, is.data.frame))
        purrr::walk(to_extract, self$extract_param, .progress = 'Extracting Parameters')
        invisible(self)
      },

      #' @description
      #' Upload parameters from a directory.
      #' @return Self, invisibly.
      upload_params = function() {
        zip_dir <- private$.prepare_upload()
        upload_workset_params(self$ModelName, self$WorksetName, zip_dir)
        Sys.sleep(1) # wait for updates to register
        self$refresh_params()
        invisible(self)
      },

      #' @description
      #' Run scenario
      #' @param name Run name.
      #' @param opts Run options.
      #' @param wait Logical. Should we wait until the model run is done?
      #' @param wait_time Number of seconds to wait between status checks.
      #' @return Self, invisibly.
      run = function(name, opts = opt_runs(), wait = FALSE, wait_time = 0.1) {
        if (rlang::is_false(self$ReadOnly)) {
          rlang::abort('Workset must be read-only to initiate a run.')
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
      .params_loaded = FALSE,
      .load_param = function(name) {
        data = private$.pivot_wide(get_workset_param_csv(self$ModelDigest, self$WorksetName, name))
        self$Params[[name]] = data
        invisible(self)
      },
      .extracted = NULL,
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
        purrr::walk2(pars, data_wide, \(n, d) {
          attributes(d) <- attributes(self$Params[[n]])
          self$Params[[n]] <- d
        })
        data_long <- purrr::map(pars, \(p) private$.pivot_long(self$get_param(p)))

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
        if (missing(x)) return(self$WorksetMetadata$IsReadonly)
        set_workset_readonly(self$ModelDigest, self$WorksetName, as.integer(x))
        self$WorksetMetadata$IsReadonly <- x
        invisible(self)
      }
    )
  )
