\name{stri_extract}
\alias{stri_extract}
\title{Extract Pattern Matches}
\usage{
stri_extract(str, ..., regex, fixed, charclass, mode = c("first", "all",
  "last"))
}
\arguments{
  \item{str}{character vector of strings to search in}

  \item{...}{additional arguments passed to the underlying
  functions}

  \item{regex}{character vector; regular expressions}

  \item{fixed}{character vector; fixed patterns}

  \item{charclass}{character vector; identifiers of
  character classes}

  \item{mode}{single string; whether to look for all, or
  only the first/last occurrence of the pattern}
}
\value{
The return value is the same as the underlying functions
called, i.e. a character vector or a list of character
vectors.
}
\description{
A convenience function. Calls either
\code{\link{stri_extract_all}},
\code{\link{stri_extract_first}}, or
\code{\link{stri_extract_last}}, depending on the argument
used. Note that this is slower than the direct call.
}
\details{
Unless you are very lazy, please call the underlying
functions directly for better performance.
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
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_last_regex}},
\code{\link{stri_extract_last_regex}};
\code{\link{stri_extract_all}};
\code{\link{stri_extract_first}};
\code{\link{stri_extract_last}};
\code{\link{stringi-search}}
}

