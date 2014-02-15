\name{stri_isempty}
\alias{stri_isempty}
\title{Determine if a String is Empty}
\usage{
stri_isempty(str)
}
\arguments{
  \item{str}{character vector}
}
\value{
Returns a logical vector of the same length as \code{str}.
}
\description{
This is the fastest way to find out whether the elements of
a character vector are empty strings or not.
}
\details{
Missing values are handled properly, as opposed to the
built-in \code{\link{nzchar}} function.
}
\examples{
stri_isempty(letters[1:3])
stri_isempty(c(',','','abc','123','\\u0105\\u0104'))
stri_isempty(character(1))
}
\seealso{
Other length: \code{\link{stri_length}};
\code{\link{stri_numbytes}}
}

