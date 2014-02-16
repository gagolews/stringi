\name{stri_locate_all_regex}
\alias{stri_locate_all_regex}
\alias{stri_locate_first_regex}
\alias{stri_locate_last_regex}
\title{Locate Occurrences of a Regex Pattern}
\usage{
stri_locate_all_regex(str, pattern, opts_regex = list())

stri_locate_first_regex(str, pattern, opts_regex = list())

stri_locate_last_regex(str, pattern, opts_regex = list())
}
\arguments{
  \item{str}{character vector of strings to search in}

  \item{pattern}{character vector of regular expressions}

  \item{opts_regex}{a named list as generated with
  \code{\link{stri_opts_regex}}}
}
\value{
For \code{stri_locate_all_charclass}, a list of
\code{max(length(str), length(pattern))} integer matrices
is returned . The first column gives the start positions of
matches, and the second column gives the end position.
Moreover, you may gen two \code{NA}s in one row for no
match or \code{NA} arguments.

For \code{stri_locate_first_fixed} and
\code{stri_locate_last_fixed}, you get an integer matrix
with \code{max(length(str), length(pattern))} rows, and two
columns, giving the start and end positions of the first or
the last matches, respectively, and \code{NA}s iff not
found.
}
\description{
These functions find the indices, at which a regex pattern
matches a substring of the input string.
}
\details{
Vectorized over \code{str} and \code{pattern}.
}
\examples{
\dontrun{
stri_locate_all_regex('XaaaaX',
   c('\\\\p{Ll}', '\\\\p{Ll}+', '\\\\p{Ll}{2,3}', '\\\\p{Ll}{2,3}?'))
stri_locate_first_regex('XaaaaX',
   c('\\\\p{Ll}', '\\\\p{Ll}+', '\\\\p{Ll}{2,3}', '\\\\p{Ll}{2,3}?'))
stri_locate_last_regex('XaaaaX',
   c('\\\\p{Ll}', '\\\\p{Ll}+', '\\\\p{Ll}{2,3}', '\\\\p{Ll}{2,3}?'))
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
\code{\link{stri_locate_all}};
\code{\link{stri_locate_first}};
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
\code{\link{stri_locate_all}};
\code{\link{stri_locate_first}};
\code{\link{stri_locate_last}}; \code{\link{stri_locate}};
\code{\link{stringi-search}}

Other search_regex: \code{\link{stri_count_regex}};
\code{\link{stri_detect_regex}};
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_last_regex}},
\code{\link{stri_extract_last_regex}};
\code{\link{stri_match_all_regex}},
\code{\link{stri_match_all_regex}},
\code{\link{stri_match_first_regex}},
\code{\link{stri_match_first_regex}},
\code{\link{stri_match_last_regex}},
\code{\link{stri_match_last_regex}};
\code{\link{stri_opts_regex}};
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_last_regex}},
\code{\link{stri_replace_last_regex}};
\code{\link{stri_split_regex}},
\code{\link{stri_split_regex}};
\code{\link{stringi-search-regex}};
\code{\link{stringi-search}}
}

