\name{stri_enc_toascii}
\alias{stri_enc_toascii}
\title{Convert To ASCII}
\usage{
stri_enc_toascii(str)
}
\arguments{
  \item{str}{character vector to be converted}
}
\value{
Returns a character vector.
}
\description{
This function converts input strings to ASCII, i.e. to
character strings consisting of bytes not greater than 127.
}
\details{
All charcodes > 127 are replaced with ASCII SUBSTITUTE
CHARACTER (0x1A). \R encoding declarations are always used
to determine which encoding is assumed for each input, see
\code{\link{stri_enc_mark}}.

A \code{bytes}-marked string is assumed to be encoded by an
8-bit encoding such that it has ASCII as its subset.

Note that the SUBSTITUTE CHARACTER (\code{\\x1a == \\032})
may be interpreted as ASCII missing value for single
characters.
}
\seealso{
Other encoding_conversion: \code{\link{stri_conv}},
\code{\link{stri_encode}};
\code{\link{stri_enc_fromutf32}};
\code{\link{stri_enc_tonative}};
\code{\link{stri_enc_toutf32}};
\code{\link{stri_enc_toutf8}};
\code{\link{stringi-encoding}}
}

