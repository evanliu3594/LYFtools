#' Get a simple date for document naming
#'
#' @param x `NULL` or a `Date`, if NULL, returns the present date.
#'
#' @return A 6-number long string, first 2 is the year; middle 2 is the month; last 2 is the day.
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


#' Split dataframe into list of dataframes based on selection.
#'
#' @param .data A `data.frame`, either a `tibble` or a `data.frame` is okay.
#' @param ... `<tidy-select>` syntax for picking out column(s) to split.
#' @param keep A Boolean value to decide whether the column should kept in the splited data.frame.
#'
#' @return A named-list consists of pieces of `data.frame`s.
#' @import dplyr
#' @importFrom tidyr unite
#' @export
#'
#' @examples
#' CO2 |> split_by(Plant,Type)
split_by <- function(.data, ..., keep = F) {
  name_str <- .data |> select(...) |> unite("new_col", sep = "_") |>
    pull(new_col) |> unique() |> sort()
  splitted <- .data |> group_split(..., .keep = keep) |> set_names(name_str)
  return(splitted)
}

#' Get a more suitable bounding box of a sf/sfc object according to the precising for raster-making
#'
#' @param x the sf/sfc object
#' @param precise the precise/size of the ideal raster
#'
#' @return a bounding box object
#' @importFrom purrr imap_dbl
#' @importFrom sf st_bbox
#' @importFrom sf st_crs
#' @export
#'
#' @examples
#' sf::st_bbox(cnmap_simplified)
#' larger_bbox(cnmap_simplified, precise = 0.25)
larger_bbox <- function(x, precise = 0.25) {

  bbox <- st_bbox(x)

  bbox |> imap_dbl( ~ {

    a <- round(.x, floor(-1 * log10(precise)))

    if (grepl("min", .y)) {
      if (a < .x) while (a < .x - precise) {a <- a + precise}
      else if (a > .x) while (a > .x) {a <- a - precise}
    } else if (grepl("max", .y)) {
      if (a < .x) while (a < .x) {a <- a + precise}
      else if (a > .x) while (a > .x + precise) {a <- a - precise}
    }

    return(a)

  }) |> st_bbox()

}


#' Check if the path exist, if not, create every dir in the path.
#'
#' @param path A string of file path that you want to use for save a file.
#' Note that it must direct to a file not a folder.
#' @return the checked `path` same as input
#'
#' @export
#'
#' @examples
#' mk_path("~/THE/FILE/PATH/THAT/YOU/WANT/TO/TEST.TXT")
mk_path <- function(path) {

  if (!dir.exists(dirname(path))) {
    dir.create(dirname(path), recursive = T)
  }

  return(path)

}

#' Get file name from a path, without file ext or with modified file ext.
#'
#' @param path Path to a file (Attention: NOT A DIR). String of file path.
#' @param new.ext String, for the designated file extension.
#' By default `""` represent not changing anything. If any string was provided, the returned
#' file name will be attached with the new file extension.
#'
#' @return String, file name without file ext, or with modified file ext.
#' @export
#'
#' @examples
#' writeLines("","test.R")
#' get_fname("./test.R")
#' unlink("test.R")
#' # run in Rstudio script panel:
#' \dontrun{
#'  rstudioapi::getActiveDocumentContext()$path |> get_fname(keep.ext = TRUE)
#'}
get_fname <- function(path, new.ext = "") {

  str_exct <- function(string, pattern) {
    regmatches(string, gregexpr(pattern, string, perl = T))[[1]][1]
  }

  if (!grepl("\\.",basename(path)) & new.ext == "") {
    return(basename(path))
  } else if (!grepl("\\.",basename(path)) & new.ext != "") {
    return(paste0(basename(path), ".", new.ext))
  } else if (grepl("\\.",basename(path)) & new.ext == "") {
    return(str_exct(basename(path),".*(?=\\.)"))
  } else {
    return(paste0(
      str_exct(basename(path),".*(?=\\.)"),".", new.ext
    ))
  }
}


