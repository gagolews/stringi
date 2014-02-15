\name{stri_enc_toutf8}
\alias{stri_enc_toutf8}
\title{Convert To UTF-8}
\usage{
stri_enc_toutf8(str, is_unknown_8bit = FALSE)
}
\arguments{
  \item{str}{character vector to be converted}

  \item{is_unknown_8bit}{single logical value, see Details}
}
\value{
Returns a character vector.
}
\description{
Converts character strings with (possibly) internally
marked encodings to UTF-8 strings.
}
\details{
If \code{is_unknown_8bit} is set to \code{TRUE} and a
string is marked (internally) as being neither ASCII nor
UTF-8-encoded, then all bytecodes > 127 are replaced with
the Unicode REPLACEMENT CHARACTER (\\Ufffd). Bytes-marked
strings are treated as 8-bit strings.

Otherwise, R encoding marks is assumed to be trustworthy
(ASCII, UTF-8, Latin1, or Native). Bytes encoding fail
here.

Note that the REPLACEMENT CHARACTER may be interpreted as
Unicode \code{NA} value for single characters.
}
\seealso{
Other encoding_conversion: \code{\link{stri_conv}},
\code{\link{stri_encode}};
\code{\link{stri_enc_fromutf32}};
\code{\link{stri_enc_toascii}};
\code{\link{stri_enc_toutf32}};
\code{\link{stringi-encoding}}
}

