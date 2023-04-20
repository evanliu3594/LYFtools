#' Get a simple date for document naming
#'
#' @param x `NULL` or a `Date`, if NULL, returns the present date.
#'
#' @return A 6-number long string, first 2 is the year; middle 2 is the month; last 2 is the day.
#' @importFrom stringr str_glue
#' @importFrom lubridate is.Date
#' @importFrom lubridate as_date
#' @export
#'
#' @examples
#' simple_date()
#' simple_date(as.Date("2023-09-09"))
simple_date <- function(x = NULL) {
  if (is.null(x)) format(Sys.Date(), "%y%m%d")
  else if (is.Date(x)) format(x, "%y%m%d")
  else if (is.character(x)) format(as_date(x), "%y%m%d")
}



#' Get a more suitable bounding box of a sf/sfc object according to the precising for raster-making
#'
#' @param x the sf/sfc object
#' @param precise the precise/size of the ideal raster
#'
#' @return a sf-bbox object
#' @importFrom stringr str_detect
#' @importFrom purrr imap_dbl
#' @importFrom sf st_bbox
#' @importFrom sf st_crs
#' @export
#'
#' @examples
#' sf::st_bbox(cnmap_simple)
#' larger_bbox(cnmap_simple, precise = 0.25)
larger_bbox <- function(x, precise = 0.25) {

  bbox <- st_bbox(x)

  bbox |> imap_dbl( ~ {

    a <- round(.x, floor(-1 * log10(precise)))

    if (str_detect(.y, "min")) {
      if (a < .x) while (a < .x - precise) {a <- a + precise}
      else if (a > .x) while (a > .x) {a <- a - precise}
    } else if (str_detect(.y, "max")) {
      if (a < .x) while (a < .x) {a <- a + precise}
      else if (a > .x) while (a > .x + precise) {a <- a - precise}
    }

    return(a)

  }) |> st_bbox(crs = st_crs(x))

}


#' Check if the path exist, if not, create every dir in the path.
#'
#' @param path A string of file path that you want to use for save a file.
#' Note that it must direct to a file not a folder.
#'
#' @return the checked `path` same as input
#'
#' @export
#'
#' @examples
#' force_path_validate("~/THE/FILE/PATH/THAT/YOU/WANT/TO/TEST.TXT")
force_path_validate <- function(path) {

  dir <- path %>% dirname() %>% str_split_1("\\+|/+")

  if_not_exist_then_create <- \(x) {if (!dir.exists(x)) dir.create(x); return(x)}

  Reduce(\(d1, d2) if_not_exist_then_create(file.path(d1, d2)), dir)

  return(path)
}
