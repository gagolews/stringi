\name{stri_detect}
\alias{stri_detect}
\title{Detect a Pattern Match}
\usage{
stri_detect(str, ..., regex, fixed, charclass)
}
\arguments{
  \item{str}{character vector of strings to search in}

  \item{...}{additional arguments passed to the underlying
  functions}

  \item{regex}{character vector; regular expressions}

  \item{fixed}{character vector; fixed patterns}

  \item{charclass}{character vector; identifiers of
  character classes}
}
\value{
Returns a logical vector.
}
\description{
Detect a Pattern Match
}
\details{
A convenience function. Calls either
\code{\link{stri_detect_regex}},
\code{\link{stri_detect_fixed}}, or
\code{\link{stri_detect_charclass}}, depending on the
argument used.
}
\seealso{
Other search_detect: \code{\link{stri_detect_charclass}};
\code{\link{stri_detect_fixed}};
\code{\link{stri_detect_regex}};
\code{\link{stringi-search}}
}

