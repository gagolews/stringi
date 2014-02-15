\name{stri_enc_set}
\alias{stri_enc_get}
\alias{stri_enc_set}
\title{Set or Get Default Character Encoding in \pkg{stringi}}
\usage{
stri_enc_set(enc)

stri_enc_get()
}
\arguments{
  \item{enc}{single string; character encoding name, see
  \code{\link{stri_enc_list}} for the list of supported
  encodings.}
}
\value{
\code{stri_enc_set} returns a string with previously used
character encoding, invisibly.

\code{stri_enc_get} returns a string with current default
character encoding.
}
\description{
\code{stri_enc_set} sets the encoding used to decode
strings internally (i.e. by \R) marked as Native, see
\link{stringi-encoding}. \code{stri_enc_get} returns
currently used default encoding.
}
\details{
\code{stri_enc_get} is the same as
\code{\link{stri_enc_info}(NULL)$Name.friendly}.

Note that changing the default encoding may have undesired
consequences.
}
\seealso{
Other encoding_management: \code{\link{stri_enc_info}};
\code{\link{stri_enc_list}}; \code{\link{stringi-encoding}}
}

