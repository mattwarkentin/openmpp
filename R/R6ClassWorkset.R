#' OncoSimX Workset Class
#'
#' @inheritParams get_model
#' @inheritParams get_workset_param
#'
#' @return An `OncoSimXWorkset` instance.
#'
#' @export
load_workset <- function(model, set) {
  OncoSimXWorkset$new(model, set)
}

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

      #' @field Type Object type (used for `print()`).
      Type = 'Workset',

      #' @description
      #' Create a new OncoSimXWorkset object.
      #' @param model Model digest or name.
      #' @param set Workset name.
      #' @return A new `OncoSimXModel` object.
      initialize = function(model, set) {
        super$initialize(model)
        private$.workset = get_workset(model, set)
        self$WorksetName = private$.workset$Name
        self$WorksetMetadata = purrr::discard_at(private$.workset, 'Param')
      },

      #' @description
      #' Load all parameters.
      #' @return Self, invisibly.
      load_params = function() {
        if (!private$.params_loaded) {
          par_names <- names(self$Params)
          self$Params = purrr::map(par_names, \(x) {
            get_workset_param_csv(self$ModelDigest, self$WorksetName, x)
          }, .progress = TRUE)
          self$Params <- rlang::set_names(self$Params, par_names)
          private$.params_loaded <- TRUE
        }
        invisible(self)
      },

      #' @description
      #' Retrieve a parameter.
      #' @param name Parameter name.
      #' @return A `tibble`.
      get_param = function(name) {
        if (rlang::is_null(self$Params[[name]])) {
          self$Params[[name]] <-
            get_workset_param_csv(self$ModelDigest, self$WorksetName, name)
        }
        self$Params[[name]]
      },

      #' @description
      #' Print a OncoSimXWorkset object.
      #' @param ... Not currently used.
      #' @return  Self, invisibly.
      print = function(...) {
        super$print()
        cli::cli_alert(paste0('WorksetName: ', self$WorksetName))
      },

      #' @description
      #' Write a parameter to disk (CSV).
      #' @param name Parameter name.
      #' @param file Not currently used.
      #' @return  `name`, invisibly.
      extract_param = function(name, file) {
        readr::write_csv(self$get_param(name), file)
      }
    ),
    private = list(
      .workset = NULL,
      .params_loaded = FALSE
    ),
    active = list(
      #' @field ReadOnly Workset read-only status.
      ReadOnly = function(x) {
        if (missing(x)) return(self$WorksetMetadata$IsReadonly)
        set_workset_readonly(self$ModelDigest, self$WorksetName, x)
        x
      }
    )
  )
