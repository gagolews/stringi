\name{stri_unescape_unicode}
\alias{stri_unescape_unicode}
\title{Unscape All Escape Sequences}
\usage{
stri_unescape_unicode(str)
}
\arguments{
  \item{str}{character vector}
}
\value{
Returns a character vector. If an escape sequence is
ill-formed, result will be \code{NA} and a warning will be
given.
}
\description{
Unscapes all known escape sequences
}
\details{
Uses \pkg{ICU} facilities to unescape Unicode character
sequences.

The following ASCII standard escapes are recognized:
\code{\\a}, \code{\\b}, \code{\\t}, \code{\\n}, \code{\\v},
\code{\\?}, \code{\\e}, \code{\\f}, \code{\\r}, \code{\"},
\code{\'}, \code{\\\\}.

Moreover, the function understands the following ones:
\code{\\uXXXX} (4 hex digits), \code{\\UXXXXXXXX} (8 hex
digits), \code{\\xXX} (1-2 hex digits), \code{\\ooo} (1-3
octal digits), \code{\\cX} (control-X; X is masked with
0x1F). For \code{\\xXX} and \code{\\ooo} beware of
non-valid UTF8 byte sequences.

Note that some versions of \R on Windows cannot handle
characters defined with {\\UXXXXXXXX}. We are working on
that.
}
\seealso{
Other escape: \code{\link{stri_escape_unicode}}
}

