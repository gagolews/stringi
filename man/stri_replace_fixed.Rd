\name{stri_replace_all_fixed}
\alias{stri_replace_all_fixed}
\alias{stri_replace_first_fixed}
\alias{stri_replace_last_fixed}
\title{Replace Occurrences of a Fixed Pattern}
\usage{
stri_replace_all_fixed(str, pattern, replacement, opts_collator = list())

stri_replace_first_fixed(str, pattern, replacement, opts_collator = list())

stri_replace_last_fixed(str, pattern, replacement, opts_collator = list())
}
\arguments{
  \item{str}{character vector of strings to search in}

  \item{pattern}{character vector of patterns to search
  for}

  \item{replacement}{character vector of strings to replace
  with}

  \item{opts_collator}{a named list as generated with
  \code{\link{stri_opts_collator}} with Collator options,
  or \code{NA} for fast but locale-unaware byte comparison}
}
\value{
character vector
}
\description{
Replaces with the given replacement string every/first/last
substring of the input that matches the pattern.
}
\details{
Vectorized over \code{str}, \code{pattern}, and
\code{replacement}.

These functions scan the input string for matches of the
pattern. Input that is not part of any match is left
unchanged; each match is replaced in the result by the
replacement string.

Pass \code{opts_collator} equal to \code{NA} for much
faster, but locale unaware, (exact) byte comparisons. For
natural language text this may be not what you really want.
}
\examples{
\dontrun{
s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
stri_replace_all_fixed(s," ","#")
stri_replace_all_fixed(s,"o","0")
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
\code{\link{stri_sort}}; \code{\link{stri_split_fixed}},
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
\code{\link{stri_locate_all_fixed}},
\code{\link{stri_locate_all_fixed,}},
\code{\link{stri_locate_first_fixed}},
\code{\link{stri_locate_first_fixed,}},
\code{\link{stri_locate_last_fixed}},
\code{\link{stri_locate_last_fixed}};
\code{\link{stri_opts_collator}};
\code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stringi-search-fixed}};
\code{\link{stringi-search}}

Other search_replace:
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_last_charclass}},
\code{\link{stri_replace_last_charclass}};
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_last_regex}},
\code{\link{stri_replace_last_regex}};
\code{\link{stri_replace_all}};
\code{\link{stri_replace_first}};
\code{\link{stri_replace_last}};
\code{\link{stri_replace}}; \code{\link{stringi-search}}
}

