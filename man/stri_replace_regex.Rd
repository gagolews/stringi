\name{stri_replace_all_regex}
\alias{stri_replace_all_regex}
\alias{stri_replace_first_regex}
\alias{stri_replace_last_regex}
\title{Replace Occurrences of a Regex Pattern}
\usage{
stri_replace_all_regex(str, pattern, replacement, opts_regex = list())

stri_replace_first_regex(str, pattern, replacement, opts_regex = list())

stri_replace_last_regex(str, pattern, replacement, opts_regex = list())
}
\arguments{
  \item{str}{character vector of strings to search in}

  \item{pattern}{character vector of regular expressions}

  \item{replacement}{character vector of strings to replace
  with, possibly including references to capture groups}

  \item{opts_regex}{a named list as generated with
  \code{\link{stri_opts_regex}}}
}
\value{
character vector
}
\description{
Replaces with the given replacement string every/first/last
substring of the input that matches a regular expression
}
\details{
Vectorized over \code{str}, \code{pattern}, and
\code{replacement}.

These functions scan the input string for matches of the
pattern. Input that is not part of any match is left
unchanged; each match is replaced in the result by the
replacement string.

The replacement string may contain references to capture
groups (in round parentheses). References are of the form
\code{$n}, where \code{n} is the number of the capture
group (their numbering starts from 1).
}
\examples{
\dontrun{
s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
stri_replace_all_regex(s, " .*? ", "#")
stri_replace_all_regex(s, "(el|s)it", "1234")
stri_replace_all_regex('abaca', 'a', c('!', '*'))
stri_replace_all_regex('123|456|789', '(\\\\p{N}).(\\\\p{N})', '$2-$1')
stri_replace_all_regex(c("stringi w R","REXAMINE","123"), '( R|R.)', ' r ')
}
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
\code{\link{stri_split_regex}},
\code{\link{stri_split_regex}};
\code{\link{stringi-search-regex}};
\code{\link{stringi-search}}

Other search_replace:
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_last_charclass}},
\code{\link{stri_replace_last_charclass}};
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_last_fixed}},
\code{\link{stri_replace_last_fixed}};
\code{\link{stri_replace_all}};
\code{\link{stri_replace_first}};
\code{\link{stri_replace_last}};
\code{\link{stri_replace}}; \code{\link{stringi-search}}
}

