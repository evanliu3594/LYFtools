#' My ggplot2 theme for scientific plotting use
#'
#' @return a ggplot theme object
#' @import ggplot2
#' @export
#'
#' @examples
#' ggplot(mtcars, aes(x = mpg, y = cyl)) + geom_point() + stat_smooth() + Evantheme()
Evantheme <- function() {

  windowsFonts(Calibri = windowsFont("Calibri"))

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
      family = "Calibri",
      colour = "black",
      size = 12,
      face = "bold"
    ),
    axis.ticks = element_line(colour = "black", linewidth = 0.6),
    axis.line = element_line(colour = "black", linewidth = 0.75),
    axis.text = element_text(
      family = "Calibri",
      color = 'black',
      size = 14,
      face = "bold"
    ),
    axis.title = element_text(
      family = "Calibri",
      size = 15,
      face = "bold",
      hjust = 0.5,
      vjust = 5
    )
  ) %>% return()
}
