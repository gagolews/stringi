# kate: default-dictionary en_US

## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2025, Marek Gagolewski <https://www.gagolewski.com/>
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## 1. Redistributions of source code must retain the above copyright notice,
## this list of conditions and the following disclaimer.
##
## 2. Redistributions in binary form must reproduce the above copyright notice,
## this list of conditions and the following disclaimer in the documentation
## and/or other materials provided with the distribution.
##
## 3. Neither the name of the copyright holder nor the names of its
## contributors may be used to endorse or promote products derived from
## this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
## 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
## BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
## FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
## HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
## PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
## OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
## WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
## OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
## EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#' @title String Searching
#'
#' @description
#' This man page explains how to perform string search-based
#' operations in \pkg{stringi}.
#'
#' @details
#' The following independent string searching engines are available
#' in \pkg{stringi}.
#' \itemize{
#'    \item \code{stri_*_regex} -- \pkg{ICU}'s regular expressions (regexes),
#'         see \link{about_search_regex},
#'    \item \code{stri_*_fixed} -- locale-independent byte-wise pattern matching,
#'        see \link{about_search_fixed},
#'    \item \code{stri_*_coll} -- \pkg{ICU}'s \code{StringSearch},
#'        locale-sensitive, Collator-based pattern search,
#'        useful for natural language processing tasks,
#'        see \link{about_search_coll},
#'    \item \code{stri_*_charclass} -- character classes search,
#'       e.g., Unicode General Categories or Binary Properties,
#'        see \link{about_search_charclass},
#'    \item \code{stri_*_boundaries} -- text boundary analysis,
#'       see \link{about_search_boundaries}
#' }
#'
#' Each search engine is able to perform many search-based operations.
#' These may include:
#' \itemize{
#'    \item \code{stri_detect_*} - detect if a pattern occurs in a string,
#'    see, e.g., \code{\link{stri_detect}},
#'    \item \code{stri_count_*} - count the number of pattern occurrences,
#'    see, e.g., \code{\link{stri_count}},
#'    \item \code{stri_locate_*} - locate all, first, or last occurrences
#'    of a pattern, see, e.g., \code{\link{stri_locate}},
#'    \item \code{stri_extract_*} - extract all, first, or last occurrences
#'    of a pattern, see, e.g., \code{\link{stri_extract}}
#'    and, in case of regexes, \code{\link{stri_match}},
#'    \item \code{stri_replace_*} - replace all, first, or last occurrences
#'    of a pattern, see, e.g., \code{\link{stri_replace}}
#'    and also \code{\link{stri_trim}},
#'    \item \code{stri_split_*} - split a string into chunks indicated
#'    by occurrences of a pattern,
#'    see, e.g., \code{\link{stri_split}},
#'    \item \code{stri_startswith_*} and \code{stri_endswith_*} detect
#'    if a string starts or ends with a pattern match, see,
#'    e.g., \code{\link{stri_startswith}},
#'    \item \code{stri_subset_*} - return a subset of a character vector
#'    with strings that match a given pattern, see, e.g., \code{\link{stri_subset}}.
#' }
#'
#' @name about_search
#' @rdname about_search
#' @aliases about_search search stringi-search
#' @family text_boundaries
#' @family search_regex
#' @family search_fixed
#' @family search_coll
#' @family search_charclass
#' @family search_detect
#' @family search_count
#' @family search_locate
#' @family search_replace
#' @family search_split
#' @family search_subset
#' @family search_extract
#' @family search_in
#' @family stringi_general_topics
invisible(NULL)


