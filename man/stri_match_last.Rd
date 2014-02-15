\name{stri_match_last}
\alias{stri_match_last}
\title{Extract Last Regex Pattern Matches, Together with Capture Groups}
\usage{
stri_match_last(str, ..., regex)
}
\arguments{
  \item{str}{character vector of strings to search in}

  \item{...}{additional arguments passed to the underlying
  function}

  \item{regex}{character vector of regular expressions to
  search for}
}
\value{
character matrix
}
\description{
A dummy function for compatibility with other search
routines in \pkg{stringi}. Calls
\code{\link{stri_match_last_regex}}.
}
\seealso{
Other search_match: \code{\link{stri_match_all_regex}},
\code{\link{stri_match_all_regex}},
\code{\link{stri_match_first_regex}},
\code{\link{stri_match_first_regex}},
\code{\link{stri_match_last_regex}},
\code{\link{stri_match_last_regex}};
\code{\link{stri_match_all}};
\code{\link{stri_match_first}}; \code{\link{stri_match}};
\code{\link{stringi-search}}
}

