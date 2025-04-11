#' Convert value between common Chinese quantifiers
#'
#' @param value num, the value to be converted
#' @param old.unit chr, the old unit
#' @param new.unit chr, the new unit
#'
#' @return a number of converted value in the new unit
#' @importFrom stringr str_count
#' @importFrom dplyr if_else
#' @export
#'
#' @examples
#' convert_amount(133, "兆瓦", "万千瓦")
convert_amount <- function(value, old.unit, new.unit) {

  factor.detect <- \(x) {

    a <- 1E-12 ^ str_count(x, "皮") *
      1E-6 ^ stringr::str_count(x, "微") *
      1E-3 ^ stringr::str_count(x, "毫") *
      1E-2 ^ stringr::str_count(x, "厘") *
      1E-1 ^ stringr::str_count(x, "分") *
      1E2 ^ stringr::str_count(x, "百") *
      1E3 ^ stringr::str_count(x, "千|k|公里|公斤") *
      1E4 ^ stringr::str_count(x, "万") *
      1E6 ^ stringr::str_count(x, "兆|M|吨") *
      1E8 ^ stringr::str_count(x, "亿") *
      1E9 ^ stringr::str_count(x, "吉|G") *
      1E12 ^ stringr::str_count(x, "太|T")

    b <- a ^ if_else(stringr::str_detect(x, "平方"), 2, 1) ^
    if_else(stringr::str_detect(x, "立方"), 3, 1)

    return(b)
  }

  return(value * factor.detect(old.unit) / factor.detect(new.unit))
}

# cat(str_glue("1Gb就是{convert_amount(1,'Gb','Mb')}Mb"))
#
# cat(str_glue("1GJ就是{convert_amount(1,'GJ','万百万千焦')}万百万千焦"))


