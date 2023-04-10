
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
#> [1] 35.15132
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

### A sample workflow with AQI series functions in `tidyr` syntax.

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
#>    Time      SO2       NO2       O3       CO     PM2.5     PM10
#> 1     0 306.3557  612.0725 469.8014 42.60227 244.41796 141.9190
#> 2     1 286.3431  746.3347 359.6976 36.78108 274.25860 275.9438
#> 3     2 268.4964  720.2977 472.9364 37.05268 203.07282 372.0740
#> 4     3 301.9337  901.5530 479.7439 50.42505 185.75630 442.8127
#> 5     4 341.0765  813.9433 486.7712 44.36956 208.26989 269.6353
#> 6     5 322.8969  684.6562 537.5818 34.98413 199.65889 403.5615
#> 7     6 283.1455  795.3328 518.9189 40.32350 201.23236 229.4384
#> 8     7 310.4128  806.9542 560.0303 32.40069 172.59961 416.9313
#> 9     8 315.8487  698.9240 350.2932 30.60192  95.95341 202.7774
#> 10    9 271.6640 1019.1927 422.4195 37.26914 142.70413 328.2276
#> 11   10 307.0951  890.7179 725.3338 37.06648 144.11615 208.3070
#> 12   11 287.4940  848.9241 395.2390 56.43634 221.16731 476.7293
#> 13   12 285.0664  749.6335 590.3431 32.60101 154.10572 200.1340
#> 14   13 284.3717  998.9472 546.3852 37.74400 202.04390 359.2103
#> 15   14 315.7428  788.6416 593.6763 29.09314 236.73486 159.5817
#> 16   15 297.1417  920.2626 689.3741 32.09506 151.21514 438.4101
#> 17   16 319.5296  736.0565 616.3322 42.66792 218.73338 285.9304
#> 18   17 318.8113  837.0339 358.9318 26.62261 274.74324 334.2408
#> 19   18 310.1015  827.5826 546.5909 64.31520 237.27298 448.4139
#> 20   19 311.8132  828.0585 487.3308 33.10280 173.58874 383.3828
#> 21   20 337.6552  618.1172 557.2941 46.27762  88.59431 488.9598
#> 22   21 301.7703  665.7651 672.3558 40.99863 191.77170 309.2743
#> 23   22 309.7715  792.3738 546.9319 54.94175 269.23231 504.3191
#> 24   23 303.1943  768.5232 439.2956 29.82972 199.18266 311.0945
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
#>  1     0  72.3  141.  159.  165.    NA    NA
#>  2     1  69.5  155.  140.  154.    NA    NA
#>  3     2  66.9  152.  159.  154.    NA    NA
#>  4     3  71.7  170.  160.  181.    NA    NA
#>  5     4  77.3  161.  161.  169.    NA    NA
#>  6     5  74.7  148.  167.  150.    NA    NA
#>  7     6  69.0  160.  165.  161.    NA    NA
#>  8     7  72.9  161.  170.  145.    NA    NA
#>  9     8  73.7  150.  138.  141.    NA    NA
#> 10     9  67.4  182.  153.  155.    NA    NA
#> # ℹ 14 more rows

sampleConc %>% rowwise() %>% mutate(
  AQI_h = Calc_Hourly_AQI(SO2 = SO2, NO2 = NO2,CO = CO,O3 = O3), .keep = 'none'
)
#> # A tibble: 24 × 1
#> # Rowwise: 
#>    AQI_h
#>    <dbl>
#>  1  165.
#>  2  155.
#>  3  159.
#>  4  181.
#>  5  169.
#>  6  167.
#>  7  165.
#>  8  170.
#>  9  150.
#> 10  182.
#> # ℹ 14 more rows
```

``` r

## Calculate Daily Concentration and daily AQI

sampleConc_daily_mean <- sampleConc %>% select(-Time) %>% 
  imap_dbl(~DaliyMeanConc(Pollu = .y, Conc = .x))

sampleConc_daily_mean
#>       SO2       NO2        O3        CO     PM2.5      PM10 
#> 304.07217 794.57911 572.38789  39.60843 195.43443 332.97121

sampleConc_daily_iaqi <- sampleConc_daily_mean %>% imap_dbl(~IAQI_Daily(Pollu = .y, Conc = .x))

sampleConc_daily_iaqi
#>      SO2      NO2       O3       CO    PM2.5     PM10 
#> 123.7034 423.4627 257.4557 330.0702 245.4344 191.4856
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
