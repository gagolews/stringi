\name{stri_extract_all_regex}
\alias{stri_extract_all_regex}
\alias{stri_extract_first_regex}
\alias{stri_extract_last_regex}
\title{Extract Regex Pattern Matches}
\usage{
stri_extract_all_regex(str, pattern, opts_regex = list())

stri_extract_first_regex(str, pattern, opts_regex = list())

stri_extract_last_regex(str, pattern, opts_regex = list())
}
\arguments{
  \item{str}{character vector of strings to search in}

  \item{pattern}{character vector of regular expressions}

  \item{opts_regex}{a named list as generated with
  \code{\link{stri_opts_regex}}}
}
\value{
For \code{stri_extract_all_regex}, list of
\code{max(length(str), length(pattern))} character vectors
is returned. Otherwise, you get a character vector.
\code{NA} if not found.
}
\description{
These functions extract substrings of \code{str} that match
a given \code{pattern}.

See also \code{\link{stri_match_all_regex}} for extracting
matches together with regex capture groups.
}
\details{
Vectorized over \code{str} and \code{pattern}.
}
\examples{
\dontrun{
stri_extract_all_regex('XaaaaX', c('\\\\p{Ll}', '\\\\p{Ll}+', '\\\\p{Ll}{2,3}', '\\\\p{Ll}{2,3}?'))
stri_extract_first_regex('XaaaaX', c('\\\\p{Ll}', '\\\\p{Ll}+', '\\\\p{Ll}{2,3}', '\\\\p{Ll}{2,3}?'))
stri_extract_last_regex('XaaaaX', c('\\\\p{Ll}', '\\\\p{Ll}+', '\\\\p{Ll}{2,3}', '\\\\p{Ll}{2,3}?'))
}
}
\seealso{
Other search_extract:
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_last_charclass}},
\code{\link{stri_extract_last_charclass}};
\code{\link{stri_extract_all_fixed}},
\code{\link{stri_extract_all_fixed,}},
\code{\link{stri_extract_first_fixed}},
\code{\link{stri_extract_first_fixed,}},
\code{\link{stri_extract_last_fixed}},
\code{\link{stri_extract_last_fixed}};
\code{\link{stri_extract_all}};
\code{\link{stri_extract_first}};
\code{\link{stri_extract_last}};
\code{\link{stri_extract}}; \code{\link{stringi-search}}

Other search_regex: \code{\link{stri_count_regex}};
\code{\link{stri_detect_regex}};
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

