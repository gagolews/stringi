\name{stri_split}
\alias{stri_split}
\title{Split a String Into Fields}
\usage{
stri_split(str, ..., regex, fixed, charclass)
}
\arguments{
  \item{str}{character vector of strings to be split}

  \item{...}{additional arguments passed to the underlying
  functions}

  \item{regex}{character vector; regular expressions}

  \item{fixed}{character vector; fixed patterns}

  \item{charclass}{character vector; identifiers of
  character classes}
}
\value{
Returns a list of character vectors.
}
\description{
A convenience function. Calls either
\code{\link{stri_split_regex}},
\code{\link{stri_split_fixed}}, or
\code{\link{stri_split_charclass}}, depending on the
argument used.

Unless you are a very lazy person, please call the
underlying functions directly for better performance.
}
\seealso{
Other search_split: \code{\link{stri_split_charclass}},
\code{\link{stri_split_charclass}};
\code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stri_split_lines}},
\code{\link{stri_split_lines}},
\code{\link{stri_split_lines1}},
\code{\link{stri_split_lines1}};
\code{\link{stri_split_regex}},
\code{\link{stri_split_regex}};
\code{\link{stringi-search}}
}