#' @title
#' Regular Expressions in \pkg{stringi}
#'
#' @description
#' A regular expression is a pattern describing, possibly in a very
#' abstract way, a text fragment.
#' With so many regex functions in \pkg{stringi},
#' regular expressions may be a very powerful tool
#' to perform string searching, substring extraction, string splitting, etc.,
#' tasks.
#'
#'
#' @details
#' All \code{stri_*_regex} functions in \pkg{stringi} use
#' the \pkg{ICU} regex engine. Its settings may be tuned up (for example
#' to perform case-insensitive search) via the
#' \code{\link{stri_opts_regex}} function.
#'
#'
#' Regular expression patterns in \pkg{ICU} are quite similar in form and
#' behavior to Perl's regexes. Their implementation is loosely inspired
#' by JDK 1.4 \code{java.util.regex}.
#' \pkg{ICU} Regular Expressions conform to the Unicode Technical Standard #18
#' (see References section) and its features are summarized in
#' the ICU User Guide (see below). A good general introduction
#' to regexes is (Friedl, 2002).
#' Some general topics are also covered in the \R manual, see \link{regex}.
#'
#' @section \pkg{ICU} Regex Operators at a Glance:
#'
#' Here is a list of operators provided by the
#' ICU User Guide on regexes.
#'
#' \describe{
#' \item{\code{|}}{Alternation. \code{A|B} matches either A or B.}
#' \item{\code{*}}{Match 0 or more times. Match as many times as possible.}
#' \item{\code{+}}{Match 1 or more times. Match as many times as possible.}
#' \item{\code{?}}{Match zero or one times. Prefer one.}
#' \item{\code{{n}} }{Match exactly n times.}
#' \item{\code{{n,}} }{Match at least n times. Match as many times as possible.}
#' \item{\code{{n,m}} }{Match between n and m times.
#' Match as many times as possible, but not more than m.}
#' \item{\code{*?}}{Match 0 or more times. Match as few times as possible.}
#' \item{\code{+?}}{Match 1 or more times. Match as few times as possible.}
#' \item{\code{??}}{Match zero or one times. Prefer zero.}
#' \item{\code{{n}?}}{Match exactly n times.}
#' \item{\code{{n,}?}}{Match at least n times, but no more than required
#' for an overall pattern match.}
#' \item{\code{{n,m}?}}{Match between n and m times. Match as few times
#' as possible, but not less than n.}
#' \item{\code{*+}}{Match 0 or more times. Match as many times as possible
#' when first encountered, do not retry with fewer even if overall match fails
#' (Possessive Match).}
#' \item{\code{++}}{Match 1 or more times. Possessive match.}
#' \item{\code{?+}}{Match zero or one times. Possessive match.}
#' \item{\code{{n}+}}{Match exactly n times.}
#' \item{\code{{n,}+}}{Match at least n times. Possessive Match.}
#' \item{\code{{n,m}+}}{Match between n and m times. Possessive Match.}
#' \item{\code{(...)}}{Capturing parentheses. Range of input that matched
#' the parenthesized sub-expression is available after the match,
#' see \code{\link{stri_match}}.}
#' \item{\code{(?:...)}}{Non-capturing parentheses. Groups the included pattern,
#' but does not provide capturing of matching text. Somewhat more efficient
#' than capturing parentheses.}
#' \item{\code{(?>...)}}{Atomic-match parentheses. The first match of the
#' parenthesized sub-expression is the only one tried; if it does not lead to
#' an overall pattern match, back up the search for a match to a position
#' before the \code{(?>}.}
#' \item{\code{(?#...)}}{Free-format comment \code{(?# comment )}.}
#' \item{\code{(?=...)}}{Look-ahead assertion. True if the parenthesized
#' pattern matches at the current input position, but does not advance
#' the input position.}
#' \item{\code{(?!...)}}{Negative look-ahead assertion. True if the
#' parenthesized pattern does not match at the current input position.
#' Does not advance the input position.}
#' \item{\code{(?<=...)}}{Look-behind assertion. True if the parenthesized
#' pattern matches text preceding the current input position, with the last
#' character of the match being the input character just before the current
#' position. Does not alter the input position. The length of possible strings
#' matched by the look-behind pattern must not be unbounded (no \code{*}
#' or \code{+} operators.)}
#' \item{\code{(?<!...)}}{Negative Look-behind assertion. True if the
#' parenthesized pattern does not match text preceding the current input
#' position, with the last character of the match being the input character
#' just before the current position. Does not alter the input position.
#' The length of possible strings matched by the look-behind pattern must
#' not be unbounded (no \code{*} or \code{+} operators.)}
#' \item{\code{(?<name>...)}}{Named capture group, where \code{name}
#'     (enclosed within the angle brackets)
#'     is a sequence like \code{[A-Za-z][A-Za-z0-9]*}}
#' \item{\code{(?ismwx-ismwx:...)}}{Flag settings. Evaluate the parenthesized
#' expression with the specified flags enabled or \code{-}disabled,
#' see also \code{\link{stri_opts_regex}}.}
#' \item{\code{(?ismwx-ismwx)}}{Flag settings. Change the flag settings.
#' Changes apply to the portion of the pattern following the setting.
#' For example, \code{(?i)} changes to a case insensitive match,
#' see also \code{\link{stri_opts_regex}}.}
#' }
#'
#'
#' @section \pkg{ICU} Regex Meta-characters at a Glance:
#'
#' Here is a list of meta-characters provided by the
#' ICU User Guide on regexes.
#'
#' \describe{
#' \item{\code{\\a}}{Match a BELL, \code{\\u0007}.}
#' \item{\code{\\A}}{Match at the beginning of the input. Differs from \code{^}.
#'    in that \code{\\A} will not match after a new line within the input.}
#' \item{\code{\\b}}{Match if the current position is a word boundary.
#'    Boundaries occur at the transitions between word (\code{\\w}) and non-word
#'    (\code{\\W}) characters, with combining marks ignored. For better word
#'    boundaries, see \pkg{ICU} Boundary Analysis, e.g., \code{\link{stri_extract_all_words}}.}
#' \item{\code{\\B}}{Match if the current position is not a word boundary.}
#' \item{\code{\\cX}}{Match a control-\code{X} character.}
#' \item{\code{\\d}}{Match any character with the Unicode General Category of
#'    \code{Nd} (Number, Decimal Digit.).}
#' \item{\code{\\D}}{Match any character that is not a decimal digit.}
#' \item{\code{\\e}}{Match an ESCAPE, \code{\\u001B}.}
#' \item{\code{\\E}}{Terminates a \code{\\Q} ... \code{\\E} quoted sequence.}
#' \item{\code{\\f}}{Match a FORM FEED, \code{\\u000C}.}
#' \item{\code{\\G}}{Match if the current position is at the end of the
#'    previous match.}
#' \item{\code{\\h}}{Match a Horizontal White Space character.
#'    They are characters with Unicode General Category of Space_Separator plus
#'    the ASCII tab, \code{\\u0009}. [Since ICU 55]}
#' \item{\code{\\H}}{Match a non-Horizontal White Space character.
#'    [Since ICU 55]}
#' \item{\code{\\k<name>}}{Named Capture Back Reference. [Since ICU 55]}
#' \item{\code{\\n}}{Match a LINE FEED, \code{\\u000A}.}
#' \item{\code{\\N{UNICODE CHARACTER NAME}} }{Match the named character.}
#' \item{\code{\\p{UNICODE PROPERTY NAME}} }{Match any character with the
#'    specified Unicode Property.}
#' \item{\code{\\P{UNICODE PROPERTY NAME}} }{Match any character not having
#'    the specified Unicode Property.}
#' \item{\code{\\Q}}{Quotes all following characters until \code{\\E}.}
#' \item{\code{\\r}}{Match a CARRIAGE RETURN, \code{\\u000D}.}
#' \item{\code{\\s}}{Match a white space character. White space is defined
#'    as \code{[\\t\\n\\f\\r\\p{Z}]}.}
#' \item{\code{\\S}}{Match a non-white space character.}
#' \item{\code{\\t}}{Match a HORIZONTAL TABULATION, \code{\\u0009}.}
#' \item{\code{\\uhhhh}}{Match the character with the hex value \code{hhhh}.}
#' \item{\code{\\Uhhhhhhhh}}{Match the character with the hex value \code{hhhhhhhh}.
#'    Exactly eight hex digits must be provided, even though the largest
#'    Unicode code point is \code{\\U0010ffff}.}
#' \item{\code{\\w}}{Match a word character. Word characters are
#'    \code{[\\p{Alphabetic}\\p{Mark}\\p{Decimal_Number}\\p{Connector_Punctuation}\\u200c\\u200d]}.}
#' \item{\code{\\W}}{Match a non-word character.}
#' \item{\code{\\x{hhhh}} }{Match the character with hex value hhhh.
#' From one to six hex digits may be supplied.}
#' \item{\code{\\xhh}}{Match the character with two digit hex value hh }
#' \item{\code{\\X}}{Match a Grapheme Cluster.}
#' \item{\code{\\Z}}{Match if the current position is at the end of input,
#'  but before the final line terminator, if one exists.}
#' \item{\code{\\z}}{Match if the current position is at the end of input.}
#' \item{\code{\\n}}{Back Reference. Match whatever the nth capturing
#' group matched. n must be a number > 1 and < total number of capture
#' groups in the pattern.}
#' \item{\code{\\0ooo}}{Match an Octal character.  \code{'ooo'} is from one to three
#' octal digits.  0377 is the largest allowed Octal character.  The leading
#' zero is required; it distinguishes Octal constants from back references.}
#' \item{\code{[pattern]}}{Match any one character from the set.}
#' \item{\code{.}}{Match any character except for - by default - newline, compare \code{\link{stri_opts_regex}}.}
#' \item{\code{^}}{Match at the beginning of a line.}
#' \item{\code{$}}{Match at the end of a line.}
#' \item{\code{\\}}{[outside of sets] Quotes the following character.
#' Characters that must be quoted to be treated as literals are
#'    \code{* ? + [ ( ) { } ^ $ | \\ .}.}
#' \item{\code{\\}}{[inside sets] Quotes the following character.
#'    Characters that must be quoted to be treated as literals are
#'    \code{[ ] \\}; Characters that may need to be quoted, depending
#'    on the context are \code{- &}.}
#' }
#'
#' @section Character Classes:
#'
#' The syntax is similar, but not 100\% compatible with the one
#' described in \link{about_search_charclass}. In particular,
#' whitespaces are not ignored and set-theoretic operations are
#' denoted slightly differently. However, other than this
#' \link{about_search_charclass} is a good reference
#' on the capabilities offered.
#'
#' The ICU User Guide on regexes lists what follows.
#'
#' \describe{
#' \item{\code{[abc]}}{Match any of the characters a, b, or c}
#' \item{\code{[^abc]}}{Negation -- match any character except a, b, or c}
#' \item{\code{[A-M]}}{Range -- match any character from A to M (based on Unicode code point ordering)}
#' \item{\code{[\\p{L}]}, \code{[\\p{Letter}]}, \code{[\\p{General_Category=Letter}]}, \code{[:letter:]}}{Characters with Unicode Category = Letter (4 equivalent forms)}
#' \item{\code{[\\P{Letter}]}}{Negated property -- natch everything except Letters}
#' \item{\code{[\\p{numeric_value=9}]}}{Match all numbers with a numeric value of 9}
#' \item{\code{[\\p{Letter}&&\\p{script=cyrillic}]}}{Intersection; match the set of all Cyrillic letters}
#' \item{\code{[\\p{Letter}--\\p{script=latin}]}}{Set difference; match all non-Latin letters}
#' \item{\code{[[a-z][A-Z][0-9]]}, \code{[a-zA-Z0-9]}}{Union; match ASCII letters and digits (2 equivalent forms)}
#' }
#'
#'
#' @section Regex Functions in \pkg{stringi}:
#'
#' Note that if a given regex \code{pattern} is empty,
#' then all the functions in \pkg{stringi} give \code{NA} in result
#' and generate a warning.
#' On a syntax error, a quite informative failure message is shown.
#'
#' If you wish to search for a fixed pattern,
#' refer to \link{about_search_coll} or \link{about_search_fixed}.
#' They allow to perform a locale-aware text lookup,
#' or a very fast exact-byte search, respectively.
#'
#'
#'
#' @references
#' \emph{Regular expressions} -- ICU User Guide,
#' \url{https://unicode-org.github.io/icu/userguide/strings/regexp.html}
#'
#' J.E.F. Friedl, \emph{Mastering Regular Expressions}, O'Reilly, 2002
#'
#' \emph{Unicode Regular Expressions} -- Unicode Technical Standard #18,
#' \url{https://www.unicode.org/reports/tr18/}
#'
#' \emph{Unicode Regular Expressions} -- Regex tutorial,
#' \url{https://www.regular-expressions.info/unicode.html}
#'
#' @name about_search_regex
#' @rdname about_search_regex
#' @aliases about_search_regex search_regex stringi-search-regex
#' @family search_regex
#' @family stringi_general_topics
invisible(NULL)


