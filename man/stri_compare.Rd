\name{stri_compare}
\alias{stri_cmp}
\alias{stri_compare}
\title{Compare Strings with or without Collation}
\usage{
stri_compare(e1, e2, opts_collator = list())

stri_cmp(e1, e2, opts_collator = list())
}
\arguments{
  \item{e1}{character vector}

  \item{e2}{character vector}

  \item{opts_collator}{a named list as generated with
  \code{\link{stri_opts_collator}} with Collator's options,
  or \code{NA} for dummy Unicode code point comparison}
}
\value{
Each function returns an integer vector with comparison
results of corresponding pairs of elements from \code{e1}
and \code{e2}: \code{-1} if \code{e1[...] < e2[...]},
\code{0} if they are equal, and \code{1} if greater.
}
\description{
These functions may be used to determine if two strings are
equal (this is performed more intelligently than you may
expect at a first glance) or to check whether they appear
in a specific lexicographic order.
}
\details{
\link{stri_cmp} is an alias to \link{stri_compare}. They
both do the same operation.

Vectorized over \code{e1} and \code{e2}.

For more information on \pkg{ICU}'s Collator and how to
tune it up in \pkg{stringi}, refer to
\code{\link{stri_opts_collator}}. Please note that
different locale settings may lead to different results
(see the examples below).
}
\examples{
\dontrun{
stri_cmp("hladny", "chladny", stri_opts_collator(locale="pl_PL")) # in Polish ch < h
stri_cmp("hladny", "chladny", stri_opts_collator(locale="sk_SK")) # in Slovak ch > h
stri_cmp("hladny", "HLADNY") # < or > (depends on locale)
stri_cmp("hladny", "HLADNY", stri_opts_collator(strength=2)) # ==
stri_cmp("hladn\\u00FD", "hladny", stri_opts_collator(strength=1, locale="sk_SK")) # ==
stri_cmp(stri_enc_nfkd('\\u0105'), '\\u105') # but cf. stri_enc_nfkd('\\u0105') != '\\u105'
}
}
\seealso{
Other locale_sensitive: \code{\link{stri_count_fixed}};
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
}

