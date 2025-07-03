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
#'
#' @importFrom dplyr group_by
#' @importFrom tidyr unite nest
#' @importFrom tibble deframe
#' @export
#'
#' @examples
#' CO2 |> split_by(Plant,Type)
split_by <- function(.data, ..., keep = F) {
  splitted <- .data |> group_by(...) |> nest() |> unite("GRP", ...) |> deframe()
  return(splitted)
}

#' Get a more suitable bounding box of a sf/sfc object according to the resolution for raster-making
#'
#' @param x the sf/sfc object
#' @param res the resolution/precise/size of the ideal raster
#' @param dx the longitude resolution/precise/size of the ideal raster
#' @param dy the latitude resolution/precise/size of the ideal raster
#'
#' @return a bounding box object
#' @importFrom sf st_bbox
#' @importFrom sf st_crs
#' @export
#'
#' @examples
#' sf::st_bbox(cnmap_simplified)
#' larger_bbox(cnmap_simplified)
#' larger_bbox(cnmap_simplified, res = 2/3)
#' larger_bbox(cnmap_simplified, dx = 1/12)
#' larger_bbox(cnmap_simplified, dx = 2.5, dy = 2)
larger_bbox <- function(x, res = NULL, dx = NULL, dy = NULL) {

  bbox <- st_bbox(x)

  if (all(c(is.null(res), is.null(dx), is.null(dy)))) {
    warning("No valid res, dx and dy supplied, use `1` as default resolution.")
    dx <- dy <- 1
  } else if (all(c(!is.null(res), is.null(dx), is.null(dy)))) {
    dx <- dy <- res
  } else if (all(c(is.null(res), xor(is.null(dx), is.null(dy))))) {
    warning("Only resolution of one dimension supplied, use as both.")
    dx <- dx %||% dy
    dy <- dx %||% dy
  }

  bbox_new <- c(
    xmin = floor(bbox[["xmin"]]),
    xmax = ceiling(bbox[["xmax"]]),
    ymin = floor(bbox[["ymin"]]),
    ymax = ceiling(bbox[["ymax"]])
  )

  cols <- ceiling((bbox_new[["xmax"]] - bbox_new[["xmin"]]) / dx)
  rows <- ceiling((bbox_new[["ymax"]] - bbox_new[["ymin"]]) / dy)

  bbox_new[["xmax"]] <- bbox_new[["xmin"]] + cols * dx
  bbox_new[["ymin"]] <- bbox_new[["ymax"]] - rows * dy

  while(bbox_new[["xmax"]] < bbox[["xmax"]] | bbox_new[["xmax"]] %% 1 != 0) {
    bbox_new[["xmax"]] <- bbox_new[["xmax"]] + dx 
  }
  
  while(bbox_new[["ymin"]] > bbox[["ymin"]] | bbox_new[["ymin"]] %% 1 != 0) {
    bbox_new[["ymin"]] <- bbox_new[["ymin"]] - dy 
  }

  return(st_bbox(bbox_new, crs = st_crs(x)))

}

#' Get file extension.
#'
#' @param fname file name/path.
#'
#' @return file ext, or 0 length character if no extension detected.
#' @export
#'
#' @examples
#' # run in Rstudio script panel:
#' \dontrun{
#'   writeLines("","test.R")
#'   get_fileext("./test.R")
#'   unlink("test.R")
#'   rstudioapi::getActiveDocumentContext()$path |> get_fname(keep.ext = TRUE)
#' }
get_fileext <- function(fname) {

  if (grepl("\\.", fname)) {
    return(regmatches(fname, gregexpr("(?<=\\.)[^\\.]+$", fname, perl = T))[[1]][1])
  } else {
    cat("No validate file extension detected.")
    return("")
  }
}

#' Get gray scale of color(s), useful when deciding color of text above a background color.
#'
#' @param color vector of character, hex RGB color or default color space.
#'
#' @return grayscale from 0(pure black) to 100 (pure bright)
#' @export
#'
#' @examples
#' get_grayscale("red")
#'
#' get_grayscale(c("red", "yellow", "green"))
#'
#' \dontrun{
#'   library(tidyverse)
#'   df1 <- matrix(colors()[1:120], ncol = 6) %>%  as.data.frame() %>% rownames_to_column("Row") %>%
#'     pivot_longer(cols = -1, names_to = "Col", names_prefix = "V") %>%
#'     mutate(across(Row:Col, as.numeric))

#'   ggplot(df1, aes(x = Col, y = Row)) +
#'     geom_raster(aes(fill = value)) +
#'     geom_text(aes(label = value, color = if_else(get_grayscale(value) > 60, "black", "white"))) +
#'     scale_fill_identity() +
#'     scale_color_identity() +
#'     theme_void()
#' }
get_grayscale <- function(color) {
  RGB <- t(grDevices::col2rgb(color))
  Gray <- 0.299 * RGB[,"red"] + 0.587 * RGB[,"green"] + 0.114 * RGB[,"blue"]
  return(Gray/255*100)
}
