#' OncoSimX Workset Class
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
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
      #' Create zip archive for parameters.
      #' @return Zip path, invisibly.
      archive_dir = function() {
        if (rlang::is_null(self$WorksetDir)) {
          rlang::abort('No directory to archive.')
        }

        dir_file <- fs::path_file(self$WorksetDir)

        dir_path <- fs::path_dir(self$WorksetDir)

        zip_dir <- glue::glue('{dir_file}.zip')

        zip::zip(
          zipfile = zip_dir,
          files = dir_file,
          root = dir_path
        )
        invisible(glue::glue('{dir_path}/{zip_dir}'))
      },

      #' @description
      #' Write a parameter to disk (CSV format).
      #' @param name Parameter name.
      #' @param folder Folder path.
      #' @return Self, invisibly.
      extract_param = function(name) {
        if (rlang::is_null(self$WorksetDir)) {
          rlang::abort('Must run `create_dir()` before extracting parameters.')
        }

        data <- self$get_param(name)
        if (is.data.frame(data)) {
          readr::write_csv(data, glue::glue('{self$WorksetDir}/set.{self$WorksetName}/{name}.csv'))
        }
        invisible(self)
      },

      #' @description
      #' Write all parameters to disk (CSV format).
      #' @param folder Folder path.
      #' @return Self, invisibly.
      extract_params = function() {
        if (rlang::is_null(self$WorksetDir)) {
          rlang::abort('Must run `create_dir()` before extracting parameters.')
        }
        to_extract <- purrr::keep(self$Params, is.data.frame)
        purrr::iwalk(to_extract, \(p, i) {
          file <- glue::glue('{self$WorksetDir}/set.{self$WorksetName}/{i}.csv')
          readr::write_csv(p, file, progress = FALSE)
        }, .progress = 'Extracting Parameters')
        invisible(self)
      },

      #' @description
      #' Upload parameters from a directory.
      #' @return Self, invisibly.
      upload_params = function() {
        zip_dir <- self$archive_dir()
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
      #' @return List of run information.
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
        run_info
      }
    ),
    private = list(
      .workset = NULL,
      .params_loaded = FALSE,
      .ParamsList = NULL,
      .load_param = function(name) {
        self$Params[[name]] = get_workset_param_csv(self$ModelDigest, self$WorksetName, name)
        private$.ParamsList[[name]] = get_workset_param(self$ModelDigest, self$WorksetName, name)
        invisible(self)
      }
    ),
    active = list(
      #' @field ReadOnly Workset read-only status.
      ReadOnly = function(x) {
        if (missing(x)) return(self$WorksetMetadata$IsReadonly)
        set_workset_readonly(self$ModelDigest, self$WorksetName, as.integer(x))
        self$WorksetMetadata$IsReadonly <- x
        invisible(self)
      },

      #' @field BaseRunDigest Base run digest (scenario) for parameters.
      BaseRunDigest = function(x) {
        private$.workset$BaseRunDigest
      }
    )
  )
