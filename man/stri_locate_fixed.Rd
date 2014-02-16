\name{stri_locate_all_fixed}
\alias{stri_locate_all_fixed}
\alias{stri_locate_all_fixed,}
\alias{stri_locate_first_fixed}
\alias{stri_locate_first_fixed,}
\alias{stri_locate_last_fixed}
\title{Locate Occurrences of a Fixed Pattern}
\usage{
stri_locate_all_fixed(str, pattern, opts_collator = list())

stri_locate_first_fixed(str, pattern, opts_collator = list())

stri_locate_last_fixed(str, pattern, opts_collator = list())
}
\arguments{
  \item{str}{character vector}

  \item{pattern}{character vector}

  \item{opts_collator}{a named list as generated with
  \code{\link{stri_opts_collator}} with Collator options,
  or \code{NA} for fast but locale-unaware byte comparison}
}
\value{
For \code{stri_locate_all_charclass}, a list of
\code{max(length(str), length(pattern))} integer matrices
is returned . The first column gives the start positions of
matches, and the second column gives the end position.
Moreover, you may gen two \code{NA}s in one row for no
match or \code{NA} arguments.

For \code{stri_locate_first_fixed} and
\code{stri_locate_last_fixed}, you get an integer matrix
with \code{max(length(str), length(pattern))} rows, and two
columns, giving the start and end positions of the first or
the last matches, respectively, and \code{NA}s iff not
found.
}
\description{
These functions find the indices, at which a given pattern
matches a substring of the input string.
}
\details{
Vectorized over \code{str} and \code{pattern}.

See \link{stringi-search-fixed} for more details on
Locale-Sensitive Text Searching in \pkg{stringi}.

Note the difference between \code{stri_locate_last_fixed}
and \code{\link{stri_locate_last_regex}} for overlapping
pattern matches. In \code{stri_locate_last_fixed}, search
is done from-the-end.

Pass \code{opts_collator} equal to \code{NA} for much
faster, but locale unaware, (exact) bitwise comparisons.
For a natural language text this may be not what you really
want.
}
\examples{
\dontrun{
stri_locate_all_fixed(c('AaaaaaaA', 'AAAA'), 'a')
stri_locate_first_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
stri_locate_last_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')

#first row is 1-2 like in locate_first
stri_locate_all_fixed('bbbbb', 'bb')
stri_locate_first_fixed('bbbbb', 'bb')
# but last row is 3-4, unlike in locate_last,
# keep this in mind [overlapping pattern match OK]!
stri_locate_last_fixed('bbbbb', 'bb')

locate <- stri_locate_first_fixed('stringi - REXAMINE', letters)
rownames(locate) <- letters
locate
}
}
\seealso{
Other indexing: \code{\link{stri_locate_all_charclass}},
\code{\link{stri_locate_all_charclass}},
\code{\link{stri_locate_first_charclass}},
\code{\link{stri_locate_first_charclass}},
\code{\link{stri_locate_last_charclass}},
\code{\link{stri_locate_last_charclass}};
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_last_regex}},
\code{\link{stri_locate_last_regex}};
\code{\link{stri_locate_all}};
\code{\link{stri_locate_first}};
\code{\link{stri_locate_last}}; \code{\link{stri_locate}};
\code{\link{stri_sub}}, \code{\link{stri_sub<-}}

Other locale_sensitive: \code{\link{stri_cmp}},
\code{\link{stri_compare}}; \code{\link{stri_count_fixed}};
\code{\link{stri_detect_fixed}};
\code{\link{stri_enc_detect2}};
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

Other search_fixed: \code{\link{stri_count_fixed}};
\code{\link{stri_detect_fixed}};
\code{\link{stri_extract_all_fixed}},
\code{\link{stri_extract_all_fixed,}},
\code{\link{stri_extract_first_fixed}},
\code{\link{stri_extract_first_fixed,}},
\code{\link{stri_extract_last_fixed}},
\code{\link{stri_extract_last_fixed}};
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

Other search_locate: \code{\link{stri_extract_all_fixed}},
\code{\link{stri_extract_all_fixed,}},
\code{\link{stri_extract_first_fixed}},
\code{\link{stri_extract_first_fixed,}},
\code{\link{stri_extract_last_fixed}},
\code{\link{stri_extract_last_fixed}};
\code{\link{stri_locate_all_charclass}},
\code{\link{stri_locate_all_charclass}},
\code{\link{stri_locate_first_charclass}},
\code{\link{stri_locate_first_charclass}},
\code{\link{stri_locate_last_charclass}},
\code{\link{stri_locate_last_charclass}};
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

