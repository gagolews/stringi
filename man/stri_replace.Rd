\name{stri_replace}
\alias{stri_replace}
\title{Replace Occurrences of a Pattern}
\usage{
stri_replace(str, replacement, ..., regex, fixed, charclass, mode = c("first",
  "all", "last"))
}
\arguments{
  \item{str}{character vector of strings to search in}

  \item{...}{additional arguments passed to the underlying
  functions}

  \item{regex}{character vector; regular expressions}

  \item{fixed}{character vector; fixed patterns}

  \item{charclass}{character vector; identifiers of
  character classes}

  \item{mode}{string; whether to look for all, or only the
  first/last occurrence of the pattern}

  \item{replacement}{character vector of strings to replace
  with}
}
\value{
character vector
}
\description{
A convenience function. Calls either
\code{\link{stri_replace_all}},
\code{\link{stri_replace_first}}, or
\code{\link{stri_replace_last}}, depending on the argument
used.
}
\details{
Note that this is slower than the direct call.
}
\seealso{
Other search_replace:
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_last_charclass}},
\code{\link{stri_replace_last_charclass}};
\code{\link{stri_replace_all_fixed}},
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
\code{\link{stringi-search}}
}