#' Convert a geo-coding of between common Chinese coordinate systems
#'
#' @param lng num, longitude
#' @param lat num, latitude
#' @param from chr, source coord system, supports "BD09", "GCJ02" and "WGS84"
#' @param to chr, target coord system, supports "BD09", "GCJ02" and "WGS84"
#'
#' @return 2 number of geocoding in the converted coordinate system
#' @export
#'
#' @examples
#' convert_coord(133, 47, from = "GCJ02", to = "BD09")
convert_coord <- function(lng, lat, from, to) {

  if (is.na(lng) | is.na(lat))  return(c(lng = NA, lat = NA))

  else {
    x_pi = pi * 3000.0 / 180.0 #地球弧度
    ee = 0.00669342162296594323 #偏心率平方(克拉索夫斯基椭球)
    a = 6378245.0 #长半轴

    transf_lat <- function(lng, lat) {
      ret = -100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat * lat + 0.1 * lng * lat + 0.2 * sqrt(abs(lng))
      ret = ret + (20.0 * sin(6.0 * lng * pi) + 20.0 * sin(2.0 * lng * pi)) * 2.0 / 3.0
      ret = ret + (20.0 * sin(lat * pi) + 40.0 * sin(lat / 3.0 * pi)) * 2.0 / 3.0
      ret = ret + (160.0 * sin(lat / 12.0 * pi) + 320 * sin(lat * pi / 30.0)) * 2.0 / 3.0
      return(ret)
    }

    transf_lng <- function(lng, lat) {
      ret = 300.0 + lng + 2.0 * lat + 0.1 * lng * lng + 0.1 * lng * lat + 0.1 * sqrt(abs(lng))
      ret = ret + (20.0 * sin(6.0 * lng * pi) + 20.0 * sin(2.0 * lng * pi)) * 2.0 / 3.0
      ret = ret + (20.0 * sin(lng * pi) + 40.0 * sin(lng / 3.0 * pi)) * 2.0 / 3.0
      ret = ret + (150.0 * sin(lng / 12.0 * pi) + 300.0 * sin(lng / 30.0 * pi)) * 2.0 / 3.0
      return(ret)
    }

    is.inside_CN <- function(lng, lat) {
      if (lng < 73.66 | lng > 135.05 | lat < 3.86 | lat > 53.55) return(F)
      else return(T)
    }

    gcj02_to_wgs84 <- function(lng, lat) {
      if (!is.inside_CN(lng, lat)) return(c(lng = lng, lat = lat))
      else {
        dlat = transf_lat(lng - 105.0, lat - 35.0)
        dlng = transf_lng(lng - 105.0, lat - 35.0)
        radlat = lat / 180.0 * pi
        magic = 1 - ee * (sin(radlat)) ^ 2
        sqrtmagic = sqrt(magic)
        dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi)
        dlng = (dlng * 180.0) / (a / sqrtmagic * cos(radlat) * pi)
        mglat = lat + dlat
        mglng = lng + dlng
        return(c(lng = lng * 2 - mglng, lat = lat * 2 - mglat))
      }
    }

    gcj02_to_bd09 <- function(lng, lat) {
      if (!is.inside_CN(lng, lat)) return(c(lng = lng, lat = lat))
      else{
        z = sqrt(lng * lng + lat * lat) + 0.00002 * sin(lat * x_pi)
        theta = atan2(lat, lng) + 0.000003 * cos(lng * x_pi)
        bd_lng = z * cos(theta) + 0.0065
        bd_lat = z * sin(theta) + 0.006
        return(c(lng = bd_lng, lat = bd_lat))
      }
    }

    wgs84_to_gcj02 <- function(lng, lat) {
      if (!is.inside_CN(lng, lat)) return(c(lng = lng, lat = lat))
      else {
        dlat =  transf_lat(lng - 105.0, lat - 35.0)
        dlng =  transf_lng(lng - 105.0, lat - 35.0)
        radlat = lat / 180.0 * pi
        magic = sin(radlat)
        magic = 1 - ee * magic ^ 2
        sqrtmagic = sqrt(magic)
        dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi)
        dlng = (dlng * 180.0) / (a / sqrtmagic * cos(radlat) * pi)
        mglat = lat + dlat
        mglng = lng + dlng
        return(c(lng = mglng, lat = mglat))
      }
    }

    bd09_to_gcj02 <- function(lng, lat) {
      if (!is.inside_CN(lng, lat)) return(c(lng = lng, lat = lat))
      else {
        x = lng - 0.0065
        y = lat - 0.006
        z = sqrt(x ^ 2 + y ^ 2) - 0.00002 * sin(y * x_pi)
        theta = atan2(y, x) - 0.000003 * cos(x * x_pi)
        gg_lng = z * cos(theta)
        gg_lat = z * sin(theta)
        return(data.frame(lng = gg_lng, lat = gg_lat))
      }
    }

    wgs84_to_bd09 <- function(lng, lat) {
      return(do.call(gcj02_to_bd09,as.list(wgs84_to_gcj02(lng, lat))))
    }

    bd09_to_wgs84 <- function(lng, lat) {
      return(do.call(gcj02_to_wgs84, as.list(bd09_to_gcj02(lng, lat))))
    }

    if (toupper(from) == 'GCJ02' & toupper(to) == "WGS84") return(gcj02_to_wgs84(lng, lat))
    else if (toupper(from) == 'GCJ02' & toupper(to) == "BD09") return(gcj02_to_bd09(lng, lat))
    else if (toupper(from) == 'WGS84' & toupper(to) == "GCJ02") return(wgs84_to_gcj02(lng, lat))
    else if (toupper(from) == 'WGS84' & toupper(to) == "BD09") return(wgs84_to_bd09(lng, lat))
    else if (toupper(from) == 'BD09' & toupper(to) == "WGS84") return(bd09_to_wgs84(lng, lat))
    else if (toupper(from) == 'BD09' & toupper(to) == "GCJ02") return(bd09_to_gcj02(lng, lat))
    else cat("Please Check the name of the coordinates! 请检查所输入的坐标系名称！")
  }

}

