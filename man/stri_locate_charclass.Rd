\name{stri_locate_all_charclass}
\alias{stri_locate_all_charclass}
\alias{stri_locate_first_charclass}
\alias{stri_locate_last_charclass}
\title{Locate Occurrences of a Character Class}
\usage{
stri_locate_all_charclass(str, pattern, merge = TRUE)

stri_locate_first_charclass(str, pattern)

stri_locate_last_charclass(str, pattern)
}
\arguments{
  \item{str}{character vector to search in}

  \item{pattern}{character vector; identifiers of character
  classes, see \link{stringi-search-charclass}}

  \item{merge}{logical [\code{stri_locate_all_charclass}
  only]; indicates whether consecutive sequences of indices
  in the resulting matrix shall be merged}
}
\value{
For \code{stri_locate_all_charclass}, a list of
\code{max(length(str), length(pattern))} integer matrices
is returned . The first column gives the start positions of
matches, and the second column gives the end position.
Moreover, you may gen two \code{NA}s in one row for no
match or \code{NA} arguments.

For \code{stri_locate_first_charclass} and
\code{stri_locate_last_charclass}, you get an integer
matrix with \code{max(length(str), length(pattern))} rows,
and two columns, giving the start and end positions of the
first or the last matches, respectively, and two \code{NA}s
iff not found. Note that the first column is always equal
to the second column, as we look for single code points in
these two cases.
}
\description{
These functions may be used e.g. to find the indices, at
which letters, digits, or white spaces occur in a given
string.
}
\details{
Vectorized over \code{str}, \code{pattern}, and
\code{merge}.
}
\examples{
stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), 'Ll')
stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), 'Ll', merge=FALSE)
stri_locate_first_charclass('AaBbCc', 'Ll')
stri_locate_last_charclass('AaBbCc', 'Ll')
stri_locate_all_charclass(c('REXAMINE'), 'Lu', merge=c(TRUE, FALSE))
}
\seealso{
Other indexing: \code{\link{stri_locate_all_fixed}},
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
\code{\link{stri_locate_first}};
\code{\link{stri_locate_last}}; \code{\link{stri_locate}};
\code{\link{stri_sub}}, \code{\link{stri_sub<-}}

Other search_charclass: \code{\link{stri_count_charclass}};
\code{\link{stri_detect_charclass}};
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_last_charclass}},
\code{\link{stri_extract_last_charclass}};
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_last_charclass}},
\code{\link{stri_replace_last_charclass}};
\code{\link{stri_split_charclass}},
\code{\link{stri_split_charclass}};
\code{\link{stri_trim}}, \code{\link{stri_trim}},
\code{\link{stri_trim_both}}, \code{\link{stri_trim_left}},
\code{\link{stri_trim_right}};
\code{\link{stringi-search-charclass}};
\code{\link{stringi-search}}

Other search_locate: \code{\link{stri_extract_all_fixed}},
\code{\link{stri_extract_all_fixed,}},
\code{\link{stri_extract_first_fixed}},
\code{\link{stri_extract_first_fixed,}},
\code{\link{stri_extract_last_fixed}},
\code{\link{stri_extract_last_fixed}};
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
\code{\link{stri_locate_first}};
\code{\link{stri_locate_last}}; \code{\link{stri_locate}};
\code{\link{stringi-search}}
}

