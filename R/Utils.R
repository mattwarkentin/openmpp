#' OpenM++ Web API URL
api_url <- function() {
  'http://localhost:4077'
}

#' Are data frames compatible?
#' @param x New parameters.
#' @param y Old parameters
is_compatible <- function(x, y) {
  if (!all(is.data.frame(x), is.data.frame(y))) {
    rlang::abort('New and old parameters must be data frames')
  }
  if (!nrow(x) == nrow(y)) {
    rlang::abort('New parameters must have the same number of rows as old parameters')
  }
  if (!dim(x)[[2]] == dim(y)[[2]]) {
    rlang::abort('New parameters must have the same number of columns as old parameters')
  }
  if (!all(colnames(x) == colnames(y))) {
    rlang::abort('New parameters must have the same columns as old parameters, and in the same order')
  }
}
