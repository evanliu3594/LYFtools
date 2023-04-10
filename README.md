
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
object. The result is more suitable for gemerating a fishnet object

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
#> [1] 35.45
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
#>    Time      SO2      NO2       O3       CO     PM2.5     PM10
#> 1     0 242.6257 761.2383 441.7784 57.31160 231.47957 277.5754
#> 2     1 316.4681 915.2322 468.7658 39.14516 140.73800 601.8480
#> 3     2 289.0914 742.7511 475.1711 29.05471 222.02192 478.0167
#> 4     3 310.1521 852.7636 594.6932 35.25726 119.40714 494.5166
#> 5     4 299.8888 743.6371 449.3525 50.51264 243.46086 347.0702
#> 6     5 295.7599 807.9815 452.9804 53.97953 292.17325 430.7133
#> 7     6 295.9732 770.4203 496.2096 47.98663 199.86504 213.3725
#> 8     7 315.9258 960.5143 532.0343 40.49272 256.82346 241.8002
#> 9     8 308.1943 913.1947 465.7292 49.12602 218.50489 455.3945
#> 10    9 304.4796 693.9921 603.4630 27.59118 157.01251 357.0583
#> 11   10 316.5719 666.2118 595.2416 33.06928 301.18035 250.2035
#> 12   11 299.8030 774.3758 500.7867 14.80000 154.12117 349.4038
#> 13   12 279.8789 834.2290 433.0110 56.97674 149.53955 445.1933
#> 14   13 325.6006 737.7501 437.0188 56.15107 102.29507 286.3298
#> 15   14 313.5052 856.3720 568.2458 36.74627 178.03716 164.9221
#> 16   15 312.4194 877.4012 571.2283 61.96726 242.72866 437.5008
#> 17   16 309.2482 791.2892 644.1735 43.18313 326.49419 221.2025
#> 18   17 330.3780 741.7705 585.4396 43.39476 255.11425 305.8159
#> 19   18 283.3191 830.3254 533.7729 28.10809 212.34709 282.3441
#> 20   19 297.7253 700.9475 418.1442 29.63213 300.38788 438.3009
#> 21   20 327.1535 857.8695 485.9769 42.35921 172.48372 556.1104
#> 22   21 301.3185 839.2377 525.5475 37.38395 113.19143 279.7142
#> 23   22 288.4837 737.5199 524.6151 41.74071 231.44255 368.0500
#> 24   23 285.9941 660.8120 471.7858 55.81484  95.61272 298.2107
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
#>  1     0  63.2  156.  155.  195.    NA    NA
#>  2     1  73.8  172.  159.  158.    NA    NA
#>  3     2  69.9  154.  159.  138.    NA    NA
#>  4     3  72.9  165.  174.  151.    NA    NA
#>  5     4  71.4  154.  156.  181.    NA    NA
#>  6     5  70.8  161.  157.  188.    NA    NA
#>  7     6  70.9  157.  162.  176.    NA    NA
#>  8     7  73.7  176.  167.  161.    NA    NA
#>  9     8  72.6  171.  158.  178.    NA    NA
#> 10     9  72.1  149.  175.  135.    NA    NA
#> # ℹ 14 more rows

sampleConc %>% rowwise() %>% mutate(
  AQI_h = Calc_Hourly_AQI(SO2 = SO2, NO2 = NO2,CO = CO,O3 = O3), .keep = 'none'
)
#> # A tibble: 24 × 1
#> # Rowwise: 
#>    AQI_h
#>    <dbl>
#>  1  195.
#>  2  172.
#>  3  159.
#>  4  174.
#>  5  181.
#>  6  188.
#>  7  176.
#>  8  176.
#>  9  178.
#> 10  175.
#> # ℹ 14 more rows
```

``` r

## Calculate Daily Concentration and daily AQI

sampleConc_daily_mean <- sampleConc %>% select(-Time) %>% 
  imap_dbl(~DaliyMeanConc(Pollu = .y, Conc = .x))

sampleConc_daily_mean
#>      SO2      NO2       O3       CO    PM2.5     PM10 
#> 302.0816 794.4932 544.1461  42.1577 204.8526 357.5278

sampleConc_daily_iaqi <- sampleConc_daily_mean %>% imap_dbl(~IAQI_Daily(Pollu = .y, Conc = .x))

sampleConc_daily_iaqi
#>      SO2      NO2       O3       CO    PM2.5     PM10 
#> 123.3972 423.4175 252.1768 351.3142 254.8526 210.7540
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
