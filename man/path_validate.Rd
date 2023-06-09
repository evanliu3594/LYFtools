% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Get.R
\name{path_validate}
\alias{path_validate}
\title{Check if the path exist, if not, create every dir in the path.}
\usage{
path_validate(path, mode = "manual")
}
\arguments{
\item{path}{A string of file path that you want to use for save a file.
Note that it must direct to a file not a folder.}

\item{mode}{Mode option. now support "force" and "manual" by default.
For "force" mode, the function will directly creating folder(s) to active the path.
For "manual" mode, the function will ask you whether you want to create folders or not.}
}
\value{
the checked `path` same as input
}
\description{
Check if the path exist, if not, create every dir in the path.
}
\examples{
path_validate("~/THE/FILE/PATH/THAT/YOU/WANT/TO/TEST.TXT")
}
