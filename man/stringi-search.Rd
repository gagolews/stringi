\name{stringi-search}
\alias{stringi-search}
\title{String Searching}
\description{
This man page explains how to perform string search-based
operations in \pkg{stringi}.
}
\details{
There are three independent string searching ``engines'' in
\pkg{stringi}. \itemize{ \item \code{stri_*_regex} --
\pkg{ICU}'s regular expressions, see
\link{stringi-search-regex}, \item \code{stri_*_fixed} --
\pkg{ICU}'s \code{StringSearch}, locale-sensitive ``fixed''
patterns search , see \link{stringi-search-fixed}, \item
\code{stri_*_charclass} -- character classes search: more
exactly, location of either Unicode General Categories or
Binary Properties, see \link{stringi-search-charclass}, }

Each ``engine'' is able to perform many search-based
operations: \itemize{ \item \code{stri_detect_*} - detects
if a pattern occurs in a string, see e.g.
\code{\link{stri_detect}}, \item \code{stri_count_*} -
counts the number of occurrences of text matching a
pattern, see e.g. \code{\link{stri_count}}, \item
\code{stri_locate_*} - locates all, first, or last
occurrences of a pattern, see e.g.
\code{\link{stri_locate}}, \item \code{stri_extract_*} -
extracts all, first, or last occurrences of a pattern, see
e.g. \code{\link{stri_extract}} and, in case of regexes,
\code{\link{stri_match}}, \item \code{stri_replace_*} -
replaces all, first, or last occurrences of a pattern, see
e.g. \code{\link{stri_replace}}, \item \code{stri_split_*}
- splits a string into chunks indicated by occurrences of a
pattern, see e.g. \code{\link{stri_split}}. }
}
\seealso{
Other search_charclass: \code{\link{stri_count_charclass}};
\code{\link{stri_detect_charclass}};
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_all_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_first_charclass}},
\code{\link{stri_extract_last_charclass}},
\code{\link{stri_extract_last_charclass}};
\code{\link{stri_locate_all_charclass}},
\code{\link{stri_locate_all_charclass}},
\code{\link{stri_locate_first_charclass}},
\code{\link{stri_locate_first_charclass}},
\code{\link{stri_locate_last_charclass}},
\code{\link{stri_locate_last_charclass}};
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_all_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_first_charclass}},
\code{\link{stri_replace_last_charclass}},
\code{\link{stri_replace_last_charclass}};
\code{\link{stri_split_charclass}},
\code{\link{stri_split_charclass}};
\code{\link{stri_trim}}, \code{\link{stri_trim}},
\code{\link{stri_trim_both}}, \code{\link{stri_trim_left}},
\code{\link{stri_trim_right}};
\code{\link{stringi-search-charclass}}

Other search_count: \code{\link{stri_count_charclass}};
\code{\link{stri_count_fixed}};
\code{\link{stri_count_regex}}; \code{\link{stri_count}}

Other search_detect: \code{\link{stri_detect_charclass}};
\code{\link{stri_detect_fixed}};
\code{\link{stri_detect_regex}}; \code{\link{stri_detect}}

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
\code{\link{stri_extract_last}}; \code{\link{stri_extract}}

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
\code{\link{stringi-search-fixed}}

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
\code{\link{stri_locate_all_fixed}},
\code{\link{stri_locate_all_fixed,}},
\code{\link{stri_locate_first_fixed}},
\code{\link{stri_locate_first_fixed,}},
\code{\link{stri_locate_last_fixed}},
\code{\link{stri_locate_last_fixed}};
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_last_regex}},
\code{\link{stri_locate_last_regex}};
\code{\link{stri_locate_all}};
\code{\link{stri_locate_first}};
\code{\link{stri_locate_last}}; \code{\link{stri_locate}}

Other search_match: \code{\link{stri_match_all_regex}},
\code{\link{stri_match_all_regex}},
\code{\link{stri_match_first_regex}},
\code{\link{stri_match_first_regex}},
\code{\link{stri_match_last_regex}},
\code{\link{stri_match_last_regex}};
\code{\link{stri_match_all}};
\code{\link{stri_match_first}};
\code{\link{stri_match_last}}; \code{\link{stri_match}}

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
\code{\link{stringi-search-regex}}

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
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_last_regex}},
\code{\link{stri_replace_last_regex}};
\code{\link{stri_replace_all}};
\code{\link{stri_replace_first}};
\code{\link{stri_replace_last}}; \code{\link{stri_replace}}

Other search_split: \code{\link{stri_split_charclass}},
\code{\link{stri_split_charclass}};
\code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stri_split_lines}},
\code{\link{stri_split_lines}},
\code{\link{stri_split_lines1}},
\code{\link{stri_split_lines1}};
\code{\link{stri_split_regex}},
\code{\link{stri_split_regex}}; \code{\link{stri_split}}

Other stringi_general_topics:
\code{\link{stringi-arguments}};
\code{\link{stringi-encoding}};
\code{\link{stringi-locale}};
\code{\link{stringi-package}};
\code{\link{stringi-search-charclass}};
\code{\link{stringi-search-fixed}};
\code{\link{stringi-search-regex}}
}

