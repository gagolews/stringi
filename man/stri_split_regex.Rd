\name{stri_split_regex}
\alias{stri_split_regex}
\title{Split up a String By Regex Pattern Matches}
\usage{
stri_split_regex(str, pattern, n_max = -1L, omit_empty = FALSE,
  opts_regex = list())
}
\arguments{
  \item{str}{character vector with strings to search in}

  \item{pattern}{pattern character; regular expressions}

  \item{n_max}{integer vector, maximal number of pieces to
  return}

  \item{omit_empty}{logical vector; determines whether
  empty strings should be removed from the result}

  \item{opts_regex}{a named list as generated with
  \code{\link{stri_opts_regex}}}
}
\value{
Returns a list of character vectors.
}
\description{
Splits each element of \code{str} into substrings. A
\code{pattern} indicates delimiters that separate the input
into fields. The input data between the matches become the
fields themselves.
}
\details{
Vectorized over \code{str}, \code{pattern}, \code{n_max},
and \code{omit_empty}.

If \code{n_max} is negative (default), then all pieces are
extracted.

\code{omit_empty} is applied during splitting: if set to
\code{TRUE}, then empty strings will never appear in the
resulting vector.

Note that if you want to split a string by characters from
a specific class (e.g. whitespaces),
\code{\link{stri_split_charclass}} will be much faster.
}
\examples{
\dontrun{
stri_split_regex("Lorem ipsum dolor sit amet",
   "\\\\p{Z}+") # see also stri_split_charclass
}
}
\seealso{
Other search_regex: \code{\link{stri_count_regex}};
\code{\link{stri_detect_regex}};
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_last_regex}},
\code{\link{stri_extract_last_regex}};
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_last_regex}},
\code{\link{stri_locate_last_regex}};
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
\code{\link{stringi-search-regex}};
\code{\link{stringi-search}}

Other search_split: \code{\link{stri_split_charclass}},
\code{\link{stri_split_charclass}};
\code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stri_split_lines}},
\code{\link{stri_split_lines}},
\code{\link{stri_split_lines1}},
\code{\link{stri_split_lines1}}; \code{\link{stri_split}};
\code{\link{stringi-search}}
}

