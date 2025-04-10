% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/search.R
\name{about_search_coll}
\alias{about_search_coll}
\alias{search_coll}
\alias{stringi-search-coll}
\title{Locale-Sensitive Text Searching in \pkg{stringi}}
\description{
String searching facilities described here
provide a way to locate a specific piece of
text. Interestingly, locale-sensitive searching, especially
on a non-English text, is a much more complex process
than it seems at first glance.
}
\section{Locale-Aware String Search Engine}{


All \code{stri_*_coll} functions in \pkg{stringi} use
\pkg{ICU}'s \code{StringSearch} engine,
which implements a locale-sensitive string search algorithm.
The matches are defined by using the notion of ``canonical equivalence''
between strings.

Tuning the Collator's parameters allows you to perform correct matching
that properly takes into account accented letters, conjoined letters,
ignorable punctuation and letter case.

For more information on \pkg{ICU}'s Collator and the search engine
and how to tune it up
in \pkg{stringi}, refer to \code{\link{stri_opts_collator}}.

Please note that \pkg{ICU}'s \code{StringSearch}-based functions
are often much slower that those to perform fixed pattern searches.
}

\references{
\emph{ICU String Search Service} -- ICU User Guide,
\url{https://unicode-org.github.io/icu/userguide/collation/string-search.html}

L. Werner, \emph{Efficient Text Searching in Java}, 1999,
\url{https://icu-project.org/docs/papers/efficient_text_searching_in_java.html}
}
\seealso{
The official online manual of \pkg{stringi} at \url{https://stringi.gagolewski.com/}

Gagolewski M., \pkg{stringi}: Fast and portable character string processing in R, \emph{Journal of Statistical Software} 103(2), 2022, 1-59, \doi{10.18637/jss.v103.i02}

Other search_coll: 
\code{\link{about_search}},
\code{\link{stri_opts_collator}()}

Other locale_sensitive: 
\code{\link{\%s<\%}()},
\code{\link{about_locale}},
\code{\link{about_search_boundaries}},
\code{\link{stri_compare}()},
\code{\link{stri_count_boundaries}()},
\code{\link{stri_duplicated}()},
\code{\link{stri_enc_detect2}()},
\code{\link{stri_extract_all_boundaries}()},
\code{\link{stri_locate_all_boundaries}()},
\code{\link{stri_opts_collator}()},
\code{\link{stri_order}()},
\code{\link{stri_rank}()},
\code{\link{stri_sort}()},
\code{\link{stri_sort_key}()},
\code{\link{stri_split_boundaries}()},
\code{\link{stri_trans_tolower}()},
\code{\link{stri_unique}()},
\code{\link{stri_wrap}()}

Other stringi_general_topics: 
\code{\link{about_arguments}},
\code{\link{about_encoding}},
\code{\link{about_locale}},
\code{\link{about_search}},
\code{\link{about_search_boundaries}},
\code{\link{about_search_charclass}},
\code{\link{about_search_fixed}},
\code{\link{about_search_regex}},
\code{\link{stringi-package}}
}
\concept{locale_sensitive}
\concept{search_coll}
\concept{stringi_general_topics}
\author{
\href{https://www.gagolewski.com/}{Marek Gagolewski} and other contributors
}
