\name{stri_detect_regex}
\alias{stri_detect_regex}
\title{Detect a Regex Pattern Match}
\usage{
stri_detect_regex(str, pattern, opts_regex = list())
}
\arguments{
  \item{str}{character vector of strings to search in}

  \item{pattern}{character vector of regular expressions}

  \item{opts_regex}{a named list as generated with
  \code{\link{stri_opts_regex}}}
}
\value{
Returns a logical vector.
}
\description{
This function checks if there is at least one match to a
regex pattern in a string.
}
\details{
Unless you are very lazy, please call the underlying
functions directly for better performance.

Vectorized over \code{str} and \code{pattern}.

If \code{pattern} is empty, then the result is \code{NA}
and a warning is generated.
}
\examples{
\dontrun{
stri_detect_regex(c("stringi w R","REXAMINE","123"), 'R.')
stri_detect_regex(c("stringi w R","REXAMINE","123"), '[[:alpha:]]*?')
stri_detect_regex(c("stringi w R","REXAMINE","123"), '[a-zC1]')
stri_detect_regex(c("stringi w R","REXAMINE","123"), '( R|RE)')
stri_detect_regex("stringi", "STRING.", opts_regex=stri_opts_regex(case_insensitive=TRUE))
}
}
\seealso{
Other search_detect: \code{\link{stri_detect_charclass}};
\code{\link{stri_detect_fixed}}; \code{\link{stri_detect}};
\code{\link{stringi-search}}

Other search_regex: \code{\link{stri_count_regex}};
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_last_regex}},
\code{\link{stri_extract_last_regex}};
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_last_regex}},
\code{\link{stri_locate_last_regex}};
\code{\link{stri_match_all_regex}},
\code{\link{stri_match_all_regex}},
\code{\link{stri_match_first_regex}},
\code{\link{stri_match_first_regex}},
\code{\link{stri_match_last_regex}},
\code{\link{stri_match_last_regex}};
\code{\link{stri_opts_regex}};
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_last_regex}},
\code{\link{stri_replace_last_regex}};
\code{\link{stri_split_regex}},
\code{\link{stri_split_regex}};
\code{\link{stringi-search-regex}};
\code{\link{stringi-search}}
}

