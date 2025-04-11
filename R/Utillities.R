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

  if (!dir.exists(path)) dir.create(path, recursive = T)

  return(paste("dir. path validated:", path))

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
#' \dontrun{
#'   video.compress("path/to/your/video")
#' }
#'
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


#' Title JOIN by LLMs
#' Generate prompt to do fuzzy join with LLMs. By far(2025/04/10), DeepSeek R1 showed the best result,
#' other LLMs might fabricate non-existing data in the result.
#' @param tb1 `data.frame`, left data.frame
#' @param tb2 `data.frame`, right data.frame
#' @param key1 key column in the left data.frame
#' @param key2 key column in the right data.frame
#'
#' @returns prompt that used to tell the LLMs
#' @importFrom stringr str_glue
#' @importFrom tidyr unite
#' @export
#'
#' @examples#' # run in Rstudio script panel:
#' \dontrun{
#'   library(ggplot2)
#'   library(maps)
#'   world <- map_data("world")
#'   df <- LifeCycleSavings
#'   df["country"] = rownames(df)
#'   llm_join(world, df, "region","country")
#' }
llm_join <- function(tb1, tb2, key1, key2) {

  tbl_to_md <- function(tbl) {
    header <- paste(names(tbl), collapse = " | ")
    header <- paste0("| ", header, " |")
    rule <- paste(rep("---", length(names(tbl))), collapse = " | ")
    rule <- paste0("| ", rule, " |")
    content <- unite(tbl, "newcol", everything(), sep = " | ") %>% unlist()
    content <- paste0("| ", content, " |")

    paste0(header, "\n", rule, "\n", paste(content, collapse = "\n")) %>% return()
  }

  str_glue(
    "You'll performe a SQL-like JOIN operation for the two provided tables based on \\
    \"{key1}\" column in first table and  \"{key2}\" column in second table.\n\\
    Note that the two columns may not be exact matches or may even in different languages.\n\\
    I COMMAND you matching carefully by the most accurate possible,
    left any unmatched entries be blank,
    and NEVER generate any data that does not exist in the original tables.\n
    The final output must be in CSV format.\n
    Repeat, NEVER generate ANY data that not exist in the tables provided,
    otherwise someone could get hurt for that.
    \n\n
    {tbl_to_md(tb1)}\\
    \n\n
    {tbl_to_md(tb2)}"
  ) %>% return()

}
