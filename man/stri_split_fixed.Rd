\name{stri_split_fixed}
\alias{stri_split_fixed}
\title{Split up a String By Fixed Pattern Matches}
\usage{
stri_split_fixed(str, pattern, n_max = -1L, omit_empty = FALSE,
  opts_collator = list())
}
\arguments{
  \item{str}{character vector with strings to search in}

  \item{pattern}{character vector with fixed patterns}

  \item{n_max}{integer vector, maximal number of pieces to
  return}

  \item{omit_empty}{logical vector; determines whether
  empty strings should be removed from the result}

  \item{opts_collator}{a named list as generated with
  \code{\link{stri_opts_collator}} with Collator options,
  or \code{NA} for fast but locale-unaware byte comparison}
}
\value{
Returns a list of character vectors.
}
\description{
Splits each element of \code{str} into substring.
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

Pass \code{opts_collator} that is equal to \code{NA} for a
much faster, but locale unaware, (exact) bitwise string
comparisons. For natural language text, however, this may
not be what you really want.
}
\examples{
\dontrun{
stri_split_fixed("Lorem ipsum dolor sit amet", " ")
}
}
\seealso{
Other locale_sensitive: \code{\link{stri_cmp}},
\code{\link{stri_compare}}; \code{\link{stri_count_fixed}};
\code{\link{stri_detect_fixed}};
\code{\link{stri_enc_detect2}};
\code{\link{stri_locate_all_fixed}},
\code{\link{stri_locate_all_fixed,}},
\code{\link{stri_locate_first_fixed}},
\code{\link{stri_locate_first_fixed,}},
\code{\link{stri_locate_last_fixed}},
\code{\link{stri_locate_last_fixed}};
\code{\link{stri_opts_collator}}; \code{\link{stri_order}},
\code{\link{stri_sort}};
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_last_fixed}},
\code{\link{stri_replace_last_fixed}};
\code{\link{stri_trans_tolower}},
\code{\link{stri_trans_totitle}},
\code{\link{stri_trans_toupper}};
\code{\link{stringi-locale}};
\code{\link{stringi-search-fixed}}

Other search_fixed: \code{\link{stri_count_fixed}};
\code{\link{stri_detect_fixed}};
\code{\link{stri_extract_all_fixed}},
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
\code{\link{stri_opts_collator}};
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_last_fixed}},
\code{\link{stri_replace_last_fixed}};
\code{\link{stringi-search-fixed}};
\code{\link{stringi-search}}

Other search_split: \code{\link{stri_split_charclass}},
\code{\link{stri_split_charclass}};
\code{\link{stri_split_lines}},
\code{\link{stri_split_lines}},
\code{\link{stri_split_lines1}},
\code{\link{stri_split_lines1}};
\code{\link{stri_split_regex}},
\code{\link{stri_split_regex}}; \code{\link{stri_split}};
\code{\link{stringi-search}}
}

