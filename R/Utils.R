#' Are data frames compatible?
#' @param x New parameters.
#' @param y Old parameters
is_compatible <- function(x, y) {
  if (!all(is.data.frame(x), is.data.frame(y))) {
    rlang::abort('New and old parameters must both be data frames')
  }
  if (!nrow(x) == nrow(y)) {
    rlang::abort(
      'New parameters must have the same number of rows as old parameters'
    )
  }
  if (!dim(x)[[2]] == dim(y)[[2]]) {
    rlang::abort(
      'New parameters must have the same number of columns as old parameters'
    )
  }
  if (!all(colnames(x) == colnames(y))) {
    rlang::abort(
      'New parameters must have the same column names as old parameters, and in the same order'
    )
  }
}

pivot_wide_impl <- function(param) {
  pivot_col <- tidyselect::eval_select(tidyselect::last_col(1), param)
  non_pivot_cols <- tidyselect::eval_select(
    tidyselect::everything(),
    param,
    exclude = c('param_value', names(pivot_col))
  )
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
}

pivot_long_impl <- function(param) {
  param |>
    tidyr::pivot_longer(
      cols = -tidyselect::all_of(names(attr(param, 'non_pivot_cols'))),
      names_to = names(attr(param, 'pivot_col')),
      values_to = 'param_value'
    )
}

globalVariables(c('param_value'))
