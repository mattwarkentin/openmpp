#' Run Configuration Options
#'
#' @param SimulationCases Number of cases to simulate. Default is 5000.
#' @param SubValues Number of sub values. Default is 12.
#' @param RunStamp Run stamp.
#' @param Tables List of tables to output.
#' @param ... Not currently used.
#'
#' @export
opts_run <- function(
  SimulationCases = '5000',
  SubValues = '12',
  RunStamp = NULL,
  Tables = list(),
  ...
) {
  if (rlang::is_null(RunStamp)) {
    RunStamp <- sub('.' , '_', fixed = TRUE, format(Sys.time(),"%Y_%m_%d_%H_%M_%OS3"))
  }

  structure(
    list(
      Mpi = list(
        Np = 4,
        IsNotOnRoot = TRUE
      ),
      Opts = list(
        Parameter.SimulationCases = SimulationCases,
        OpenM.SubValues = SubValues,
        OpenM.RunStamp = RunStamp,
        OpenM.Threads = '4'
      ),
      Tables = Tables
    ),
    class = c('OpenMRunOpts', 'list')
  )
}

#' @rdname opts_run
#' @param x Object to print.
#' @export
print.OpenMRunOpts = function(x, ...) {
  print(jsonlite::toJSON(x, pretty = TRUE, auto_unbox = TRUE))
}
