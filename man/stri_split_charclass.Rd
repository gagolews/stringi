\name{stri_split_charclass}
\alias{stri_split_charclass}
\title{Split up a String by a Character Class}
\usage{
stri_split_charclass(str, pattern, n_max = -1L, omit_empty = FALSE)
}
\arguments{
  \item{str}{character vector with strings to search in}

  \item{pattern}{character vector; identifiers of character
  classes, see \link{stringi-search-charclass}}

  \item{n_max}{integer vector, maximal number of pieces to
  return}

  \item{omit_empty}{logical vector; determines whether
  empty strings should be removed from the result}
}
\value{
Returns a list of character vectors.
}
\description{
Splits each element of \code{str} into substrings.
\code{pattern} indicates delimiters that separate the input
into fields. The input data between the matches become the
fields themselves.
}
\details{
Vectorized over \code{str}, \code{pattern}, \code{n_max},
and \code{omit_empty}.

If \code{n_max} is negative (default), then all pieces are
extracted.

\code{omit_empty} is applied during the split process: if
it is set to \code{TRUE}, then empty strings will never
appear in the resulting vector.
}
\examples{
stri_split_charclass("Lorem ipsum dolor sit amet", "WHITE_SPACE")
stri_split_charclass(" Lorem  ipsum dolor", "WHITE_SPACE", n=3,
   omit_empty=c(FALSE, TRUE))
}
\seealso{
Other search_charclass: \code{\link{stri_count_charclass}};
\code{\link{stri_detect_charclass}};
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_last_charclass}},
\code{\link{stri_extract_last_charclass}};
\code{\link{stri_locate_all_charclass}},
\code{\link{stri_locate_all_charclass}},
\code{\link{stri_locate_first_charclass}},
\code{\link{stri_locate_first_charclass}},
\code{\link{stri_locate_last_charclass}},
\code{\link{stri_locate_last_charclass}};
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_last_charclass}},
\code{\link{stri_replace_last_charclass}};
\code{\link{stri_trim}}, \code{\link{stri_trim}},
\code{\link{stri_trim_both}}, \code{\link{stri_trim_left}},
\code{\link{stri_trim_right}};
\code{\link{stringi-search-charclass}};
\code{\link{stringi-search}}

Other search_split: \code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stri_split_lines}},
\code{\link{stri_split_lines}},
\code{\link{stri_split_lines1}},
\code{\link{stri_split_lines1}};
\code{\link{stri_split_regex}},
\code{\link{stri_split_regex}}; \code{\link{stri_split}};
\code{\link{stringi-search}}
}

