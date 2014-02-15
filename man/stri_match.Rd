\name{stri_match}
\alias{stri_match}
\title{Extract Regex Pattern Matches, Together with Capture Groups}
\usage{
stri_match(str, ..., regex, mode = c("first", "all", "last"))
}
\arguments{
  \item{str}{character vector of strings to search in}

  \item{...}{additional arguments passed to the underlying
  functions}

  \item{regex}{character vector of regular expressions to
  search for}

  \item{mode}{single string; whether to look for all, or
  only the first/last occurrence of the pattern}
}
\value{
same as the underlying functions called, i.e. a character
matrix or a list of character matrices.
}
\description{
A dummy function for compatibility with other search
routines in \pkg{stringi}. Calls either
\code{\link{stri_match_all}},
\code{\link{stri_match_first}}, or
\code{\link{stri_match_last}}, depending on the argument
used. Note that this is slower than the direct call.
}
\seealso{
Other search_match: \code{\link{stri_match_all_regex}},
\code{\link{stri_match_all_regex}},
\code{\link{stri_match_first_regex}},
\code{\link{stri_match_first_regex}},
\code{\link{stri_match_last_regex}},
\code{\link{stri_match_last_regex}};
\code{\link{stri_match_all}};
\code{\link{stri_match_first}};
\code{\link{stri_match_last}}; \code{\link{stringi-search}}
}

