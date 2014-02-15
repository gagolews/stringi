\name{stri_extract_all_charclass}
\alias{stri_extract_all_charclass}
\alias{stri_extract_first_charclass}
\alias{stri_extract_last_charclass}
\title{Extract Character Class Matches}
\usage{
stri_extract_all_charclass(str, pattern, merge = TRUE)

stri_extract_first_charclass(str, pattern)

stri_extract_last_charclass(str, pattern)
}
\arguments{
  \item{str}{character vector to search in}

  \item{pattern}{character vector; identifiers of character
  classes, see \link{stringi-search-charclass}}

  \item{merge}{logical [\code{stri_extract_all_charclass}
  only]; should consecutive matches be merged into one
  string?}
}
\value{
For \code{stri_extract_all_charclass}, a list of
\code{max(length(str), length(pattern), length(merge))}
character vectors is returned. Otherwise, you get a
character vector. \code{NA} if not found.
}
\description{
These functions extract substrings of \code{str} that match
a given \code{pattern}.

Generally, this is the way to extract single characters,
only. Longer substrings, however, may be extracted, with
the \code{stri_extract_all_charclass} function and
\code{merge=TRUE}.
}
\details{
Vectorized over \code{str}, \code{pattern}, and
\code{merge}.
}
\examples{
stri_extract_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), 'Ll')
stri_extract_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), 'Ll', merge=FALSE)
stri_extract_first_charclass('AaBbCc', 'Ll')
stri_extract_last_charclass('AaBbCc', 'Ll')
}
\seealso{
Other search_charclass: \code{\link{stri_count_charclass}};
\code{\link{stri_detect_charclass}};
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

Other search_extract: \code{\link{stri_extract_all_fixed}},
\code{\link{stri_extract_all_fixed,}},
\code{\link{stri_extract_first_fixed}},
\code{\link{stri_extract_first_fixed,}},
\code{\link{stri_extract_last_fixed}},
\code{\link{stri_extract_last_fixed}};
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_last_regex}},
\code{\link{stri_extract_last_regex}};
\code{\link{stri_extract_all}};
\code{\link{stri_extract_first}};
\code{\link{stri_extract_last}};
\code{\link{stri_extract}}; \code{\link{stringi-search}}
}

