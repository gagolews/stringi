\docType{package}
\name{stringi-package}
\alias{stringi-package}
\title{THE String Processing Package}
\description{
\pkg{stringi} is THE \R package for very fast, correct,
consistent, and convenient string/text manipulation in each
locale and any character encoding. We are putting great
effort to create software that works as you expect on any
platform, in each locale, and any ``native'' system
encoding.

\bold{Keywords}: internationalization, localization, ICU,
ICU4C, i18n, l10n, Unicode

\bold{Homepage}: \url{http://stringi.rexamine.com}

\bold{License}: The MIT license for the package code, the
ICU license for accompanying ICU4C distribution, and the
UCD license for the Unicode Character Database. See the
COPYRIGHTS and LICENSE file for more details.
}
\details{
Manual pages on general topics (must-read): \itemize{ \item
\link{stringi-encoding} -- character encoding issues,
including information on encoding management in
\pkg{stringi}, as well as on encoding detection,
conversion, and Unicode normalization.

\item \link{stringi-locale} -- locale issues, including
i.a. locale management and specification in \pkg{stringi},
and the list of locale-sensitive operations.  In
particular, see \code{\link{stri_opts_collator}} for a
description of the string collation algorithm, which is
used for string comparing, ordering, sorting, casefolding,
and searching.

\item \link{stringi-arguments} -- how \pkg{stringi} deals
with its functions' arguments. }
}
\section{Facilities available}{
  Refer to the following: \itemize{ \item
  \link{stringi-search} for string searching facilities;
  these include pattern searching, matching, string
  splitting, and so on. The following independent search
  engines are provided: \itemize{ \item
  \link{stringi-search-regex} -- with ICU (Java-like)
  regular expressions; \item \link{stringi-search-fixed} --
  Locale-aware or byte-exact fixed pattern searching; \item
  \link{stringi-search-charclass} -- for finding character
  classes, like ``all whitespaces'' or ``all digits''. }

  \item \code{\link{stri_stats_general}} and
  \code{\link{stri_stats_latex}} for gathering some
  statistics on a character vector's contents.

  \item \code{\link{stri_join}}, \code{\link{stri_dup}},
  and \code{\link{stri_flatten}} for concatenation-based
  operations.

  \item \code{\link{stri_sub}} for extracting and replacing
  substrings, and \code{\link{stri_reverse}} for a funny
  function to reverse all characters in a string.

  \item \code{\link{stri_trim}} (among others) for trimming
  characters from the beginning or/and end of a string, see
  also \link{stringi-search-charclass}.

  \item \code{\link{stri_length}} (among others) for
  determining the number of code points in a string.

  \item \code{\link{stri_trans_tolower}} (among others) for
  case mapping, i.e. conversion to lower, UPPER, or Title
  case.

  \item \code{\link{stri_compare}},
  \code{\link{stri_order}}, and \code{\link{stri_sort}} for
  comparison-based, locale-aware operations, see also
  \link{stringi-locale}.

  \item \code{\link{stri_split_lines}} (among others) to
  split a string into text lines.

  \item \code{\link{stri_escape_unicode}} (among others)
  for escaping certain code points.

  \item DRAFT API: \code{\link{stri_read_raw}},
  \code{\link{stri_read_lines}}, and
  \code{\link{stri_write_lines}} for reading and writing
  text files.

  \item TO DO [these will appear in future versions of
  \pkg{stringi}]: pad, wrap, justify, HTML entities,
  character translation, MIME Base 64 encode/decode, random
  string generation, number and data/time formatting, and
  many more. }

  Note that each man page has many links to other
  interesting facilities.
}
\author{
Marek Gagolewski \email{gagolews@rexamine.com},\cr Bartek
Tartanus \email{bartektartanus@rexamine.com},\cr with some
contributions from Marcin Bujarski at the early stage of
package development. ICU4C was developed by IBM and others.
The Unicode Character Database is due to Unicode, Inc.
}
\references{
\emph{\pkg{stringi} Package homepage},
\url{http://stringi.rexamine.com}

\emph{ICU -- International Components for Unicode},
\url{http://www.icu-project.org/}

\emph{ICU4C API Documentation},
\url{http://www.icu-project.org/apiref/icu4c/}

\emph{The Unicode Consortium},
\url{http://www.unicode.org/}

\emph{UTF-8, a transformation format of ISO 10646} -- RFC
3629, \url{http://tools.ietf.org/html/rfc3629}
}
\seealso{
Other stringi_general_topics:
\code{\link{stringi-arguments}};
\code{\link{stringi-encoding}};
\code{\link{stringi-locale}};
\code{\link{stringi-search-charclass}};
\code{\link{stringi-search-fixed}};
\code{\link{stringi-search-regex}};
\code{\link{stringi-search}}
}

