\name{stri_enc_nfc}
\alias{stri_enc_isnfc}
\alias{stri_enc_isnfd}
\alias{stri_enc_isnfkc}
\alias{stri_enc_isnfkc_casefold}
\alias{stri_enc_isnfkd}
\alias{stri_enc_nfc}
\alias{stri_enc_nfd}
\alias{stri_enc_nfkc}
\alias{stri_enc_nfkc_casefold}
\alias{stri_enc_nfkd}
\title{Perform or Check For Unicode Normalization}
\usage{
stri_enc_nfc(str)

stri_enc_nfd(str)

stri_enc_nfkd(str)

stri_enc_nfkc(str)

stri_enc_nfkc_casefold(str)

stri_enc_isnfc(str)

stri_enc_isnfd(str)

stri_enc_isnfkd(str)

stri_enc_isnfkc(str)

stri_enc_isnfkc_casefold(str)
}
\arguments{
  \item{str}{character vector to be encoded}
}
\value{
The \code{stri_enc_nf*} functions return a character vector
of the same length as input (the output is always in
UTF-8).

On the other hand, \code{stri_enc_isnf*} return a logical
vector.
}
\description{
These functions convert strings to NFC, NFKC, NFD, NFKD, or
NFKC_Casefold Unicode Normalization Form or check whether
strings are normalized.
}
\details{
Unicode Normalization Forms are formally defined
normalizations of Unicode strings which e.g. make possible
to determine whether any two strings are equivalent.
Essentially, the Unicode Normalization Algorithm puts all
combining marks in a specified order, and uses rules for
decomposition and composition to transform each string into
one of the Unicode Normalization Forms.

The following Normalization Forms (NFs) are supported:
\itemize{ \item NFC (Canonical Decomposition, followed by
Canonical Composition), \item NFD (Canonical
Decomposition), \item NFKC (Compatibility Decomposition,
followed by Canonical Composition), \item NFKD
(Compatibility Decomposition), \item NFKC_Casefold
(combination of NFKC, case folding, and removing ignorable
characters which was introduced with Unicode 5.2). }

Note that many W3C Specifications recommend using NFC for
all content, because this form avoids potential
interoperability problems arising from the use of
canonically equivalent, yet different, character sequences
in document formats on the Web. Thus, you will rather not
use these functions in typical stringi processing
activities. Most often you may assume that a string is in
NFC.

As usual in \pkg{stringi}, if the input character vector is
in the native encoding, it will be converted to UTF-8
automatically.
}
\references{
\emph{Unicode Normalization Forms} -- Unicode Standard
Annex #15, \url{http://unicode.org/reports/tr15}

\emph{Character Model for the World Wide Web 1.0:
Normalization} -- W3C Working Draft,
\url{http://www.w3.org/TR/charmod-norm/}

\emph{Normalization} -- ICU User Guide,
\url{http://userguide.icu-project.org/transforms/normalization}
(technical details)

\emph{Unicode Equivalence} -- Wikipedia,
\url{http://en.wikipedia.org/wiki/Unicode_equivalence}
}
\seealso{
Other encoding_normalization:
\code{\link{stringi-encoding}}
}

