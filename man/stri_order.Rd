\name{stri_order}
\alias{stri_order}
\alias{stri_sort}
\title{Ordering Permutation and Sorting}
\usage{
stri_order(str, decreasing = FALSE, opts_collator = list())

stri_sort(str, decreasing = FALSE, opts_collator = list())
}
\arguments{
  \item{str}{character vector}

  \item{decreasing}{single logical value; should the sort
  order be nondecreasing (\code{FALSE}, default) or
  nonincreasing (\code{TRUE})?}

  \item{opts_collator}{a named list as generated with
  \code{\link{stri_opts_collator}} with Collator's options,
  or \code{NA} for dummy Unicode code point comparison}
}
\value{
For \code{stri_order}, an integer vector that gives the
sort order is returned.

For \code{stri_order}, you get a sorted version of
\code{str}, i.e. a character vector.
}
\description{
\link{stri_order} determines a permutation which rearranges
strings into ascending or descending order.
\link{stri_sort} sorts the vector according to a
lexicographic order.
}
\details{
For more information on \pkg{ICU}'s Collator and how to
tune it up in \pkg{stringi}, refer to
\code{\link{stri_opts_collator}}.

Uses a stable sort algorithm (\pkg{STL}'s stable_sort);
performs up to \eqn{N*log^2(N)} element comparisons, where
\eqn{N} is the length of \code{str}.

Interestingly, \code{stri_order} is most often faster that
\R's \code{order}.

Missing values are always put at the end of a character
vector.

\code{stri_sort} is a `black sheep` in \pkg{stringi}: it
does not always return UTF-8-encoded strings. Moreover, it
preserves many input object's attributes. This is because
it is defined as \code{str[stri_order(str, decreasing,
opts_collator)]}.
}
\examples{
\dontrun{
stri_sort(c("hladny", "chladny"), opts_collator=stri_opts_collator(locale="pl_PL"))
stri_sort(c("hladny", "chladny"), opts_collator=stri_opts_collator(locale="sk_SK"))
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
\code{\link{stri_opts_collator}};
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

