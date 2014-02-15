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
Converts input strings to ASCII, i.e. to strings with all
codes <= 127.
}
\details{
All charcodes > 127 are replaced with ASCII SUBSTITUTE
CHARACTER (0x1A). \R encoding marking is always used, to
determine whether an 8-bit encoding or rather UTF-8 is used
on input.

Bytes-marked strings are treated as 8-bit strings.

The SUBSTITUTE CHARACTER (\code{\\x1a == \\032}) may be
interpreted as ASCII missing value for single characters.
}
\seealso{
Other encoding_conversion: \code{\link{stri_conv}},
\code{\link{stri_encode}};
\code{\link{stri_enc_fromutf32}};
\code{\link{stri_enc_toutf32}};
\code{\link{stri_enc_toutf8}};
\code{\link{stringi-encoding}}
}