#' @title
#' Locale-Insensitive Fixed Pattern Matching in \pkg{stringi}
#'
#' @description
#' String searching facilities described here
#' provide a way to locate a specific sequence of bytes in a string.
#' The search engine's settings may be tuned up (for example
#' to perform case-insensitive search) via a call to the
#' \code{\link{stri_opts_fixed}} function.
#'
#'
#' @section Byte Compare:
#'
#' The fast Knuth-Morris-Pratt search algorithm, with worst time complexity of
#' O(n+p) (\code{n == length(str)}, \code{p == length(pattern)})
#' is implemented (with some tweaks for very short search patterns).
#'
#' Be aware that, for natural language processing,
#' fixed pattern searching might not be what
#' you actually require. It is because a bitwise match will
#' not give correct results in cases of:
#' \enumerate{
#' \item accented letters;
#' \item conjoined letters;
#' \item ignorable punctuation;
#' \item ignorable case,
#' }
#' see also \link{about_search_coll}.
#'
#' Note that the conversion of input data
#' to Unicode is done as usual.
#'
#' @name about_search_fixed
#' @rdname about_search_fixed
#' @aliases about_search_fixed search_fixed stringi-search-fixed
#' @family search_fixed
#' @family stringi_general_topics
invisible(NULL)


#' @title
#' Locale-Sensitive Text Searching in \pkg{stringi}
#'
#' @description
#' String searching facilities described here
#' provide a way to locate a specific piece of
#' text. Interestingly, locale-sensitive searching, especially
#' on a non-English text, is a much more complex process
#' than it seems at first glance.
#'
#'
#'
#' @section Locale-Aware String Search Engine:
#'
#' All \code{stri_*_coll} functions in \pkg{stringi} use
#' \pkg{ICU}'s \code{StringSearch} engine,
#' which implements a locale-sensitive string search algorithm.
#' The matches are defined by using the notion of ``canonical equivalence''
#' between strings.
#'
#' Tuning the Collator's parameters allows you to perform correct matching
#' that properly takes into account accented letters, conjoined letters,
#' ignorable punctuation and letter case.
#'
#' For more information on \pkg{ICU}'s Collator and the search engine
#' and how to tune it up
#' in \pkg{stringi}, refer to \code{\link{stri_opts_collator}}.
#'
#' Please note that \pkg{ICU}'s \code{StringSearch}-based functions
#' are often much slower that those to perform fixed pattern searches.
#'
#'
#' @references
#' \emph{ICU String Search Service} -- ICU User Guide,
#' \url{https://unicode-org.github.io/icu/userguide/collation/string-search.html}
#'
#' L. Werner, \emph{Efficient Text Searching in Java}, 1999,
#' \url{https://icu-project.org/docs/papers/efficient_text_searching_in_java.html}
#'
#' @name about_search_coll
#' @rdname about_search_coll
#' @aliases about_search_coll search_coll stringi-search-coll
#' @family search_coll
#' @family locale_sensitive
#' @family stringi_general_topics
invisible(NULL)


