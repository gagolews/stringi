\name{stri_extract_words}
\alias{stri_extract_words}
\title{Extract Words from a Text}
\usage{
stri_extract_words(str, locale = NULL)
}
\arguments{
  \item{str}{character vector or an object coercible to}

  \item{locale}{\code{NULL} or \code{""} for text boundary
  analysis following the conventions of the default locale,
  or a single string with locale identifier, see
  \link{stringi-locale}.}
}
\value{
A list of character vectors is returned. Each string
consists of a separate word.
}
\description{
This function extracts all words from each string.
}
\details{
Vectorized over \code{str}.

Just like in \code{\link{stri_locate_words}}, \pkg{ICU}'s
word \code{BreakIterator} iterator is used to locate word
boundaries, and all non-word characters
(\code{UBRK_WORD_NONE} rule status) are ignored.
}
\examples{
\dontrun{
stri_extract_words("stringi: THE string processing package 123.48...")
}
}
\references{
\emph{Boundary Analysis} -- ICU User Guide,
\url{http://userguide.icu-project.org/boundaryanalysis}
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
\code{\link{stri_locate_boundaries}};
\code{\link{stri_locate_words}};
\code{\link{stri_opts_collator}}; \code{\link{stri_order}},
\code{\link{stri_sort}};
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_last_fixed}},
\code{\link{stri_replace_last_fixed}};
\code{\link{stri_split_boundaries}};
\code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stri_trans_tolower}},
\code{\link{stri_trans_totitle}},
\code{\link{stri_trans_toupper}};
\code{\link{stri_unique}}; \code{\link{stringi-locale}};
\code{\link{stringi-search-fixed}}

Other search_extract:
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_last_charclass}},
\code{\link{stri_extract_last_charclass}};
\code{\link{stri_extract_all_fixed}},
\code{\link{stri_extract_all_fixed,}},
\code{\link{stri_extract_first_fixed}},
\code{\link{stri_extract_first_fixed,}},
\code{\link{stri_extract_last_fixed}},
\code{\link{stri_extract_last_fixed}};
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

Other text_boundaries:
\code{\link{stri_locate_boundaries}};
\code{\link{stri_locate_words}};
\code{\link{stri_split_boundaries}}
}

