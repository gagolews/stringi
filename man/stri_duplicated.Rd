\name{stri_duplicated}
\alias{stri_duplicated}
\alias{stri_duplicated_any}
\title{Determine Duplicated Elements}
\usage{
stri_duplicated(str, fromLast = FALSE, opts_collator = NULL)

stri_duplicated_any(str, fromLast = FALSE, opts_collator = NULL)
}
\arguments{
  \item{str}{character vector}

  \item{fromLast}{single logical value; indicating whether
  duplication should be considered from the reverse side}

  \item{opts_collator}{a named list with \pkg{ICU}
  Collator's options as generated with
  \code{\link{stri_opts_collator}}, \code{NULL} for default
  collation options, or \code{NA} for locale-independent
  Unicode code point comparison}
}
\value{
\code{stri_duplicated()} returns a logical vector of the
same length as \code{str}. Each of its elements indicates
if an equivalent string already appeared in \code{str}.

\code{stri_duplicated_any()} returns a single non-negative
integer. Value of 0 indicates that all the elements in
\code{str} are unique. Otherwise, it gives the index of the
first non-unique element.
}
\description{
\code{stri_duplicated()} determines which strings in a
character vector are duplicates of other elements.

\code{stri_duplicated_any()} determines if there are any
duplicated strings in a character vector.
}
\details{
Missing values are regarded as equal.
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
\code{\link{stri_unique}}; \code{\link{stringi-locale}};
\code{\link{stringi-search-fixed}}

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
\code{\link{stri_unique}}; \code{\link{stringi-locale}};
\code{\link{stringi-search-fixed}}
}

