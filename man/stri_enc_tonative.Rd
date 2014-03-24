\name{stri_enc_tonative}
\alias{stri_enc_tonative}
\title{Convert To Native Encoding}
\usage{
stri_enc_tonative(str)
}
\arguments{
  \item{str}{character vector to be converted}
}
\value{
Returns a character vector.
}
\description{
Converts character strings with declared encodings to
Native encoding.
}
\details{
Current native encoding can be read with
\code{\link{stri_enc_get}}. Character strings declared to
be in \code{bytes} encoding will fail here.
}
\seealso{
Other encoding_conversion: \code{\link{stri_conv}},
\code{\link{stri_encode}};
\code{\link{stri_enc_fromutf32}};
\code{\link{stri_enc_toascii}};
\code{\link{stri_enc_toutf32}};
\code{\link{stri_enc_toutf8}};
\code{\link{stringi-encoding}}
}

