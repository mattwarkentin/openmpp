#' Run Configuration Options
#'
#' @param SimulationCases Number of cases to simulate. Default is 5000.
#' @param SubValues Number of sub values. Default is 12.
#' @param RunStamp Run stamp. Default is generated based on the current time.
#' @param Opts Additional options to pass to the `Opts` list component.
#' @param ... Any other run options.
#'
#' @details The default number of `SimulationCases` is low to enable rapid
#'   iteration but should be increased when running a model where the results
#'   are expected to be robust.
#'
#' @examples
#' opts <- opts_run()
#' print(opts)
#'
#' @export
opts_run <- function(
  SimulationCases = 5000,
  SubValues = 12,
  RunStamp = TimeStamp(),
  Opts = list(),
  ...
) {
  if (!rlang::is_scalar_integerish(SimulationCases)) {
    rlang::abort('`SimulationCases` must be a scalar integer.')
  }

  if (!rlang::is_scalar_integerish(SubValues)) {
    rlang::abort('`SubValues` must be a scalar integer.')
  }

  SimulationCases <- format(SimulationCases, scientific = FALSE)

  structure(
    list(
      RunStamp = RunStamp,
      Opts = c(
        list(
          Parameter.SimulationCases = SimulationCases,
          OpenM.SubValues = as.character(SubValues),
          OpenM.RunStamp = RunStamp,
          OpenM.LogToConsole = 'true'
        ),
        Opts
      ),
      ...
    ),
    class = c('OpenMppRunOpts', 'list')
  )
}

#' @rdname opts_run
#' @param x Object to print.
#' @export
print.OpenMppRunOpts = function(x, ...) {
  cli::cat_line('OpenM++ Run Options')
  print(jsonlite::toJSON(x, pretty = TRUE, auto_unbox = TRUE))
}

TimeStamp <- function() {
  sub('.', '_', fixed = TRUE, format(Sys.time(), "%Y_%m_%d_%H_%M_%OS3"))
}
