\name{stri_enc_info}
\alias{stri_enc_info}
\title{Query Given Character Encoding}
\usage{
stri_enc_info(enc = NULL)
}
\arguments{
  \item{enc}{\code{NULL} or \code{""} for default encoding,
  or a single string with encoding name}
}
\value{
Returns a list with the following components: \itemize{
\item \code{Name.friendly} -- Friendly encoding name: MIME
Name or JAVA Name or \pkg{ICU} Canonical Name (selecting
the first of supported ones, see below); \item
\code{Name.ICU} -- Encoding name as identified by
\pkg{ICU}; \item \code{Name.*} -- other standardized
encoding names, e.g. \code{Name.UTR22}, \code{Name.IBM},
\code{Name.WINDOWS}, \code{Name.JAVA}, \code{Name.IANA},
\code{Name.MIME} (some may be not available for selected
encodings); \item \code{ASCII.subset} -- is ASCII a subset
of the given encoding?; \item \code{Unicode.1to1} -- for
8-bit encodings only: are all characters translated to
exactly one Unicode code point and is this translation well
reversible?; \item \code{CharSize.8bit} -- is this an 8-bit
encoding, i.e. do we have \code{CharSize.min ==
CharSize.max} and \code{CharSize.min == 1}?; \item
\code{CharSize.min} -- minimal number of bytes used to
represent a code point; \item \code{CharSize.max} --
maximal number of bytes used to represent a code point. }
}
\description{
Gets basic information on a given character encoding.
}
\details{
If the encoding provided is unknown to \pkg{ICU} (see
\code{\link{stri_enc_list}}), an error is generated.

If you set a default encoding that is not a superset of
ASCII or it is not an 8-bit encoding, a warning will be
generated, see \link{stringi-encoding} for discussion.
}
\seealso{
Other encoding_management: \code{\link{stri_enc_get}},
\code{\link{stri_enc_set}}; \code{\link{stri_enc_list}};
\code{\link{stringi-encoding}}
}

