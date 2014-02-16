\name{stri_join}
\alias{stri_c}
\alias{stri_join}
\alias{stri_paste}
\title{Concatenate Character Vectors}
\usage{
stri_join(..., sep = "", collapse = NULL)

stri_c(..., sep = "", collapse = NULL)

stri_paste(..., sep = "", collapse = NULL)
}
\arguments{
  \item{...}{character vectors which corresponding elements
  should be concatenated}

  \item{sep}{single string; separates terms}

  \item{collapse}{single string; separates the results}
}
\value{
Returns a character vector.
}
\description{
This is the \pkg{stringi}'s equivalents of the built-in
\code{\link{paste}} function.
}
\details{
\code{stri_c} and \code{stri_paste} are aliases for
\code{stri_join}. Use whichever you want, they are
equivalent.

If \code{collapse} is not \code{NULL}, then the result will
be a single string. Otherwise, you will get a character
vector of length equal to the length of the longest
argument.

If any of the arguments in `\code{...}` is a vector of
length 0 (not to be confused with vectors of empty
strings), then you will get a 0-length character vector in
result.

If \code{collapse} or \code{sep} has length > 1, then only
first string will be used.

In case of any \code{NA}, \code{NA} is set to the
corresponding element.
}
\examples{
stri_join(1:13, letters)
stri_join(c('abc','123','\\u0105\\u0104'),'###', 1:5, sep='...')
stri_join(c('abc','123','\\u0105\\u0104'),'###', 1:5, sep='...', collapse='?')
}
\seealso{
Other join: \code{\link{stri_dup}};
\code{\link{stri_flatten}}
}

