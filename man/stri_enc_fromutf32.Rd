\name{stri_enc_fromutf32}
\alias{stri_enc_fromutf32}
\title{Convert From UTF-32}
\usage{
stri_enc_fromutf32(vec)
}
\arguments{
  \item{vec}{list of integer vectors or, for convenience, a
  single integer vector}
}
\value{
Returns a character vector (in UTF-8).
}
\description{
This function converts a list of integer vectors,
representing UTF-32 code points, to a character vector.
}
\details{
UTF-32 is a 32bit encoding in which each Unicode code point
corresponds to exactly one integer value.

This functions roughly acts like a vectorized version of
\code{\link{intToUtf8}}, as usual in \pkg{stringi}, it
returns character strings in UTF-8. If you have a list of
raw vectors on input, use \code{\link{stri_encode}}.

Note that \code{0}s are not allowed in \code{vec}, as they
are used to internally mark the end of a string (in the C
API).

If an incorrect code point is given, a warning is generated
and a string is set to \code{NA}.

\code{NULL}s in the input list are converted to
\code{NA_character_}.
}
\seealso{
Other encoding_conversion: \code{\link{stri_conv}},
\code{\link{stri_encode}}; \code{\link{stri_enc_toascii}};
\code{\link{stri_enc_toutf32}};
\code{\link{stri_enc_toutf8}};
\code{\link{stringi-encoding}}
}

