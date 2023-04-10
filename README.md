
<!-- README.md is generated from README.Rmd. Please edit that file -->

# LYFtools

<!-- badges: start -->
<!-- badges: end -->

The goal of LYFtools is package some of my frequently used functions for
easy use.

# Installation

If you’re interested, you can install the development version of
LYFtools like so:

``` r
devtools::install_github('evanliu3594/LYFtools')
```

# Examples

There are some basic examples which shows you how to use LYFtools:

## `larger_bbox()` is used to get a broader boundin box of a given sf/sfc object. The result is more suitable for gemerating a fishnet object

``` r
library(LYFtools)
library(tidyverse)
#> Warning: 程辑包'dplyr'是用R版本4.2.3 来建造的
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.1     ✔ readr     2.1.4
#> ✔ forcats   1.0.0     ✔ stringr   1.5.0
#> ✔ ggplot2   3.4.1     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
#> ✔ purrr     1.0.1     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the ]8;;http://conflicted.r-lib.org/conflicted package]8;; to force all conflicts to become errors

sf::st_bbox(mapchina::china) %>% 
  stars::st_as_stars(dx = 0.1, dy = 0.1)
#> stars object with 2 dimensions and 1 attribute
#> attribute(s):
#>         Min. 1st Qu. Median Mean 3rd Qu. Max.
#> values     0       0      0    0       0    0
#> dimension(s):
#>   from  to  offset delta refsys x/y
#> x    1 613 73.5008   0.1 WGS 84 [x]
#> y    1 370 53.5608  -0.1 WGS 84 [y]

larger_bbox(mapchina::china, precise = 0.1) %>% 
  stars::st_as_stars(dx = 0.1, dy = 0.1)
#> stars object with 2 dimensions and 1 attribute
#> attribute(s):
#>         Min. 1st Qu. Median Mean 3rd Qu. Max.
#> values     0       0      0    0       0    0
#> dimension(s):
#>   from  to offset delta x/y
#> x    1 614   73.5   0.1 [x]
#> y    1 370   53.6  -0.1 [y]
```

## `simple_date()` is to acquire a abbreviation of the date
