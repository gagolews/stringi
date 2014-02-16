\name{stri_locate_first}
\alias{stri_locate_first}
\title{Locate First Occurrence of a Pattern}
\usage{
stri_locate_first(str, ..., regex, fixed, charclass)
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
Returns an integer matrix with two columns, with double
\code{NA}s in a row if a pattern not found.
}
\description{
A convenience function. Calls either
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_first_fixed}}, or
\code{\link{stri_locate_first_charclass}}, depending on the
argument used.
}
\details{
Unless you are very lazy, please call the underlying
functions directly for better performance.

Please note that the parameters are considered in the
following order: \code{regex}, \code{fixed} and
\code{class}. Thus, if you specify \code{regex} and
\code{class}, only the first one will be used.
}
\examples{
\dontrun{
s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
stri_locate_first('XaaaaX',
   regex=c('\\\\p{Ll}', '\\\\p{Ll}+', '\\\\p{Ll}{2,3}', '\\\\p{Ll}{2,3}?'))
stri_locate_first('Bartolini', fixed=letters[1:3])
stri_locate_first('a b c', charclass='Zs')
}
}
\seealso{
Other indexing: \code{\link{stri_locate_all_charclass}},
\code{\link{stri_locate_all_charclass}},
\code{\link{stri_locate_first_charclass}},
\code{\link{stri_locate_first_charclass}},
\code{\link{stri_locate_last_charclass}},
\code{\link{stri_locate_last_charclass}};
\code{\link{stri_locate_all_fixed}},
\code{\link{stri_locate_all_fixed,}},
\code{\link{stri_locate_first_fixed}},
\code{\link{stri_locate_first_fixed,}},
\code{\link{stri_locate_last_fixed}},
\code{\link{stri_locate_last_fixed}};
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_last_regex}},
\code{\link{stri_locate_last_regex}};
\code{\link{stri_locate_all}};
\code{\link{stri_locate_last}}; \code{\link{stri_locate}};
\code{\link{stri_sub}}, \code{\link{stri_sub<-}}

Other search_locate: \code{\link{stri_extract_all_fixed}},
\code{\link{stri_extract_all_fixed,}},
\code{\link{stri_extract_first_fixed}},
\code{\link{stri_extract_first_fixed,}},
\code{\link{stri_extract_last_fixed}},
\code{\link{stri_extract_last_fixed}};
\code{\link{stri_locate_all_charclass}},
\code{\link{stri_locate_all_charclass}},
\code{\link{stri_locate_first_charclass}},
\code{\link{stri_locate_first_charclass}},
\code{\link{stri_locate_last_charclass}},
\code{\link{stri_locate_last_charclass}};
\code{\link{stri_locate_all_fixed}},
\code{\link{stri_locate_all_fixed,}},
\code{\link{stri_locate_first_fixed}},
\code{\link{stri_locate_first_fixed,}},
\code{\link{stri_locate_last_fixed}},
\code{\link{stri_locate_last_fixed}};
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_last_regex}},
\code{\link{stri_locate_last_regex}};
\code{\link{stri_locate_all}};
\code{\link{stri_locate_last}}; \code{\link{stri_locate}};
\code{\link{stringi-search}}
}

