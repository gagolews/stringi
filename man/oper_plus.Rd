\name{\%+\%}
\alias{\%+\%}
\title{Concatenate Two Character Vectors}
\usage{
e1 \%+\% e2
}
\arguments{
  \item{e1}{character vector}

  \item{e2}{character vector}
}
\value{
Returns a character vector.
}
\description{
A binary operator for joining (concatenating) two character
vectors, with a typical \R look-and-feel.
}
\details{
Vectorized over \code{e1} and \code{e2}.

This operator works like a call to
\code{\link{stri_join}(e1, e2, sep="")} (but is slightly
faster). However, note that joining 3 vectors, e.g.
\code{e1 \%+\% e2 \%+\% e3} is slower than
\code{\link{stri_join}(e1, e2, e3, sep="")}, because it
creates a new (temporary) result vector each time the
operator is applied.
}
\examples{
c('abc','123','\\u0105\\u0104')\%+\%letters[1:6]
'ID_'\%+\%1:5
}

