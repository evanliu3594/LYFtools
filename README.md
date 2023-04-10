
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

## random functions

### `larger_bbox()`

`larger_bbox()` is used to get a broader boundin box of a given sf/sfc
object. The result is more suitable for generating a fishnet raster.

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

### `simple_date()`

`simple_date()` is to acquire a abbreviation of the date.

``` r

simple_date()
#> [1] "230410"
simple_date(as.Date("2023-09-09"))
#> [1] "230909"
```

### `convert_amount()`

`convert_amount()` is used for convert and reform the values between
Chinese quantifiers

``` r
convert_amount(66, "兆瓦", "万千瓦")
#> [1] 6.6
```

### `convert_coord()`

`convert_coord()` is used for convert a set of geo-coding (long, lat)
between some Chinese defined coordinate systems and WGS1984 coordinate
system. Note that only works inside China domain

``` r
convert_coord(133, 47, from = "GCJ02", to = "WGS84")
#>       lng       lat 
#> 132.99251  46.99768
```

## AQI_related_funs

根据中华人民共和国生态环境部《环境空气质量指数（AQI）技术规定（HJ633—2012）》中的相关标准和方法，提供五个用于计算AQI的函数

### `DaliyMeanConc()`

`DaliyMeanConc()` calculates daily mean concentration of 6 pollutants.
Note that average `O3` concentration for one day is presented by maximum
8-hour average concentration.

``` r
C <- rnorm(24, 35, 5)
DaliyMeanConc("PM2.5", C)
#> [1] 34.98894
```

### `IAQI_hourly()`

`IAQI_hourly()` is for calculate hourly IAQI for a given pollutant

``` r
IAQI_hourly("O3", 142)
#> [1] 44.375
```

### `Calc_Hourly_AQI()`

`Calc_Hourly_AQI()` calculates the hourly AQI score and the featured
pollutants based on 4 pollutants’ concentration.

``` r
Calc_Hourly_AQI(SO2 = 300,NO2 = 200,CO = 100,O3 = 120)
#>       CO 
#> 333.3333
```

### `IAQI_Daily()`

`IAQI_Daily()` calculates daily IAQI for given pollutant

``` r
IAQI_Daily("O3", 142)
#> [1] 85
```

### `Calc_Daily_AQI()`

`Calc_Daily_AQI()` calculate the daily AQI score and the featured
pollutants based on 6 pollutants’ concentration.

``` r
Calc_Daily_AQI(SO2 = 55, NO2 = 23, CO = 12, O3 = 122, PM2.5 = 35, PM10 = 55)
#>  CO 
#> 140
```

### A sample workflow with AQI series functions with `tidyr` syntax.

``` r
library(tidyverse)
# generating sample data

sampleConc <- data.frame(
  Time = 0:23,
  SO2 = rnorm(24, mean = 300, sd = 20),
  NO2 = rnorm(24, mean = 800, sd = 100),
  O3 = rnorm(24, mean = 500, sd = 100),
  CO = rnorm(24, mean = 40, sd = 10),
  PM2.5 = rnorm(24, mean = 200, sd = 50),
  PM10 = rnorm(24, mean = 350, sd = 100)
)

sampleConc
#>    Time      SO2      NO2       O3       CO    PM2.5     PM10
#> 1     0 297.9394 991.8803 422.8522 32.36080 221.5059 321.7375
#> 2     1 287.8005 772.9189 369.6135 45.49921 285.1372 436.7350
#> 3     2 334.9052 789.1677 278.7325 52.26811 231.3089 373.5271
#> 4     3 305.6483 891.0754 468.2863 39.56334 215.1262 446.4785
#> 5     4 299.2876 772.8921 611.3615 22.49819 232.5042 267.3819
#> 6     5 317.3151 882.9366 640.0317 21.33081 135.0850 402.8993
#> 7     6 323.9950 843.7700 529.2611 52.37139 189.6421 296.9219
#> 8     7 312.5568 857.8773 564.7841 46.38214 317.0888 432.9512
#> 9     8 333.7447 824.2554 467.7477 43.43164 184.6642 433.4196
#> 10    9 301.4273 945.9499 627.6905 42.79061 200.3417 320.8859
#> 11   10 304.7965 744.1788 468.9360 29.40359 239.0756 346.6532
#> 12   11 289.4540 801.1290 565.7164 41.50852 183.3246 291.6065
#> 13   12 294.7686 786.1494 485.8603 41.12290 226.0745 295.7369
#> 14   13 324.8639 858.0576 509.5790 50.77896 189.3294 237.9499
#> 15   14 309.8075 658.3995 681.9845 24.27974 140.1954 253.1937
#> 16   15 286.4895 776.5315 368.6005 28.36813 240.5331 180.5587
#> 17   16 278.3410 658.5173 467.5221 32.30125 259.3955 450.6454
#> 18   17 272.4223 980.2119 411.1513 43.09559 265.7530 215.7867
#> 19   18 306.2255 797.6295 707.4994 39.13226 146.2100 386.6041
#> 20   19 309.2393 785.3150 433.8303 29.45442 215.1846 315.2074
#> 21   20 270.1421 844.6245 560.6245 33.40247 251.2869 355.1312
#> 22   21 308.7904 768.7278 574.1605 25.96621 191.3021 447.0495
#> 23   22 296.6786 817.5186 394.8732 49.03454 262.8930 683.4064
#> 24   23 326.6647 774.7604 451.3712 22.28743 182.0623 461.7590
```

