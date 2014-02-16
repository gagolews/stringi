\name{stri_extract_all_fixed}
\alias{stri_extract_all_fixed}
\alias{stri_extract_all_fixed,}
\alias{stri_extract_first_fixed}
\alias{stri_extract_first_fixed,}
\alias{stri_extract_last_fixed}
\title{Extract Fixed Pattern Matches}
\usage{
stri_extract_all_fixed(str, pattern, opts_collator = list())

stri_extract_first_fixed(str, pattern, opts_collator = list())

stri_extract_last_fixed(str, pattern, opts_collator = list())
}
\arguments{
  \item{str}{character vector}

  \item{pattern}{character vector}

  \item{opts_collator}{a named list as generated with
  \code{\link{stri_opts_collator}} with Collator options,
  or \code{NA} for fast but locale-unaware byte comparison}
}
\value{
For \code{stri_extract_all_fixed}, a list of
\code{max(length(str), length(pattern))} character vectors
is returned. Otherwise, you get a character vector.
\code{NA} if not found.
}
\description{
These functions extract substrings of \code{str} that match
a given \code{pattern}.
}
\details{
Vectorized over \code{str} and \code{pattern}.

If \code{collator_opts} is not \code{NA} (default, i.e.
locale-aware search), then the operation is not as dummy as
it seems (for non-ASCII text).
}
\examples{
\dontrun{
stri_extract_all_fixed(c('AaaaaaaA', 'AAAA'), 'a')
stri_extract_first_fixed(c('Yy\\u00FD', 'AAA'), 'y', stri_opts_collator(strength=2, locale="sk_SK"))
stri_extract_last_fixed(c('Yy\\u00FD', 'AAA'), 'y', stri_opts_collator(strength=1, locale="sk_SK"))
}
}
\seealso{
Other search_extract:
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_last_charclass}},
\code{\link{stri_extract_last_charclass}};
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_last_regex}},
\code{\link{stri_extract_last_regex}};
\code{\link{stri_extract_all}};
\code{\link{stri_extract_first}};
\code{\link{stri_extract_last}};
\code{\link{stri_extract}}; \code{\link{stringi-search}}

Other search_fixed: \code{\link{stri_count_fixed}};
\code{\link{stri_detect_fixed}};
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

Other search_locate:
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

