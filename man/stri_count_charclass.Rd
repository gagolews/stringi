\name{stri_count_charclass}
\alias{stri_count_charclass}
\title{Count the Number of Character Class Matches}
\usage{
stri_count_charclass(str, pattern)
}
\arguments{
  \item{str}{character vector to search in}

  \item{pattern}{character vector; identifiers of character
  classes, see \link{stringi-search-charclass}}
}
\value{
Returns an integer vector.
}
\description{
This function counts the number of characters that falls
into a given character class (e.g. letters, digits, or
white spaces).
}
\details{
Vectorized over \code{str} and \code{pattern}.
}
\examples{
stri_count_charclass(c("stRRRingi","REXAMINE","123"), c("Ll", "Lu", "Zs"))
stri_count_charclass(" \\t\\n", "WHITE_SPACE") # white space - binary property
stri_count_charclass(" \\t\\n", "Z") # whitespace - general category (note the difference)
}
\seealso{
Other search_charclass:
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
\code{\link{stri_trim}}, \code{\link{stri_trim}},
\code{\link{stri_trim_both}}, \code{\link{stri_trim_left}},
\code{\link{stri_trim_right}};
\code{\link{stringi-search-charclass}};
\code{\link{stringi-search}}

Other search_count: \code{\link{stri_count_fixed}};
\code{\link{stri_count_regex}}; \code{\link{stri_count}};
\code{\link{stringi-search}}
}

