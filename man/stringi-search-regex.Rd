\name{stringi-search-regex}
\alias{stringi-search-regex}
\title{Regular Expressions in \pkg{stringi}}
\description{
A regular expression is a pattern describing, possibly in a
very abstract way, a part of text. Thanks to many regex
functions in \pkg{stringi}, regular expressions may be a
very powerful tool in your hand to do string searching,
substring extraction, string splitting, etc.
}
\details{
All \code{stri_*_regex} functions in \pkg{stringi} use the
\pkg{ICU} regex engine, which settings may be tuned up (for
example to perform case-insensitive search) with the
\code{\link{stri_opts_regex}} function.

Regular expression patterns in \pkg{ICU} are quite similar
in form and behavior to Perl's regexes.  Their
implementation loosely bases on JDK 1.4 package
\code{java.util.regex}. \pkg{ICU} Regular Expressions
conform to the Unicode Technical Standard #18 (see
References section) and its features are summarized in the
ICU User Guide (see below). A good general introduction to
regexes is (Friedl, 2002). Some topics are also covered in
the \R manual, see \link{regex}.
}
\section{Regexes in \pkg{stringi}}{
  Note that if a given regex \code{pattern} is empty, then
  all functions in \pkg{stringi} give \code{NA} in result
  and generate a warning. On syntax error, a quite
  informative failure message is shown.

  If you would like to search for a fixed pattern, refer to
  \link{stringi-search-fixed}. This allows to do a
  locale-aware text lookup, or a very fast exact-byte
  search.
}
\references{
\emph{Regular expressions} -- ICU User Guide,
\url{http://userguide.icu-project.org/strings/regexp}

J.E.F. Friedl, \emph{Mastering Regular Expressions},
O'Reilly, 2002

\emph{Unicode Regular Expressions} -- Unicode Technical
Standard #18, \url{http://www.unicode.org/reports/tr18/}

\emph{Unicode Regular Expressions} -- Regex tutorial,
\url{http://www.regular-expressions.info/unicode.html}
}
\seealso{
Other search_regex: \code{\link{stri_count_regex}};
\code{\link{stri_detect_regex}};
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_last_regex}},
\code{\link{stri_extract_last_regex}};
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_last_regex}},
\code{\link{stri_locate_last_regex}};
\code{\link{stri_match_all_regex}},
\code{\link{stri_match_all_regex}},
\code{\link{stri_match_first_regex}},
\code{\link{stri_match_first_regex}},
\code{\link{stri_match_last_regex}},
\code{\link{stri_match_last_regex}};
\code{\link{stri_opts_regex}};
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_last_regex}},
\code{\link{stri_replace_last_regex}};
\code{\link{stri_split_regex}},
\code{\link{stri_split_regex}};
\code{\link{stringi-search}}

Other stringi_general_topics:
\code{\link{stringi-arguments}};
\code{\link{stringi-encoding}};
\code{\link{stringi-locale}};
\code{\link{stringi-package}};
\code{\link{stringi-search-charclass}};
\code{\link{stringi-search-fixed}};
\code{\link{stringi-search}}
}

