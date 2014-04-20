\name{stri_pad}
\alias{stri_pad}
\title{Pad a String}
\usage{
stri_pad(str, min_length = max(stri_length(str)), side = "left",
  pad = " ")
}
\arguments{
  \item{str}{character vector}

  \item{min_length}{integer vector giving minimal output
  string lengths}

  \item{side}{character vector; sides on which padding
  character is added (\code{left}, \code{right}, or
  \code{both})}

  \item{pad}{character vector giving padding code points}
}
\value{
Returns a character vector.
}
\description{
Adds \code{pad} characters at the given \code{side} of each
string so that each output string consists of at least
\code{min_length} code points.
}
\details{
Vectorized over \code{str}, \code{min_length}, \code{side},
and \code{pad}. Each string in \code{pad} should consist of
exactly one code point.

Note that Unicode code points may have different widths
when printed on screen. This function acts like each code
point is of width 1.
}
\examples{
stri_pad("stringi", 10, pad="#")
stri_pad("stringi", 5:9, "right", pad="$")
stri_pad(1, 3, pad=LETTERS)
}
\seealso{
Other whitespaces: \code{\link{stri_trim}},
\code{\link{stri_trim}}, \code{\link{stri_trim_both}},
\code{\link{stri_trim_left}}, \code{\link{stri_trim_right}}
}

