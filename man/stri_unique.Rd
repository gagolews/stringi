\name{stri_unique}
\alias{stri_unique}
\title{Extract Unique Elements}
\usage{
stri_unique(str, opts_collator = NULL)
}
\arguments{
  \item{str}{character vector}

  \item{opts_collator}{a named list with \pkg{ICU}
  Collator's options as generated with
  \code{\link{stri_opts_collator}}, \code{NULL} for default
  collation options, or \code{NA} for locale-independent
  Unicode code point comparison}
}
\value{
Returns a character vector.
}
\description{
This function returns a character vector like \code{str},
but with duplicate elements removed.
}
\details{
As usual in \pkg{stringi}, no attributes are copied. Unlike
\code{\link{unique}}, this function may (if
\code{opts_collator} is not \code{NA}) detect a correct
locale-dependent string equivalence.
}
\examples{
\dontrun{
stri_unique(c("\\u0105", stri_enc_nfkd("\\u0105")))
}
}
\seealso{
Other locale_sensitive: \code{\link{\%!=\%}},
\code{\link{\%<=\%}}, \code{\link{\%<\%}},
\code{\link{\%==\%}}, \code{\link{\%>=\%}},
\code{\link{\%>\%}}, \code{\link{\%stri!=\%}},
\code{\link{\%stri<=\%}}, \code{\link{\%stri<\%}},
\code{\link{\%stri==\%}}, \code{\link{\%stri>=\%}},
\code{\link{\%stri>\%}}; \code{\link{stri_cmp}},
\code{\link{stri_cmp_eq}}, \code{\link{stri_cmp_ge}},
\code{\link{stri_cmp_gt}}, \code{\link{stri_cmp_le}},
\code{\link{stri_cmp_lt}}, \code{\link{stri_cmp_neq}},
\code{\link{stri_compare}}; \code{\link{stri_count_fixed}};
\code{\link{stri_detect_fixed}};
\code{\link{stri_duplicated}},
\code{\link{stri_duplicated_any}};
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
\code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stri_trans_tolower}},
\code{\link{stri_trans_totitle}},
\code{\link{stri_trans_toupper}};
\code{\link{stringi-locale}};
\code{\link{stringi-search-fixed}}
}

