\name{\%<\%}
\alias{\%!=\%}
\alias{\%<=\%}
\alias{\%<\%}
\alias{\%==\%}
\alias{\%>=\%}
\alias{\%>\%}
\title{Compare Two Character Vectors with Collation}
\usage{
e1 \%<\% e2

e1 \%>\% e2

e1 \%<=\% e2

e1 \%>=\% e2

e1 \%==\% e2

e1 \%!=\% e2

e1 \%<=\% e2

e1 \%>\% e2

e1 \%>=\% e2

e1 \%==\% e2

e1 \%!=\% e2
}
\arguments{
  \item{e1}{character vector or an object coercible to a
  character vector}

  \item{e2}{character vector or an object coercible to a
  character vector}
}
\value{
Returns a logical vector indicating the result of the
element-by-element comparison. As usual, the elements of
shorter vectors are recycled as necessary.
}
\description{
Relational operators for comparing two character vectors,
with a typical \R look-and-feel.
}
\details{
These functions call \code{\link{stri_cmp_le}} or its
friends, using default collator options.
}
\examples{
\dontrun{
"a" \%<\% "b"
c("a", "b", "c") \%>=\% "b"
}
}

