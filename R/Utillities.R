#' Check if the path exist, if not, create every dir in the path.
#'
#' @param path A string of file path that you want to use for save a file.
#' @return the checked `path`
#'
#' @export
#'
#' @examples
#' mkdir("~/THE/FILE/PATH/THAT/YOU/WANT/TO/TEST.TXT")
mkdir <- function(path) {

  if (!dir.exists(real_path)) {
    dir.create(real_path, recursive = T)
  }

  return(real_path)

}

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
#' @importFrom stringr str_glue
#'
#' @return status for compile.
#' @export
#'
#' @examples
#' ffmpeg_video.compress("path/to/your/video")
video.compress <- function(video, res = NULL, bv = NULL, force_format = NULL, cv = "hevc_nvenc", extra = "") {

  input_res <- str_glue(
    "ffprobe \"{video}\" -v quiet -select_streams v:0 \\
      -show_entries stream=width,height -of csv"
  ) %>% system(intern = T) %>% strsplit(",") %>% .[[1]] %>% tail(-1) %>%
    as.numeric() %>% setNames(c("width","height")) %>% as.list()

  cmd_res_str <- ifelse(is.null(res), "", str_glue("-vf scale=-1:{res}"))

  cmd_bv_str <- ifelse(is.null(bv), "", str_glue("-b:v {bv}k"))

  cmd_cv_str <- str_glue("-c:v {cv}")

  dnm <- dirname(video)

  fnm <- get_fname(video)

  fnm_res_str <- ifelse(
    is.null(res), str_glue("[{input_res$width}x{input_res$height}]"),
    str_glue("[{as.integer(input_res$width * res / input_res$height)}x{res}]")
  )

  fnm_bv_str <- ifelse(is.null(bv), "", str_glue("[{bv}k]"))

  fnm_ext <- ifelse(!is.null(force_format), force_format, str_extract(video, "(?<=\\.)[^\\.]+$"))

  str_glue("ffmpeg -i \"{video}\" \\{cmd_res_str} {cmd_bv_str} {cmd_cv_str} {extra} \\
           \"{dnm}/{fnm}{fnm_res_str}{fnm_bv_str}.{fnm_ext}\"") |> system()
}

