\name{stri_escape_unicode}
\alias{stri_escape_unicode}
\title{Escape Unicode Code Points}
\usage{
stri_escape_unicode(str)
}
\arguments{
  \item{str}{character vector}
}
\value{
Returns a character vector.
}
\description{
Escapes all Unicode (not ASCII-printable) code points.
}
\details{
For non-printable and certain special (well-known, see also
\R man page \link{Quotes}) ASCII characters the following
(also recognized in \R) convention is used. We get
\code{\\a}, \code{\\b}, \code{\\t}, \code{\\n}, \code{\\v},
\code{\\f}, \code{\\r}, \code{\"}, \code{\'}, \code{\\\\}
or either {\\uXXXX} (4 hex digits) or {\\UXXXXXXXX} (8 hex
digits) otherwise.

As usual, any input string is converted to Unicode before
executing the escape process.
}
\seealso{
Other escape: \code{\link{stri_unescape_unicode}}
}