``` r
## Calculate hourly IAQI and AQI

sampleConc %>% 
  pivot_longer(-Time, names_to = 'Pollu', values_to = 'Conc') %>%
  rowwise() %>% mutate(IAQI_h = IAQI_hourly(Pollu, Conc))  %>%
  select(-Conc) %>% pivot_wider(names_from = 'Pollu', values_from = 'IAQI_h')
#> Warning: There were 48 warnings in `mutate()`.
#> The first warning was:
#> ℹ In argument: `IAQI_h = IAQI_hourly(Pollu, Conc)`.
#> ℹ In row 5.
#> Caused by warning in `IAQI_hourly()`:
#> ! PM2.5不是时均IAQI的计算项目
#> ℹ Run ]8;;ide:run:dplyr::last_dplyr_warnings()dplyr::last_dplyr_warnings()]8;; to see the 47 remaining warnings.
#> # A tibble: 24 × 7
#>     Time   SO2   NO2    O3    CO PM2.5  PM10
#>    <int> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1     0  71.1  179.  153.  145.    NA    NA
#>  2     1  69.7  157.  142.  171.    NA    NA
#>  3     2  76.4  159.  120.  185.    NA    NA
#>  4     3  72.2  169.  159.  159.    NA    NA
#>  5     4  71.3  157.  176.  125.    NA    NA
#>  6     5  73.9  168.  180.  123.    NA    NA
#>  7     6  74.9  164.  166.  185.    NA    NA
#>  8     7  73.2  166.  171.  173.    NA    NA
#>  9     8  76.2  162.  158.  167.    NA    NA
#> 10     9  71.6  175.  178.  166.    NA    NA
#> # ℹ 14 more rows

sampleConc %>% rowwise() %>% mutate(
  AQI_h = Calc_Hourly_AQI(SO2 = SO2, NO2 = NO2,CO = CO,O3 = O3), .keep = 'none'
)
#> # A tibble: 24 × 1
#> # Rowwise: 
#>    AQI_h
#>    <dbl>
#>  1  179.
#>  2  171.
#>  3  185.
#>  4  169.
#>  5  176.
#>  6  180.
#>  7  185.
#>  8  173.
#>  9  167.
#> 10  178.
#> # ℹ 14 more rows
```

``` r

## Calculate Daily Concentration and daily AQI

sampleConc_daily_mean <- sampleConc %>% select(-Time) %>% 
  imap_dbl(~DaliyMeanConc(Pollu = .y, Conc = .x))

sampleConc_daily_mean
#>       SO2       NO2        O3        CO     PM2.5      PM10 
#> 303.88766 817.68643 559.44111  37.02634 216.87601 360.59277

sampleConc_daily_iaqi <- sampleConc_daily_mean %>% imap_dbl(~IAQI_Daily(Pollu = .y, Conc = .x))

sampleConc_daily_iaqi
#>      SO2      NO2       O3       CO    PM2.5     PM10 
#> 123.6750 435.6244 255.0357 308.5529 266.8760 215.1325
```

``` r
Calc_Daily_AQI(SO2 = sampleConc_daily_iaqi["SO2"],
               NO2 = sampleConc_daily_iaqi["NO2"],
               CO = sampleConc_daily_iaqi["CO"],
               PM10 = sampleConc_daily_iaqi["PM10"],
               PM2.5 = sampleConc_daily_iaqi["PM2.5"],
               O3 = sampleConc_daily_iaqi["O3"])
#>  CO 
#> Inf
```
