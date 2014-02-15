\name{stringi-search-fixed}
\alias{stringi-search-fixed}
\title{Locale-Sensitive Text Searching in \pkg{stringi}}
\description{
String searching facilities described in this very man page
provide a way to detect and extract a specific piece of
text. Note that locale-sensitive searching , especially on
a non-English language text, is a much more complex process
than one may think at the first glance.
}
\section{Locale-Aware String Search Engine}{
  By default, all \code{stri_*_fixed} functions in
  \pkg{stringi} utilize \pkg{ICU}'s \code{StringSearch}
  engine -- which is a language-aware string search
  algorithm. Note that a bitwise match will not give
  correct results in cases of: \enumerate{ \item accented
  letters; \item conjoined letters; \item ignorable
  punctuation; \item ignorable case. } The matches are
  defined using the notion of ``canonical equivalence''
  between strings.

  This string search engines uses a modified version of the
  Boyer-Moore algorithm (cf. Werner, 1999), with time
  complexity of O(n+p) (\code{n == length(str)}, \code{p ==
  length(pattern)}). According to the ICU User Guide, the
  Boyer-Moore searching algorithm is based on automata or
  combinatorial properties of strings and pre-processes the
  pattern and known to be much faster than the linear
  search when search pattern length is longer. The
  Boyer-Moore search is faster than the linear search when
  the pattern text is longer than 3 or 4 characters.

  Tuning the Collator's parameters allows you to perform
  correct matching that properly takes into account
  accented letters, conjoined letters, and ignorable
  punctuation and letter case.

  For more information on \pkg{ICU}'s Collator and
  SearchEngine and how to tune it up in \pkg{stringi},
  refer to \code{\link{stri_opts_collator}}.
}

\section{Byte Compare}{
  If \code{opts_collator} is \code{NA}, then a very fast
  (for small p) bitwise (locale independent) search is
  performed, with time complexity of O(n*p) (\code{n ==
  length(str)}, \code{p == length(pattern)}) [Naive
  implementation - to be upgraded in some future version of
  \pkg{stringi}]. For a natural language, non-English text
  this is, however, not what you probably want.

  You should note that, however, the conversion of input
  data to Unicode is done as usual.
}

\section{General Notes}{
  In all the functions, if a given fixed search
  \code{pattern} is empty, then the result is \code{NA} and
  a warning is generated.
}
\references{
\emph{ICU String Search Service} -- ICU User Guide,
\url{http://userguide.icu-project.org/collation/icu-string-search-service}

L. Werner, \emph{Efficient Text Searching in Java}, 1999,
\url{http://icu-project.org/docs/papers/efficient_text_searching_in_java.html}
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
\code{\link{stringi-locale}}

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
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_last_fixed}},
\code{\link{stri_replace_last_fixed}};
\code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stringi-search}}

Other stringi_general_topics:
\code{\link{stringi-arguments}};
\code{\link{stringi-encoding}};
\code{\link{stringi-locale}};
\code{\link{stringi-package}};
\code{\link{stringi-search-charclass}};
\code{\link{stringi-search-regex}};
\code{\link{stringi-search}}
}

