#' Call ffmpeg in shell to compress video
#'
#' @param video video path, full path.
#' @param resolution portrait video picture size, i.e., 480, 720, 1080, 1440, 2160.
#' @param bit_rate bit rate, unit:k.
#' @param encoder video encoder, by default `hevc_nvenc` for nvidia GPU. alternative `hevc_amf` for AMD GPU. `libx264` for CPU encoding only.
#' @param extra extra option pass to ffmpeg.
#' @importFrom stringr str_extract
#'
#' @return status for compile.
#' @export
#'
#' @examples
#' ffmpeg_video.compress("path/to/your/video")
ffmpeg_video.compress <- function(video, resolution = 720, bit_rate = 2000, encoder = "hevc_nvenc", extra = "") {

  filenm <- get_fname(video)

  dirnm <- dirname(video)

  file_ext <- str_extract(video, "(?<=\\.)[^\\.]+$")

  str_glue("ffmpeg -i \"{video}\" -vf scale=-1:{resolution} -b:v {bit_rate}k -c:v {encoder} {extra} \\
           \"{dirnm}/{filenm}[{resolution}P][{bit_rate}k].{file_ext}\"") |> system()
}
