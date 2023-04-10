#' get a simple date for document naming
#'
#' @param x `NULL` or a `Date` format num, if NULL, returns the present date.
#'
#' @return 6-charactor long numbers first 2 is the year; middle 2 is the month; last 2 is the date.
#' @importFrom stringr str_glue
#' @export
#'
#' @examples
#' simple_date()
#' simple_date(as.Date("2023-09-09"))
simple_date <- function(x = NULL) {
  if (is.null(x)) format(Sys.Date(), "%y%m%d")
  else if (is.Date(x)) format(x, "%y%m%d")
  else if (is.character(x)) warning(str_glue(
  "`simple_date()` only accepts `Date` formate.\n\\
  Do you mean `simple_adte(as.Date(\'{x}\'))`?"))
}

#' get a more suitable bounding box of a sf/sfc object according to the precising for raster-making
#'
#' @param x the sf/sfc object
#' @param percise the percise of the ideal raster
#'
#' @return a sf-bbox object
#' @importFrom magrittr %>%
#' @export
#'
#' @examples
#' sf::st_bbox(mapchina::china)
#' larger_bbox(mapchina::china, percise = 0.1)
larger_bbox <- function(x, precise = 0.25) {

  bbox <- sf::st_bbox(x)

  d <- floor(-1 * log10(precise))

  bbox %>% imap_dbl( ~ {

    a <- round(.x, digits = d)

    if (str_detect(.y, "min") & a > .x) {
      while(a > .x) {a = a - precise}
    } else if (str_detect(.y, "min") & a < .x - precise) {
      while(a < .x - percise) {a = a + precise}
    } else if (str_detect(.y, "max") & a < .x) {
      while(a < .x) {a = a + precise}
    } else if (str_detect(.y, "max") & a > .x + precise) {
      while(a > .x + precise) {a = a - precise}
    }

    return(a)

  }) %>% sf::st_bbox()

}
