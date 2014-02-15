\name{stri_enc_list}
\alias{stri_enc_list}
\title{List Known Character Encodings}
\usage{
stri_enc_list(simplified = FALSE)
}
\arguments{
  \item{simplified}{single logical value; return a
  character vector or a list of character vectors?}
}
\value{
If \code{simplified} is \code{FALSE} (the default), a list
of character vectors is returned. Each list element
represents a unique character encoding. The \code{name}
attribute gives the \pkg{ICU} Canonical Name of an encoding
family. The elements (character vectors) are its aliases.

If \code{simplified} is \code{TRUE}, then the resulting
list is coerced to a character vector, sorted, and its
duplicates are removed.
}
\description{
Gives encodings that are supported by \pkg{ICU}.
}
\details{
Please note that apart from given encodings, \pkg{ICU}
tries to normalize encoding specifiers. E.g. \code{"UTF8"}
is also valid, see \link{stringi-encoding} for more
information.
}
\seealso{
Other encoding_management: \code{\link{stri_enc_get}},
\code{\link{stri_enc_set}}; \code{\link{stri_enc_info}};
\code{\link{stringi-encoding}}
}

