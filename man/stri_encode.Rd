\name{stri_encode}
\alias{stri_conv}
\alias{stri_encode}
\title{Convert Strings Between Given Encodings}
\usage{
stri_encode(str, from = NULL, to = NULL, to_raw = FALSE)

stri_conv(str, from = NULL, to = NULL, to_raw = FALSE)
}
\arguments{
  \item{str}{character vector, a raw vector, or a list of
  \code{raw} vectors to be converted}

  \item{from}{input encoding: \code{NULL} or \code{""} for
  default encoding or internal encoding marks usage (see
  Details); otherwise, a single string with encoding name,
  see \code{\link{stri_enc_list}}}

  \item{to}{target encoding: \code{NULL} or \code{""} for
  default encoding (see \code{\link{stri_enc_get}}), or a
  single string with encoding name}

  \item{to_raw}{single logical value; indicates whether a
  list of raw vectors shall be returned rather than a
  character vector}
}
\value{
If \code{to_raw} is \code{FALSE}, then a character vector
with encoded strings (and sensible encoding marks) is
returned. Otherwise, you get a list of raw vectors.
}
\description{
These functions convert a character vector between
encodings.
}
\details{
These two functions aim to replace \R's \link{iconv} --
note only it is slightly faster, and works in the same
manner on all platforms. \code{stri_conv} is an alias for
\code{stri_encode}.

Please, refer to \code{\link{stri_enc_list}} for the list
of supported encodings and \link{stringi-encoding} for
general discussion.

If \code{from} is either missing, \code{""}, or \code{NULL}
and \code{str} is an atomic vector, then the input strings'
encoding marks are used (just like in almost all
\pkg{stringi} functions: bytes marks are disallowed). In
other words, the input string will be converted from ASCII,
UTF-8, or current default encoding, see
\code{\link{stri_enc_get}}. Otherwise, the internal
encoding marks are overridden by the given encoding. On the
other hand, for \code{str} being a list of raw vectors, we
assume that the input encoding is the current default
encoding.

For \code{to_raw=FALSE}, the output strings always have
marked encodings according to the target converter used (as
specified by \code{to}) and the current default Encoding
(\code{ASCII}, \code{latin1}, \code{UTF-8}, \code{native},
or \code{bytes} in all other cases).

Note that possible problems may occur when \code{to} is set
to e.g. UTF-16 and UTF-32, as the output strings may have
embedded NULs. In such cases use \code{to_raw=TRUE} and
consider specifying a byte order marker (BOM) for
portability reasons (e.g. set \code{UTF-16} or
\code{UTF-32} which automatically adds BOMs).

Note that \code{stri_encode(as.raw(data),
"8bitencodingname")} is a wise substitute for
\code{\link{rawToChar}}.

Currently, if an incorrect code point is found on input, it
is replaced by the default (for that target encoding)
substitute character and a warning is generated.
}
\references{
\emph{Conversion} -- ICU User Guide,
\url{http://userguide.icu-project.org/conversion}

\emph{Converters} -- ICU User Guide,
\url{http://userguide.icu-project.org/conversion/converters}
(technical details)
}
\seealso{
Other encoding_conversion:
\code{\link{stri_enc_fromutf32}};
\code{\link{stri_enc_toascii}};
\code{\link{stri_enc_toutf32}};
\code{\link{stri_enc_toutf8}};
\code{\link{stringi-encoding}}
}

