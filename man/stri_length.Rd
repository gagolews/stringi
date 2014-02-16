\name{stri_length}
\alias{stri_length}
\title{Count the Number of Characters}
\usage{
stri_length(str)
}
\arguments{
  \item{str}{character vector}
}
\value{
Returns an integer vector of the same length as \code{str}.
}
\description{
This function returns the number of code points in each
string.
}
\details{
Note that the number of code points is not the same as the
`width` of the string when printed on the screen.

If a given string is in UTF-8 and has not been properly
Unicode normalized (e.g. by \code{\link{stri_enc_nfc}}),
this number may sometimes be misleading.

Missing values are handled properly, as opposed to the
built-in \code{\link{nchar}} function. For `byte` encodings
we get, as usual, an error.
}
\examples{
stri_length(LETTERS)
stri_length(c('abc','123','\\u0105\\u0104'))
stri_length('\\u0105') # length is equal to one, but...
stri_numbytes('\\u0105') # just like here
\dontrun{
stri_length(stri_enc_nfkd('\\u0105')) # ...two code points (!)
}
}
\seealso{
Other length: \code{\link{stri_isempty}};
\code{\link{stri_numbytes}}
}