#' @title Character Classes in \pkg{stringi}
#'
#' @description
#' Here we describe how character classes (sets) can be specified
#' in the \pkg{stringi} package. These are useful for defining
#' search patterns (note that the \pkg{ICU} regex engine uses the same
#' scheme for denoting character classes) or, e.g.,
#' generating random code points with \code{\link{stri_rand_strings}}.
#'
#'
#' @details
#' All \code{stri_*_charclass} functions in \pkg{stringi} perform
#' a single character (i.e., Unicode code point) search-based operations.
#' You may obtain the same results using \link{about_search_regex}.
#' However, these very functions aim to be faster.
#'
#' Character classes are defined using \pkg{ICU}'s \code{UnicodeSet}
#' patterns. Below we briefly summarize their syntax.
#' For more details refer to the bibliographic References below.
#'
#'
#' @section \code{UnicodeSet} patterns:
#'
#' A \code{UnicodeSet} represents a subset of Unicode code points
#' (recall that \pkg{stringi} converts strings in your native encoding
#' to Unicode automatically). Legal code points are U+0000 to U+10FFFF,
#' inclusive.
#'
#' Patterns either consist of series of characters  bounded by
#' square brackets
#' (such patterns follow a syntax similar to that employed
#' by regular expression character classes)
#' or of Perl-like Unicode property set specifiers.
#'
#' \code{[]} denotes an empty set, \code{[a]} --
#' a set consisting of character ``a'',
#' \code{[\\u0105]} -- a set with character U+0105,
#' and \code{[abc]} -- a set with ``a'', ``b'', and ``c''.
#'
#' \code{[a-z]} denotes a set consisting of characters
#' ``a'' through ``z'' inclusively, in Unicode code point order.
#'
#' Some set-theoretic operations are available.
#' \code{^} denotes the complement, e.g., \code{[^a-z]} contains
#' all characters but ``a'' through ``z''.
#' Moreover, \code{[[pat1][pat2]]},
#' \code{[[pat1]\&[pat2]]}, and \code{[[pat1]-[pat2]]}
#' denote union, intersection, and asymmetric difference of sets
#' specified by \code{pat1} and \code{pat2}, respectively.
#'
#' Note that all white-spaces are ignored unless they are quoted or back-slashed
#' (white spaces can be freely used for clarity, as \code{[a c d-f m]}
#' means the same as \code{[acd-fm]}).
#' \pkg{stringi} does not allow including multi-character strings
#' (see \code{UnicodeSet} API documentation).
#' Also, empty string patterns are disallowed.
#'
#' Any character may be preceded by
#' a backslash in order to remove its special meaning.
#'
#' A malformed pattern always results in an error.
#'
#' Set expressions at a glance
#' (according to \url{https://unicode-org.github.io/icu/userguide/strings/regexp.html}):
#'
#'
#' Some examples:
#'
#' \describe{
#' \item{\code{[abc]}}{Match any of the characters a, b or c.}
#' \item{\code{[^abc]}}{Negation -- match any character except a, b or c.}
#' \item{\code{[A-M]}}{Range -- match any character from A to M. The characters
#'    to include are determined by Unicode code point ordering.}
#' \item{\code{[\\u0000-\\U0010ffff]}}{Range -- match all characters.}
#' \item{\code{[\\p{Letter}]} or \code{[\\p{General_Category=Letter}]} or \code{[\\p{L}]}}{
#'    Characters with Unicode Category = Letter. All forms shown are equivalent.}
#' \item{\code{[\\P{Letter}]}}{Negated property
#'    (Note the upper case \code{\\P}) -- match everything except Letters.}
#' \item{\code{[\\p{numeric_value=9}]}}{Match all numbers with a numeric value of 9.
#'    Any Unicode Property may be used in set expressions.}
#' \item{\code{[\\p{Letter}&\\p{script=cyrillic}]}}{Set
#'     intersection -- match the set of all Cyrillic letters.}
#' \item{\code{[\\p{Letter}-\\p{script=latin}]}}{Set difference --
#'    match all non-Latin letters.}
#' \item{\code{[[a-z][A-Z][0-9]]} or \code{[a-zA-Z0-9]}}{Implicit union of
#'    sets -- match ASCII letters and digits (the two forms are equivalent).}
#' \item{\code{[:script=Greek:]}}{Alternative POSIX-like syntax for properties --
#'    equivalent to \code{\\p{script=Greek}}.}
#' }
#'
#' @section Unicode properties:
#'
#' Unicode property sets are specified with a POSIX-like syntax,
#' e.g., \code{[:Letter:]},
#' or with a (extended) Perl-style syntax, e.g., \code{\\p{L}}.
#' The complements of the above sets are
#' \code{[:^Letter:]} and \code{\\P{L}}, respectively.
#'
#' The names are normalized before matching
#' (for example, the match is case-insensitive).
#' Moreover, many names have short aliases.
#'
#' Among predefined Unicode properties we find, e.g.:
#' \itemize{
#' \item Unicode General Categories, e.g., \code{Lu} for uppercase letters,
#' \item Unicode Binary Properties, e.g., \code{WHITE_SPACE},
#' }
#' and many more (including Unicode scripts).
#'
#' Each property provides access to the large and comprehensive
#' Unicode Character Database.
#' Generally, the list of properties available in \pkg{ICU}
#' is not well-documented. Please refer to the References section
#' for some links.
#'
#' Please note that some classes might overlap.
#' However, e.g., General Category \code{Z} (some space) and Binary Property
#' \code{WHITE_SPACE} matches different character sets.
#'
#'
#' @section Unicode General Categories:
#'
#' The Unicode General Category property of a code point provides the most
#' general classification of that code point.
#' Each code point falls into one and only one Category.
#'
#' \describe{
#'  \item{\code{Cc}}{a C0 or C1 control code.}
#'  \item{\code{Cf}}{a format control character.}
#'  \item{\code{Cn}}{a reserved unassigned code point or a non-character.}
#'  \item{\code{Co}}{a private-use character.}
#'  \item{\code{Cs}}{a surrogate code point.}
#'  \item{\code{Lc}}{the union of Lu, Ll, Lt.}
#'  \item{\code{Ll}}{a lowercase letter.}
#'  \item{\code{Lm}}{a modifier letter.}
#'  \item{\code{Lo}}{other letters, including syllables and ideographs.}
#'  \item{\code{Lt}}{a digraphic character, with the first part uppercase.}
#'  \item{\code{Lu}}{an uppercase letter.}
#'  \item{\code{Mc}}{a spacing combining mark (positive advance width).}
#'  \item{\code{Me}}{an enclosing combining mark.}
#'  \item{\code{Mn}}{a non-spacing combining mark (zero advance width).}
#'  \item{\code{Nd}}{a decimal digit.}
#'  \item{\code{Nl}}{a letter-like numeric character.}
#'  \item{\code{No}}{a numeric character of other type.}
#'  \item{\code{Pd}}{a dash or hyphen punctuation mark.}
#'  \item{\code{Ps}}{an opening punctuation mark (of a pair).}
#'  \item{\code{Pe}}{a closing punctuation mark (of a pair).}
#'  \item{\code{Pc}}{a connecting punctuation mark, like a tie.}
#'  \item{\code{Po}}{a punctuation mark of other type.}
#'  \item{\code{Pi}}{an initial quotation mark.}
#'  \item{\code{Pf}}{a final quotation mark.}
#'  \item{\code{Sm}}{a symbol of mathematical use.}
#'  \item{\code{Sc}}{a currency sign.}
#'  \item{\code{Sk}}{a non-letter-like modifier symbol.}
#'  \item{\code{So}}{a symbol of other type.}
#'  \item{\code{Zs}}{a space character (of non-zero width).}
#'  \item{\code{Zl}}{U+2028 LINE SEPARATOR only.}
#'  \item{\code{Zp}}{U+2029 PARAGRAPH SEPARATOR only.}
#'  \item{\code{C} }{the union of Cc, Cf, Cs, Co, Cn.}
#'  \item{\code{L} }{the union of Lu, Ll, Lt, Lm, Lo.}
#'  \item{\code{M} }{the union of Mn, Mc, Me.}
#'  \item{\code{N} }{the union of Nd, Nl, No.}
#'  \item{\code{P} }{the union of Pc, Pd, Ps, Pe, Pi, Pf, Po.}
#'  \item{\code{S} }{the union of Sm, Sc, Sk, So.}
#'  \item{\code{Z} }{the union of Zs, Zl, Zp }
#' }
#'
#' @section Unicode Binary Properties:
#'
#' Each character may follow many Binary Properties at a time.
#'
#' Here is a comprehensive list of supported Binary Properties:
#'
#' \describe{
#'   \item{\code{ALPHABETIC}     }{alphabetic character.}
#'   \item{\code{ASCII_HEX_DIGIT}}{a character matching the \code{[0-9A-Fa-f]} charclass.}
#'   \item{\code{BIDI_CONTROL}   }{a format control which have specific functions
#'                              in the Bidi (bidirectional text) Algorithm.}
#'   \item{\code{BIDI_MIRRORED}  }{a character that may change display in right-to-left text.}
#'   \item{\code{DASH}           }{a kind of a dash character.}
#'   \item{\code{DEFAULT_IGNORABLE_CODE_POINT}}{characters that are ignorable in most
#'                                text processing activities,
#'                                e.g., <2060..206F, FFF0..FFFB, E0000..E0FFF>.}
#'   \item{\code{DEPRECATED}     }{a deprecated character according
#'           to the current Unicode standard (the usage of deprecated characters
#'           is strongly discouraged).}
#'   \item{\code{DIACRITIC}      }{a character that linguistically modifies
#'              the meaning of another character to which it applies.}
#'   \item{\code{EXTENDER}       }{a character that extends the value
#'                              or shape of a preceding alphabetic character,
#'                              e.g., a length and iteration mark.}
#'   \item{\code{HEX_DIGIT}      }{a character commonly
#'                             used for hexadecimal numbers,
#'                             see also \code{ASCII_HEX_DIGIT}.}
#'   \item{\code{HYPHEN}}{a dash used to mark connections between
#'               pieces of words, plus the Katakana middle dot.}
#'   \item{\code{ID_CONTINUE}}{a character that can continue an identifier,
#'                      \code{ID_START}+\code{Mn}+\code{Mc}+\code{Nd}+\code{Pc}.}
#'   \item{\code{ID_START}}{a character that can start an identifier,
#'                  \code{Lu}+\code{Ll}+\code{Lt}+\code{Lm}+\code{Lo}+\code{Nl}.}
#'   \item{\code{IDEOGRAPHIC}}{a CJKV (Chinese-Japanese-Korean-Vietnamese)
#'                ideograph.}
#'   \item{\code{LOWERCASE}}{...}
#'   \item{\code{MATH}}{...}
#'   \item{\code{NONCHARACTER_CODE_POINT}}{...}
#'   \item{\code{QUOTATION_MARK}}{...}
#'   \item{\code{SOFT_DOTTED}}{a character with a ``soft dot'', like i or j,
#' such that an accent placed on this character causes the dot to disappear.}
#'   \item{\code{TERMINAL_PUNCTUATION}}{a punctuation character that generally
#' marks the end of textual units.}
#'   \item{\code{UPPERCASE}}{...}
#'   \item{\code{WHITE_SPACE}}{a space character or TAB or CR or LF or ZWSP or ZWNBSP.}
#'   \item{\code{CASE_SENSITIVE}}{...}
#'   \item{\code{POSIX_ALNUM}}{...}
#'   \item{\code{POSIX_BLANK}}{...}
#'   \item{\code{POSIX_GRAPH}}{...}
#'   \item{\code{POSIX_PRINT}}{...}
#'   \item{\code{POSIX_XDIGIT}}{...}
#'   \item{\code{CASED}}{...}
#'   \item{\code{CASE_IGNORABLE}}{...}
#'   \item{\code{CHANGES_WHEN_LOWERCASED}}{...}
#'   \item{\code{CHANGES_WHEN_UPPERCASED}}{...}
#'   \item{\code{CHANGES_WHEN_TITLECASED}}{...}
#'   \item{\code{CHANGES_WHEN_CASEFOLDED}}{...}
#'   \item{\code{CHANGES_WHEN_CASEMAPPED}}{...}
#'   \item{\code{CHANGES_WHEN_NFKC_CASEFOLDED}}{...}
#'   \item{\code{EMOJI}}{Since ICU 57}
#'   \item{\code{EMOJI_PRESENTATION}}{Since ICU 57}
#'   \item{\code{EMOJI_MODIFIER}}{Since ICU 57}
#'   \item{\code{EMOJI_MODIFIER_BASE}}{Since ICU 57}
#' }
#'
#'
#' @section POSIX Character Classes:
#'
#' Avoid using POSIX character classes,
#' e.g., \code{[:punct:]}. The ICU User Guide (see below)
#' states that in general they are not well-defined, so you may end up
#' with something different than you expect.
#'
#' In particular, in POSIX-like regex engines, \code{[:punct:]} stands for
#' the character class corresponding to the \code{ispunct()} classification
#' function (check out \code{man 3 ispunct} on UNIX-like systems).
#' According to ISO/IEC 9899:1990 (ISO C90), the \code{ispunct()} function
#' tests for any printing character except for space or a character
#' for which \code{isalnum()} is true. However, in a POSIX setting,
#' the details of what characters belong into which class depend
#' on the current locale. So the \code{[:punct:]} class does not lead
#' to a portable code (again, in POSIX-like regex engines).
#'
#'  Therefore, a POSIX flavor of \code{[:punct:]} is more like
#' \code{[\\p{P}\\p{S}]} in \pkg{ICU}. You have been warned.
#'
#'
#' @references
#' \emph{The Unicode Character Database} -- Unicode Standard Annex #44,
#' \url{https://www.unicode.org/reports/tr44/}
#'
#' \emph{UnicodeSet} -- ICU User Guide,
#' \url{https://unicode-org.github.io/icu/userguide/strings/unicodeset.html}
#'
#' \emph{Properties} -- ICU User Guide,
#' \url{https://unicode-org.github.io/icu/userguide/strings/properties.html}
#'
#' \emph{C/POSIX Migration} -- ICU User Guide,
#' \url{https://unicode-org.github.io/icu/userguide/icu/posix.html}
#'
#' \emph{Unicode Script Data}, \url{https://www.unicode.org/Public/UNIDATA/Scripts.txt}
#'
#' \emph{icu::Unicodeset Class Reference} -- ICU4C API Documentation,
#' \url{https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/classicu_1_1UnicodeSet.html}
#'
#' @name about_search_charclass
#' @rdname about_search_charclass
#' @aliases about_search_charclass search_charclass stringi-search-charclass
#' @family search_charclass
#' @family stringi_general_topics
invisible(NULL)


