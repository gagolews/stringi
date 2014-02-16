\name{stri_opts_regex}
\alias{stri_opts_regex}
\title{Generate a List with Regex Matcher Options}
\usage{
stri_opts_regex(case_insensitive, comments, dotall, literal, multiline,
  unix_lines, uword, error_on_unknown_escapes)
}
\arguments{
  \item{case_insensitive}{logical; enable case insensitive
  matching}

  \item{comments}{logical; allow white space and comments
  within patterns}

  \item{dotall}{logical; if set, `\code{.}` matches line
  terminators, otherwise matching of `\code{.}` stops at a
  line end}

  \item{literal}{logical; if set, treat the entire pattern
  as a literal string: metacharacters or escape sequences
  in the input sequence will be given no special meaning;
  note that in most cases you would rather use the
  \link{stringi-search-fixed} facilities in this case (with
  \code{opts_collator=NA}).}

  \item{multiline}{logical; controls the behavior of
  `\code{$}` and `\code{^}`. If set, recognize line
  terminators within a string, otherwise, match only at
  start and end of input string}

  \item{unix_lines}{logical; Unix-only line endings. When
  this mode is enabled, only \code{U+000a} is recognized as
  a line ending by `\code{.}`, `\code{$}`, and `\code{^}`.}

  \item{uword}{logical; Unicode word boundaries. If set,
  uses the Unicode TR 29 definition of word boundaries;
  warning: Unicode word boundaries are quite different from
  traditional regex word boundaries. See
  \url{http://unicode.org/reports/tr29/#Word_Boundaries}}

  \item{error_on_unknown_escapes}{logical; whether to
  generate an error on unrecognized backslash escapes; if
  set, fail with an error on patterns that contain
  backslash-escaped ASCII letters without a known special
  meaning; otherwise, these escaped letters represent
  themselves.

  Note that some regex options may be changed using ICU
  regex flag settings inside regexes. For example,
  \code{"(?i)pattern"} does a case-insensitive match of a
  given pattern, see the ICU User Guide entry on Regular
  Expressions in the References section.}
}
\value{
Returns a named list object; missing options are left with
default values.
}
\description{
A convenience function to tune regular expressions matcher
behavior, e.g. in \code{\link{stri_count_regex}} and other
\link{stringi-search-regex} functions.
}
\examples{
\dontrun{
stri_detect_regex("ala", "ALA") # case-sensitive by default
stri_detect_regex("ala", "ALA", stri_opts_regex(case_insensitive=TRUE))
stri_detect_regex("ala", "(?i:)ALA") # equivalent
}
}
\references{
\emph{\code{enum URegexpFlag}: Constants for Regular
Expression Match Modes} -- ICU4C API Documentation,
\url{http://www.icu-project.org/apiref/icu4c/uregex_8h.html}

\emph{Regular Expressions} -- ICU User Guide,
\url{http://userguide.icu-project.org/strings/regexp}
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
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_last_regex}},
\code{\link{stri_replace_last_regex}};
\code{\link{stri_split_regex}},
\code{\link{stri_split_regex}};
\code{\link{stringi-search-regex}};
\code{\link{stringi-search}}
}

