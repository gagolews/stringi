\name{stri_detect_fixed}
\alias{stri_detect_fixed}
\title{Detect a Fixed Pattern Match}
\usage{
stri_detect_fixed(str, pattern, opts_collator = list())
}
\arguments{
  \item{str}{character vector}

  \item{pattern}{character vector}

  \item{opts_collator}{a named list as generated with
  \code{\link{stri_opts_collator}} with Collator options,
  or \code{NA} for fast but locale-unaware byte comparison}
}
\value{
Returns a logical vector.
}
\description{
This function checks if there is at least one occurrence of
a fixed pattern in a string.
}
\details{
Vectorized over \code{str} and \code{pattern}.

See \link{stringi-search-fixed} for more details on
locale-sensitive text searching in \pkg{stringi}.

If \code{pattern} is empty, then the result is \code{NA}
and a warning is generated.

Pass \code{opts_collator} equal to \code{NA} for much
faster, but locale unaware, (exact) byte comparisons. For
natural language text this may be not what you really want.
}
\examples{
\dontrun{
stri_detect_fixed(c("stringi w R","REXAMINE","123"), c('i','R','0'), opts_collator=NA)
stri_detect_fixed(c("stringi w R","REXAMINE","123"), 'R', opts_collator=NA)
}
}
\seealso{
Other locale_sensitive: \code{\link{stri_cmp}},
\code{\link{stri_compare}}; \code{\link{stri_count_fixed}};
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

Other search_detect: \code{\link{stri_detect_charclass}};
\code{\link{stri_detect_regex}}; \code{\link{stri_detect}};
\code{\link{stringi-search}}

Other search_fixed: \code{\link{stri_count_fixed}};
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

