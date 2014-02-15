\name{stri_replace_all_charclass}
\alias{stri_replace_all_charclass}
\alias{stri_replace_first_charclass}
\alias{stri_replace_last_charclass}
\title{Replace Occurrences of a Character Class}
\usage{
stri_replace_all_charclass(str, pattern, replacement)

stri_replace_first_charclass(str, pattern, replacement)

stri_replace_last_charclass(str, pattern, replacement)
}
\arguments{
  \item{str}{character vector with strings to search in}

  \item{pattern}{character vector; identifiers of character
  classes, see \link{stringi-search-charclass}}

  \item{replacement}{character vector of strings to replace
  with}
}
\value{
character vector
}
\description{
Replaces with the given replacement string every/first/last
character class occurrence in the input string.
}
\details{
Vectorized over \code{str}, \code{pattern}, and
\code{replacement}.

These functions scan the input string for matches of a
character class. Input that is not part of any match is
left unchanged; each match is replaced in the result by the
same (fixed) replacement string.
}
\examples{
stri_replace_all_charclass("a\\nb\\tc d", "WHITE_SPACE", " ")
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
\code{\link{stri_split_charclass}},
\code{\link{stri_split_charclass}};
\code{\link{stri_trim}}, \code{\link{stri_trim}},
\code{\link{stri_trim_both}}, \code{\link{stri_trim_left}},
\code{\link{stri_trim_right}};
\code{\link{stringi-search-charclass}};
\code{\link{stringi-search}}

Other search_replace: \code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_last_fixed}},
\code{\link{stri_replace_last_fixed}};
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_last_regex}},
\code{\link{stri_replace_last_regex}};
\code{\link{stri_replace_all}};
\code{\link{stri_replace_first}};
\code{\link{stri_replace_last}};
\code{\link{stri_replace}}; \code{\link{stringi-search}}
}

