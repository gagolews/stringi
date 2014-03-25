\name{stri_enc_toutf8}
\alias{stri_enc_toutf8}
\title{Convert Strings To UTF-8}
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
Converts character strings with declared marked encodings
to UTF-8 strings.
}
\details{
If \code{is_unknown_8bit} is set to \code{FALSE} (the
default), then R encoding marks are used, see
\code{\link{stri_enc_mark}}. Bytes-marked strings will
cause the function to fail.

If a string is in UTF-8 and has a byte order mark (BOM),
then BOM will be silently removed from the output string.

If default encoding is UTF-8, see
\code{\link{stri_enc_get}}, then strings marked with
\code{native} are -- for efficiency reasons -- returned
as-is, i.e. with unchanged markings. A similar behavior is
observed when calling \code{\link{enc2utf8}}.

For \code{is_unknown_8bit == TRUE}, if a string is declared
to be neither in ASCII nor in UTF-8, then all bytecodes >
127 are replaced with the Unicode REPLACEMENT CHARACTER
(\\Ufffd). Note that the REPLACEMENT CHARACTER may be
interpreted as Unicode missing value for single characters.
Here, a \code{bytes}-marked string is assumed to be encoded
by an 8-bit encoding such that it has ASCII as its subset.
}
\seealso{
Other encoding_conversion: \code{\link{stri_conv}},
\code{\link{stri_encode}};
\code{\link{stri_enc_fromutf32}};
\code{\link{stri_enc_toascii}};
\code{\link{stri_enc_tonative}};
\code{\link{stri_enc_toutf32}};
\code{\link{stringi-encoding}}
}

