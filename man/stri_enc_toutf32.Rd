\name{stri_enc_toutf32}
\alias{stri_enc_toutf32}
\title{Convert Strings To UTF-32}
\usage{
stri_enc_toutf32(str)
}
\arguments{
  \item{str}{character vector to be converted}
}
\value{
Returns a list of integer vectors.
}
\description{
UTF-32 is a 32bit encoding in which each Unicode code point
corresponds to exactly one integer value. This function
converts a character vector to a list of integer vectors.
The individual code points then may easily be manipulated.
}
\details{
\code{NA_character_}s are converted to \code{NULL}.

This function is roughly equivalent to a vectorized call to
\code{utf8ToInt(enc2utf8(str))}. If you want a list of raw
vector on output, use \code{\link{stri_encode}}.
}
\seealso{
Other encoding_conversion: \code{\link{stri_conv}},
\code{\link{stri_encode}};
\code{\link{stri_enc_fromutf32}};
\code{\link{stri_enc_toascii}};
\code{\link{stri_enc_toutf8}};
\code{\link{stringi-encoding}}
}

