#' insert export for Roxygen
#'
#' @return insert a "#' @export"
inst_export <- function() {
  rstudioapi::insertText("#\' @export")
}
