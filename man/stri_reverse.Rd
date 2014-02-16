\name{stri_reverse}
\alias{stri_reverse}
\title{Reverse Each String}
\usage{
stri_reverse(str)
}
\arguments{
  \item{str}{character vector}
}
\value{
Returns a character vector.
}
\description{
Reverses characters in every string.
}
\details{
Note that this operation is not very intelligent -- it just
reverses the order of all Unicode code points. It may
result in non-Unicode-normalized strings and may give
strange output for bidirectional strings.
}
\examples{
stri_reverse(c("123", "abc d e f"))
stri_reverse("ZXY (\\u0105\\u0104123$^).")
\dontrun{
stri_reverse(stri_enc_nfd('\\u0105')) == stri_enc_nfd('\\u0105') # A, ogonek -> agonek, A
}
}

