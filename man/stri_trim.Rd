\name{stri_trim_both}
\alias{stri_trim}
\alias{stri_trim_both}
\alias{stri_trim_left}
\alias{stri_trim_right}
\title{Trim Characters from the Left and/or Right Side of a String}
\usage{
stri_trim_both(str, pattern = "^WHITE_SPACE")

stri_trim_left(str, pattern = "^WHITE_SPACE")

stri_trim_right(str, pattern = "^WHITE_SPACE")

stri_trim(str, side = c("both", "left", "right"), pattern = "^WHITE_SPACE")
}
\arguments{
  \item{str}{character vector}

  \item{pattern}{character vector with character class
  identifiers that should be preserved, see
  \link{stringi-search-charclass}, defaults
  `\code{^WHITE_SPACE}`}

  \item{side}{character [\code{stri_trim} only]; defaults
  to \code{"both"}}
}
\value{
All these functions return a character vector.
}
\description{
These functions may be used e.g. to get rid of unnecessary
whitespaces from strings. Trimming ends at the first or
starts at the last \code{pattern} match.
}
\details{
Vectorized over \code{str} and \code{pattern}.

\code{stri_trim} is a convenience function, which
dispatches control to \code{stri_trim_*}. Unless you are
very lazy, do not use it: it is slower.

Contrary to many other string processing libraries, our
trimming functions are quite general. A character class,
given by \code{pattern}, may be adjusted to suit your needs
(most often you will use the default value or a negation of
some character class, i.e. with \code{^} at the beginning).

With these functions you may very quickly extract data,
which in some cases require using regular expressions. E.g.
you may get \code{"23.5"} out of \code{"total of 23.5
bitcoins"}.

For trimming whitespaces, please note the difference
between Unicode binary property `\code{WHITE_SPACE}` (more
general) and general character category `\code{Z}`, see
\link{stringi-search-charclass}
}
\examples{
stri_trim_left("               aaa")
stri_trim_right("rexamine.com/", "^P")
stri_trim_both(" Total of 23.5 bitcoins. ", "N")
stri_trim_both(" Total of 23.5 bitcoins. ", "L")
}
\seealso{
Other search_charclass: \code{\link{stri_count_charclass}};
\code{\link{stri_detect_charclass}};
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_last_charclass}},
\code{\link{stri_extract_last_charclass}};
\code{\link{stri_locate_all_charclass}},
\code{\link{stri_locate_all_charclass}},
\code{\link{stri_locate_first_charclass}},
\code{\link{stri_locate_first_charclass}},
\code{\link{stri_locate_last_charclass}},
\code{\link{stri_locate_last_charclass}};
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_last_charclass}},
\code{\link{stri_replace_last_charclass}};
\code{\link{stri_split_charclass}},
\code{\link{stri_split_charclass}};
\code{\link{stringi-search-charclass}};
\code{\link{stringi-search}}
}

