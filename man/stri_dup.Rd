\name{stri_dup}
\alias{stri_dup}
\title{Duplicate Strings}
\usage{
stri_dup(str, times)
}
\arguments{
  \item{str}{character vector of strings to be duplicated}

  \item{times}{integer vector with the numbers of times to
  duplicate each string}
}
\value{
Returns a character vector.
}
\description{
Duplicates each string \code{times} times. This is done by
copying the contents of \code{str} at the end of
\code{str}.
}
\details{
Vectorized over \code{str} and \code{times}.
}
\examples{
stri_dup("a", 1:5)
stri_dup(c("a", NA, "ba"), 4)
stri_dup(c("abc", "pqrst"), c(4, 2))
}
\seealso{
Other join: \code{\link{stri_c}}, \code{\link{stri_join}},
\code{\link{stri_paste}}; \code{\link{stri_flatten}}
}

