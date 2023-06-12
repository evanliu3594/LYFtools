#' Call ffmpeg in shell to compress video
#'
#' @param video video path, full path.
#' @param res resolution, numeric. especially portrait video picture size, i.e., 480, 720, 1080, 1440, 2160.
#' By default NULL for not changing bit rate.
#' @param bv video bit rate, unit: kb. By default NULL for not changing bit rate.
#' @param cv video encoder, by default `hevc_nvenc` for nvidia GPU hwa. alternative `hevc_amf` for AMD GPU hwa.
#' `libx264` for CPU encoding only.
#' @param force_format Output file format, chr. By default NULL for keeping file format as input file.
#' @param extra extra option pass to ffmpeg.
#'
#' @importFrom stringr str_extract
#' @importFrom jsonlite fromJSON
#'
#' @return status for compile.
#' @export
#'
#' @examples
#' ffmpeg_video.compress("path/to/your/video")
ffmpeg_video.compress <- function(video, res = NULL, bv = NULL, force_format = NULL, cv = "hevc_nvenc", extra = "") {

  input_res <- str_glue(
      "ffprobe \"{video}\" -v quiet -select_streams v:0 -show_entries stream=width,height -of json"
    ) %>% system(intern = T) %>% fromJSON() %>% .$stream %>% c()

  fnm <- get_fname(video)

  dnm <- dirname(video)

  cmd_res_str <- if (is.null(res)) "" else str_glue("-vf scale=-1:{res}")

  cmd_bv_str <- if (is.null(bv)) "" else str_glue("-b:v {bv}k")

  cmd_cv_str <- str_glue("-c:v {cv}")

  fnm_res_str <- if (is.null(res)) {
    str_glue("[{input_res$width}x{input_res$height}]")
  } else {
    str_glue("[{as.integer(input_res$width * res / input_res$height)}x{res}]")
  }

  fnm_bv_str <- if (is.null(bv)) "" else str_glue("[{bv}k]")

  fnm_ext <- if (is.null(force_format)) str_extract(video, "(?<=\\.)[^\\.]+$") else force_format

  str_glue("ffmpeg -i \"{video}\" {cmd_res_str} {cmd_bv_str} {cmd_cv_str} {extra} \\
           \"{dnm}/{fnm}{fnm_res_str}{fnm_bv_str}.{fnm_ext}\"") |> system()
}
