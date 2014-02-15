\name{stri_detect_charclass}
\alias{stri_detect_charclass}
\title{Detect a Character Class Match}
\usage{
stri_detect_charclass(str, pattern)
}
\arguments{
  \item{str}{character vector to search in}

  \item{pattern}{character vector; identifiers of character
  classes, see \link{stringi-search-charclass}}
}
\value{
Returns a logical vector.
}
\description{
This function checks if any character matches a falls into
a given character class (e.g. letters, digits, or white
spaces).
}
\details{
Vectorized over \code{str} and \code{pattern}.
}
\examples{
stri_detect_charclass(c("stRRRingi","REXAMINE","123"), c("Ll", "Lu", "Zs"))
}
\seealso{
Other search_charclass: \code{\link{stri_count_charclass}};
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

Other search_detect: \code{\link{stri_detect_fixed}};
\code{\link{stri_detect_regex}}; \code{\link{stri_detect}};
\code{\link{stringi-search}}
}

