\name{stri_replace_last}
\alias{stri_replace_last}
\title{Replace Last Occurrence of a Pattern}
\usage{
stri_replace_last(str, replacement, ..., regex, fixed, charclass)
}
\arguments{
  \item{str}{character vector of strings to search in}

  \item{...}{additional arguments passed to the underlying
  functions}

  \item{regex}{character vector; regular expressions}

  \item{fixed}{character vector; fixed patterns}

  \item{charclass}{character vector; identifiers of
  character classes}

  \item{replacement}{character vector of strings to replace
  with}
}
\value{
character vector
}
\description{
A convenience function. Calls either
\code{\link{stri_replace_last_regex}},
\code{\link{stri_replace_last_fixed}}, or
\code{\link{stri_replace_last_charclass}}, depending on the
argument used.
}
\seealso{
Other search_replace:
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_last_charclass}},
\code{\link{stri_replace_last_charclass}};
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_last_fixed}},
\code{\link{stri_replace_last_fixed}};
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_last_regex}},
\code{\link{stri_replace_last_regex}};
\code{\link{stri_replace_all}};
\code{\link{stri_replace_first}};
\code{\link{stri_replace}}; \code{\link{stringi-search}}
}

