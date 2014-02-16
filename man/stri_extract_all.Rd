\name{stri_extract_all}
\alias{stri_extract_all}
\title{Extract All Pattern Matches}
\usage{
stri_extract_all(str, ..., regex, fixed, charclass)
}
\arguments{
  \item{str}{character vector of strings to search in}

  \item{...}{additional arguments passed to the underlying
  functions}

  \item{regex}{character vector; regular expressions}

  \item{fixed}{character vector; fixed patterns}

  \item{charclass}{character vector; identifiers of
  character classes}
}
\value{
Returns a list of character vectors.
}
\description{
A convenience function. Calls either
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_all_fixed}}, or
\code{\link{stri_extract_all_charclass}}, depending on the
argument used.
}
\details{
Unless you are very lazy, please call the underlying
functions directly for better performance.
}
\examples{
\dontrun{
stri_extract_all('XaaaaX', regex=c('\\\\p{Ll}', '\\\\p{Ll}+', '\\\\p{Ll}{2,3}', '\\\\p{Ll}{2,3}?'))
stri_extract_all('Bartolini', fixed='i')
stri_extract_all('stringi are so good!', charclass='Zs') # all whitespaces
}
}
\seealso{
Other search_extract:
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_last_charclass}},
\code{\link{stri_extract_last_charclass}};
\code{\link{stri_extract_all_fixed}},
\code{\link{stri_extract_all_fixed,}},
\code{\link{stri_extract_first_fixed}},
\code{\link{stri_extract_first_fixed,}},
\code{\link{stri_extract_last_fixed}},
\code{\link{stri_extract_last_fixed}};
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_last_regex}},
\code{\link{stri_extract_last_regex}};
\code{\link{stri_extract_first}};
\code{\link{stri_extract_last}};
\code{\link{stri_extract}}; \code{\link{stringi-search}}
}

