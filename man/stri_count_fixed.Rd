\name{stri_count_fixed}
\alias{stri_count_fixed}
\title{Count the Number of Fixed Pattern Matches}
\usage{
stri_count_fixed(str, pattern, opts_collator = list())
}
\arguments{
  \item{str}{character vector}

  \item{pattern}{character vector}

  \item{opts_collator}{a named list as generated with
  \code{\link{stri_opts_collator}} with Collator options,
  or \code{NA} for fast but locale-unaware byte comparison}
}
\value{
Returns an integer vector with the number of matches.
}
\description{
This function counts the number of occurrences of a fixed
pattern in a string.
}
\details{
Vectorized over \code{str} and \code{pattern}.

If \code{pattern} is empty, then the result is \code{NA}
and a warning is generated.

See \link{stringi-search-fixed} for more details on
Locale-Sensitive Text Searching in \pkg{stringi}.

Pass \code{opts_collator} equal to \code{NA} for much
faster, but locale unaware, (exact) byte comparisons. For
natural language text this may be not what you really want.
}
\examples{
\dontrun{
s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
stri_count_fixed(s, " ")
stri_count_fixed(s, "o")
stri_count_fixed(s, "it")
stri_count_fixed(s, letters)
stri_count_fixed("babab", "b")
stri_count_fixed(c("stringi w R","REXAMINE","123"), 'R')
}
}
\seealso{
Other locale_sensitive: \code{\link{stri_cmp}},
\code{\link{stri_compare}};
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
\code{\link{stringi-locale}};
\code{\link{stringi-search-fixed}}

Other search_count: \code{\link{stri_count_charclass}};
\code{\link{stri_count_regex}}; \code{\link{stri_count}};
\code{\link{stringi-search}}

Other search_fixed: \code{\link{stri_detect_fixed}};
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
\code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stringi-search-fixed}};
\code{\link{stringi-search}}
}

