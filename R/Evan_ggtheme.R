#' My ggplot2 theme for scientific plotting use
#'
#' @return a ggplot theme object
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 unit
#' @importFrom ggplot2 element_blank
#' @importFrom ggplot2 element_rect
#' @importFrom ggplot2 element_line
#' @importFrom ggplot2 element_text
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(mtcars, aes(x = mpg, y = cyl)) + geom_point() + Evantheme()
Evantheme <- function() {

  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(
      fill = "white",
      colour = "black",
      linewidth = 0.75
    ),
    plot.margin = unit(c(1, 1, 1, 1), "cm"),
    legend.background = element_blank(),
    legend.title = element_blank(),
    legend.key = element_blank(),
    legend.key.size = unit(0.7, "cm"),
    legend.position = c(.15, 0.75),
    legend.text = element_text(
      family = "sans",
      colour = "black",
      size = 12,
      face = "bold"
    ),
    axis.ticks = element_line(colour = "black", linewidth = 0.6),
    axis.line = element_line(colour = "black", linewidth = 0.75),
    axis.text = element_text(
      family = "sans",
      color = 'black',
      size = 14,
      face = "bold"
    ),
    axis.title = element_text(
      family = "sans",
      size = 15,
      face = "bold",
      hjust = 0.5,
      vjust = 5
    )
  )
}
