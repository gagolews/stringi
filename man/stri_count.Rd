\name{stri_count}
\alias{stri_count}
\title{Count the Number of Pattern Matches in a String}
\usage{
stri_count(str, ..., regex, fixed, charclass)
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
Returns an integer vector.
}
\description{
A convenience function. Calls either
\code{\link{stri_count_regex}},
\code{\link{stri_count_fixed}}, or
\code{\link{stri_count_charclass}}, depending on the
argument used.
}
\details{
Unless you are very lazy, please call the underlying
functions directly for better performance.
}
\examples{
\dontrun{
s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
stri_count(s, fixed=letters)
stri_count(s, regex="[[:alpha:]]")
}
}
\seealso{
Other search_count: \code{\link{stri_count_charclass}};
\code{\link{stri_count_fixed}};
\code{\link{stri_count_regex}};
\code{\link{stringi-search}}
}

