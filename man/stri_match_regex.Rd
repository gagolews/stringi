\name{stri_match_all_regex}
\alias{stri_match_all_regex}
\alias{stri_match_first_regex}
\alias{stri_match_last_regex}
\title{Extract Regex Pattern Matches, Together with Capture Groups}
\usage{
stri_match_all_regex(str, pattern, opts_regex = list())

stri_match_first_regex(str, pattern, opts_regex = list())

stri_match_last_regex(str, pattern, opts_regex = list())
}
\arguments{
  \item{str}{character vector of strings to search in}

  \item{pattern}{character vector of regular expressions to
  search for}

  \item{opts_regex}{a named list as generated with
  \code{\link{stri_opts_regex}}}
}
\value{
For \code{stri_match_all_regex}, a list of character
matrices is returned. Otherwise, a character matrix is
given. \code{NA} if not found or if given capture group is
unavailable.

The first column gives the whole match. The second one
corresponds to the first capture group, the third -- the
second capture group, and so on.
}
\description{
These functions extract substrings of \code{str} that match
a given \code{pattern}, and also give matches for capture
groups, i.e. subpatterns given in round parentheses.
}
\details{
Vectorized over \code{str} and \code{pattern}.
}
\seealso{
Other search_match: \code{\link{stri_match_all}};
\code{\link{stri_match_first}};
\code{\link{stri_match_last}}; \code{\link{stri_match}};
\code{\link{stringi-search}}

Other search_regex: \code{\link{stri_count_regex}};
\code{\link{stri_detect_regex}};
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