#' @title
#' Text Boundary Analysis in \pkg{stringi}
#'
#' @description
#' Text boundary analysis is the process of locating linguistic boundaries
#' while formatting and handling text.
#'
#' @details
#' Examples of the boundary analysis process include:
#'
#' \itemize{
#' \item Locating positions to word-wrap text to fit
#' within specific margins while displaying or printing,
#' see \code{\link{stri_wrap}} and \code{\link{stri_split_boundaries}}.
#' \item Counting characters, words, sentences, or paragraphs,
#' see \code{\link{stri_count_boundaries}}.
#' \item Making a list of the unique words in a document,
#' see \code{\link{stri_extract_all_words}} and then \code{\link{stri_unique}}.
#' \item Capitalizing the first letter of each word
#' or sentence, see also \code{\link{stri_trans_totitle}}.
#' \item Locating a particular unit of the text (for example,
#' finding the third word in the document),
#' see \code{\link{stri_locate_all_boundaries}}.
#' }
#'
#' Generally, text boundary analysis is a locale-dependent operation.
#' For example, in Japanese and Chinese one does not separate words with spaces
#' - a line break can occur even in the middle of a word.
#' These languages have punctuation and diacritical
#' marks that cannot start or end a line, so this must also be taken into account.
#'
#' \pkg{stringi} uses \pkg{ICU}'s \code{BreakIterator} to locate specific
#' text boundaries. Note that the \code{BreakIterator}'s behavior
#' may be controlled in come cases, see \code{\link{stri_opts_brkiter}}.
#' \itemize{
#' \item The \code{character} boundary iterator tries to match what a user
#' would think of as a ``character''  -- a basic unit of a writing system
#' for a language -- which may be more than just a single Unicode code point.
#' \item The \code{word} boundary iterator locates the boundaries
#' of words, for purposes such as ``Find whole words'' operations.
#' \item The \code{line_break} iterator locates positions that would
#' be appropriate to wrap lines when displaying the text.
#' \item The break iterator of type \code{sentence}
#' locates sentence boundaries.
#' }
#'
#' For technical details on different classes of text boundaries refer
#' to the \pkg{ICU} User Guide, see below.
#'
#' @references
#' \emph{Boundary Analysis} -- ICU User Guide,
#' \url{https://unicode-org.github.io/icu/userguide/boundaryanalysis/}
#'
#' @name about_search_boundaries
#' @rdname about_search_boundaries
#' @aliases about_search_boundaries search_boundaries stringi-search-boundaries
#' @family locale_sensitive
#' @family text_boundaries
#' @family stringi_general_topics
invisible(NULL)
