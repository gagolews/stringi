## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
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
## "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
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
#' This man page instructs how to perform string search-based
#' operations in \pkg{stringi}.
#'
#' @details
#' The following independent string searching ``engines'' are available
#' in \pkg{stringi}.
#' \itemize{
#'    \item \code{stri_*_regex} -- \pkg{ICU}'s regular expressions,
#'         see \link{stringi-search-regex},
#'    \item \code{stri_*_fixed} -- locale-independent bytewise pattern matching,
#'        see \link{stringi-search-fixed},
#'    \item \code{stri_*_coll} -- \pkg{ICU}'s \code{StringSearch},
#'        locale-sensitive, Collator-based pattern search,
#'        useful for natural language processing tasks,
#'        see \link{stringi-search-coll},
#'    \item \code{stri_*_charclass} -- character classes search,
#'       e.g. Unicode General Categories or Binary Properties,
#'        see \link{stringi-search-charclass},
#'    \item \code{stri_*_boundaries} -- text boundary analysis,
#'       see \link{stringi-search-boundaries}
#' }
#'
#' Each ``engine'' is able to perform many search-based operations.
#' These may include:
#' \itemize{
#'    \item \code{stri_detect_*} - detect if a pattern occurs in a string,
#'    see e.g. \code{\link{stri_detect}},
#'    \item \code{stri_count_*} - count the number of pattern occurrences,
#'    see e.g. \code{\link{stri_count}},
#'    \item \code{stri_locate_*} - locate all, first, or last occurrences
#'    of a pattern, see e.g. \code{\link{stri_locate}},
#'    \item \code{stri_extract_*} - extract all, first, or last occurrences
#'    of a pattern, see e.g. \code{\link{stri_extract}}
#'    and, in case of regexes, \code{\link{stri_match}},
#'    \item \code{stri_replace_*} - replace all, first, or last occurrences
#'    of a pattern, see e.g. \code{\link{stri_replace}}
#'    and also \code{\link{stri_trim}},
#'    \item \code{stri_split_*} - split a string into chunks indicated
#'    by occurrences of a pattern,
#'    see e.g. \code{\link{stri_split}},
#'    \item \code{stri_startswith_*} and \code{stri_endswith_*} detect
#'    if a string starts or ends with a pattern match, see
#'    e.g. \code{\link{stri_startswith}},
#'    \item \code{stri_subset_*} - return a subset of a character vector
#'    with strings that match a given pattern, see e.g. \code{\link{stri_subset}}.
#' }
#'
#' @name stringi-search
#' @rdname stringi-search
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
#' abstract way, a part of text.
#' Thanks to many regex functions in \pkg{stringi},
#' regular expressions may be a very powerful tool in your hand
#' to perform string searching, substring extraction, string splitting, etc.,
#' tasks.
#'
#'
#' @details
#' All \code{stri_*_regex} functions in \pkg{stringi} use
#' the \pkg{ICU} regex engine. Its settings may be tuned up (for example
#' to perform case-insensitive search), see the
#' \code{\link{stri_opts_regex}} function for more details.
#'
#'
#' Regular expression patterns in \pkg{ICU} are quite similar in form and
#' behavior to Perl's regexes.  Their implementation is loosely inspired
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
#' \tabular{ll}{
#' \strong{Operator} \tab    \strong{Description}\cr
#' \code{|} \tab 	Alternation. A|B matches either A or B.\cr
#' \code{*} \tab 	Match 0 or more times. Match as many times as possible.\cr
#' \code{+} \tab 	Match 1 or more times. Match as many times as possible.\cr
#' \code{?} \tab 	Match zero or one times. Prefer one.\cr
#' \code{{n}} \tab 	Match exactly n times.\cr
#' \code{{n,}} \tab 	Match at least n times. Match as many times as possible.\cr
#' \code{{n,m}} \tab 	Match between n and m times.
#' Match as many times as possible, but not more than m.\cr
#' \code{*?} \tab 	Match 0 or more times. Match as few times as possible.\cr
#' \code{+?} \tab 	Match 1 or more times. Match as few times as possible.\cr
#' \code{??} \tab 	Match zero or one times. Prefer zero.\cr
#' \code{{n}?} \tab 	Match exactly n times.\cr
#' \code{{n,}?} \tab 	Match at least n times, but no more than required
#' for an overall pattern match.\cr
#' \code{{n,m}?} \tab 	Match between n and m times. Match as few times
#' as possible, but not less than n.\cr
#' \code{*+} \tab 	Match 0 or more times. Match as many times as possible
#' when first encountered, do not retry with fewer even if overall match fails
#' (Possessive Match).\cr
#' \code{++} \tab 	Match 1 or more times. Possessive match.\cr
#' \code{?+} \tab 	Match zero or one times. Possessive match.\cr
#' \code{{n}+} \tab 	Match exactly n times.\cr
#' \code{{n,}+} \tab 	Match at least n times. Possessive Match.\cr
#' \code{{n,m}+} \tab 	Match between n and m times. Possessive Match.\cr
#' \code{(...)} \tab 	Capturing parentheses. Range of input that matched
#' the parenthesized subexpression is available after the match,
#' see \code{\link{stri_match}}.\cr
#' \code{(?:...)} \tab 	Non-capturing parentheses. Groups the included pattern,
#' but does not provide capturing of matching text. Somewhat more efficient
#' than capturing parentheses.\cr
#' \code{(?>...)} \tab 	Atomic-match parentheses. First match of the
#' parenthesized subexpression is the only one tried; if it does not lead to
#' an overall pattern match, back up the search for a match to a position
#' before the \code{(?>}\cr
#' \code{(?#...)} \tab 	Free-format comment \code{(?# comment )}.\cr
#' \code{(?=...)} \tab 	Look-ahead assertion. True if the parenthesized
#' pattern matches at the current input position, but does not advance
#' the input position.\cr
#' \code{(?!...)} \tab 	Negative look-ahead assertion. True if the
#' parenthesized pattern does not match at the current input position.
#' Does not advance the input position.\cr
#' \code{(?<=...)} \tab 	Look-behind assertion. True if the parenthesized
#' pattern matches text preceding the current input position, with the last
#' character of the match being the input character just before the current
#' position. Does not alter the input position. The length of possible strings
#' matched by the look-behind pattern must not be unbounded (no \code{*}
#' or \code{+} operators.)\cr
#' \code{(?<!...)} \tab 	Negative Look-behind assertion. True if the
#' parenthesized pattern does not match text preceding the current input
#' position, with the last character of the match being the input character
#' just before the current position. Does not alter the input position.
#' The length of possible strings matched by the look-behind pattern must
#' not be unbounded (no \code{*} or \code{+} operators.)\cr
#' \code{(?ismwx-ismwx:...)} \tab 	Flag settings. Evaluate the parenthesized
#' expression with the specified flags enabled or \code{-}disabled,
#' see also \code{\link{stri_opts_regex}}.\cr
#' \code{(?ismwx-ismwx)} \tab 	Flag settings. Change the flag settings.
#' Changes apply to the portion of the pattern following the setting.
#' For example, \code{(?i)} changes to a case insensitive match,
#' see also \code{\link{stri_opts_regex}}. \cr
#' }
#'
#'
#' @section \pkg{ICU} Regex Metacharacters at a Glance:
#'
#' Here is a list of metacharacters provided by the
#' ICU User Guide on regexes.
#'
#' \tabular{ll}{
#' \strong{Character}  \tab 	\strong{Description} \cr
#' \code{\\a} \tab Match a BELL, \code{\\u0007} \cr
#' \code{\\A} \tab Match at the beginning of the input. Differs from \code{^}
#' in that \code{\\A} will not match after a new line within the input. \cr
#' \code{\\b} \tab Match if the current position is a word boundary.
#' Boundaries occur at the transitions between word (\code{\\w}) and non-word
#' (\code{\\W}) characters, with combining marks ignored. For better word
#' boundaries, see ICU Boundary Analysis, e.g. \code{\link{stri_extract_all_words}} . \cr
#' \code{\\B} \tab Match if the current position is not a word boundary. \cr
#' \code{\\cX} \tab Match a control-\code{X} character. \cr
#' \code{\\d} \tab Match any character with the Unicode General Category of
#' Nd (Number, Decimal Digit.) \cr
#' \code{\\D} \tab Match any character that is not a decimal digit. \cr
#' \code{\\e} \tab Match an ESCAPE, \code{\\u001B}. \cr
#' \code{\\E} \tab Terminates a \code{\\Q} ... \code{\\E} quoted sequence. \cr
#' \code{\\f} \tab Match a FORM FEED, \code{\\u000C}. \cr
#' \code{\\G} \tab Match if the current position is at the end of the
#' previous match. \cr
#' \code{\\n} \tab Match a LINE FEED, \code{\\u000A}. \cr
#' \code{\\N{UNICODE CHARACTER NAME}} \tab Match the named character. \cr
#' \code{\\p{UNICODE PROPERTY NAME}} \tab Match any character with the
#' specified Unicode Property. \cr
#' \code{\\P{UNICODE PROPERTY NAME}} \tab Match any character not having
#' the specified Unicode Property. \cr
#' \code{\\Q} \tab Quotes all following characters until \code{\\E}. \cr
#' \code{\\r} \tab Match a CARRIAGE RETURN, \code{\\u000D}. \cr
#' \code{\\s} \tab Match a white space character. White space is defined
#' as \code{[\\t\\n\\f\\r\\p{Z}]}. \cr
#' \code{\\S} \tab Match a non-white space character. \cr
#' \code{\\t} \tab Match a HORIZONTAL TABULATION, \code{\\u0009}. \cr
#' \code{\\uhhhh} \tab Match the character with the hex value \code{hhhh}. \cr
#' \code{\\Uhhhhhhhh} \tab Match the character with the hex value \code{hhhhhhhh}.
#' Exactly eight hex digits must be provided, even though the largest
#' Unicode code point is \code{\\U0010ffff}. \cr
#' \code{\\w} \tab Match a word character. Word characters are
#' \code{[\\p{Alphabetic}\\p{Mark}\\p{Decimal_Number}\\p{Connector_Punctuation}\\u200c\\u200d]}. \cr
#' \code{\\W} \tab Match a non-word character. \cr
#' \code{\\x{hhhh}} \tab Match the character with hex value hhhh.
#' From one to six hex digits may be supplied. \cr
#' \code{\\xhh} \tab Match the character with two digit hex value hh \cr
#' \code{\\X} \tab Match a Grapheme Cluster. \cr
#' \code{\\Z} \tab Match if the current position is at the end of input,
#'  but before the final line terminator, if one exists. \cr
#' \code{\\z} \tab Match if the current position is at the end of input. \cr
#' \code{\\n} \tab 	Back Reference. Match whatever the nth capturing
#' group matched. n must be a number > 1 and < total number of capture
#' groups in the pattern. \cr
#' \code{\\0ooo} \tab Match an Octal character.  'ooo' is from one to three
#' octal digits.  0377 is the largest allowed Octal character.  The leading
#' zero is required; it distinguishes Octal constants from back references. \cr
#' \code{[pattern]} \tab Match any one character from the set.  \cr
#' \code{.} \tab Match any character. \cr
#' \code{^} \tab Match at the beginning of a line. \cr
#' \code{$} \tab Match at the end of a line. \cr
#' \code{\\} \tab [outside of sets] Quotes the following character.
#' Characters that must be quoted to be treated as literals are
#' \code{* ? + [ ( ) { } ^ $ | \\ .} \cr
#' \code{\\} \tab [inside sets] Quotes the following character.
#' Characters that must be quoted to be treated as literals are
#' \code{[ ] \\}; Characters that may need to be quoted, depending
#' on the context are \code{- &} \cr
#' }
#'
#' For information on how to define character classes
#' in regexes, refer to \link{stringi-search-charclass}.
#'
#' @section Regex Functions in \pkg{stringi}:
#' Note that if a given regex \code{pattern} is empty,
#' then all functions in \pkg{stringi} give \code{NA} in result
#' and generate a warning.
#' On a syntax error, a quite informative failure message is shown.
#'
#' If you would like to search for a fixed pattern,
#' refer to \link{stringi-search-coll} or \link{stringi-search-fixed}.
#' This allows to do a locale-aware text lookup,
#' or a very fast exact-byte search, respectively.
#'
#'
#'
#' @references
#' \emph{Regular expressions} -- ICU User Guide,
#'  \url{http://userguide.icu-project.org/strings/regexp}
#'
#' J.E.F. Friedl, \emph{Mastering Regular Expressions}, O'Reilly, 2002
#'
#' \emph{Unicode Regular Expressions} -- Unicode Technical Standard #18,
#' \url{http://www.unicode.org/reports/tr18/}
#'
#' \emph{Unicode Regular Expressions} -- Regex tutorial,
#' \url{http://www.regular-expressions.info/unicode.html}
#'
#' @name stringi-search-regex
#' @rdname stringi-search-regex
#' @family search_regex
#' @family stringi_general_topics
invisible(NULL)


#' @title
#' Locale-Insensitive Fixed Pattern Matching in \pkg{stringi}
#'
#' @description
#' String searching facilities described in this very man page
#' provide a way to locate a specific sequence of bytes in a string.
#' Fixed pattern search engine's settings may be tuned up (for example
#' to perform case-insensitive search), see the
#' \code{\link{stri_opts_fixed}} function for more details.
#'
#'
#' @section Byte Compare:
#'
#' The Knuth-Morris-Pratt search algorithm, with worst time complexity of
#' O(n+p) (\code{n == length(str)}, \code{p == length(pattern)})
#' is utilized (with some tweaks for very short search patterns).
#' For natural language processing, however, this is not what
#' you probably want. It is because a bitwise match will
#' not give correct results in cases of:
#' \enumerate{
#' \item accented letters;
#' \item conjoined letters;
#' \item ignorable punctuation;
#' \item ignorable case,
#' }
#' see also \link{stringi-search-coll}.
#'
#' Note that the conversion of input data
#' to Unicode is done as usual.
#'
#' @name stringi-search-fixed
#' @rdname stringi-search-fixed
#' @family search_fixed
#' @family stringi_general_topics
invisible(NULL)


#' @title
#' Locale-Sensitive Text Searching in \pkg{stringi}
#'
#' @description
#' String searching facilities described in this very man page
#' provide a way to locate a specific piece of
#' text. Note that locale-sensitive searching, especially
#' on a non-English text, is a much more complex process
#' than it seems at the first glance.
#'
#'
#'
#' @section Locale-Aware String Search Engine:
#'
#' All \code{stri_*_coll} functions in \pkg{stringi} utilize
#' \pkg{ICU}'s \code{StringSearch} engine --
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
#' often exhibit poor performance. These functions are not intended to
#' be fast; they are made to give \emph{correct} in natural
#' language processing tasks.
#'
#'
#' @references
#' \emph{ICU String Search Service} -- ICU User Guide,
#'  \url{http://userguide.icu-project.org/collation/icu-string-search-service}
#'
#' L. Werner, \emph{Efficient Text Searching in Java}, 1999,
#' \url{http://icu-project.org/docs/papers/efficient_text_searching_in_java.html}
#'
#' @name stringi-search-coll
#' @rdname stringi-search-coll
#' @family search_coll
#' @family locale_sensitive
#' @family stringi_general_topics
invisible(NULL)


#' @title Character Classes in \pkg{stringi}
#'
#' @description
#' In this man page we describe how character classes are
#' declared in the \pkg{stringi} package
#' so that you may e.g. find their occurrences in your search activities
#' or generate random code points with \code{\link{stri_rand_strings}}.
#' Moreover, \pkg{ICU} regex engines uses the same
#' scheme for denoting character classes.
#'
#'
#' @details
#' All \code{stri_*_charclass} functions in \pkg{stringi} perform
#' a single character (i.e. Unicode code point) search-based operations.
#' Since stringi_0.2-1 you may obtain
#' roughly the same results using \link{stringi-search-regex}.
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
#' Patterns either consist of series of characters either bounded by square brackets
#' (such patterns follow a syntax similar to that employed
#' by version 8 regular expression character classes)
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
#' \code{^} denotes the complement, e.g. \code{[^a-z]} contains
#' all characters but ``a'' through ``z''.
#' On the other hand, \code{[[pat1][pat2]]},
#' \code{[[pat1]\&[pat2]]}, and \code{[[pat1]-[pat2]]}
#' denote union, intersection, and asymmetric difference of sets
#' specified by \code{pat1} and \code{pat2}, respectively.
#'
#' Note that all white spaces are ignored unless they are quoted or backslashed
#' (white spaces can be freely used for clarity, as \code{[a c d-f m]}
#' means the same as \code{[acd-fm]}).
#' \pkg{stringi} does not allow for including so-called multicharacter strings
#' (see \code{UnicodeSet} API documentation).
#' Also, empty string patterns are disallowed.
#'
#' Any character may be preceded by
#' a backslash in order to remove any special meaning.
#'
#' A malformed pattern always results in an error.
#'
#' Set expressions at a glance
#' (according to \url{http://userguide.icu-project.org/strings/regexp}):
#'
#' \tabular{ll}{
#' \strong{Example}  \tab  \strong{Description}\cr
#' \code{[abc]} 	\tab Match any of the characters a, b or c\cr
#' \code{[^abc]} 	\tab Negation -- match any character except a, b or c\cr
#' \code{[A-M]} 	\tab Range -- match any character from A to M. The characters
#' to include are determined by Unicode code point ordering.\cr
#' \code{[\\u0000-\\U0010ffff]} 	\tab Range -- match all characters.\cr
#' \code{[\\p{Letter}]} or \code{[\\p{General_Category=Letter}]} or \code{[\\p{L}]} 	\tab
#' Characters with Unicode Category = Letter. All forms shown are equivalent.\cr
#' \code{[\\P{Letter}]} 	\tab Negated property.
#' (Upper case \code{\\P}) Match everything except Letters.\cr
#' \code{[\\p{numeric_value=9}]} 	\tab Match all numbers with a numeric value of 9.
#' Any Unicode Property may be used in set expressions.\cr
#' \code{[\\p{Letter}&&\\p{script=cyrillic}]} 	\tab Logical AND
#' or intersection -- match the set of all Cyrillic letters.\cr
#' \code{[\\p{Letter}--\\p{script=latin}]}  	\tab Subtraction --
#' match all non-Latin letters.\cr
#' \code{[[a-z][A-Z][0-9]]} or \code{[a-zA-Z0-9]}  	\tab Implicit Logical
#' OR or Union of Sets -- the examples match ASCII letters and digits.
#' The two forms are equivalent.\cr
#' \code{[:script=Greek:]} \tab Alternate POSIX-like syntax for properties --
#' equivalent to \code{\\p{script=Greek}}\cr
#' }
#'
#' @section Unicode properties:
#'
#' Unicode property sets are specified with a POSIX-like syntax,
#' e.g. \code{[:Letter:]},
#' or with a (extended) Perl-style syntax, e.g. \code{\\p{L}}.
#' The complements of the above sets are
#' \code{[:^Letter:]} and \code{\\P{L}}, respectively.
#'
#' The properties' names are normalized before matching
#' (for example, the match is case-insensitive).
#' Moreover, many names have short aliases.
#'
#' Among predefined Unicode properties we find e.g.
#' \itemize{
#' \item Unicode General Categories, e.g. \code{Lu} for uppercase letters,
#' \item Unicode Binary Properties, e.g. \code{WHITE_SPACE},
#' }
#' and many more (including Unicode scripts).
#'
#' Each property provides access to the large and comprehensive
#' Unicode Character Database.
#' Generally, the list of properties available in \pkg{ICU}
#' is not perfectly documented. Please refer to the References section
#' for some links.
#'
#' Please note that some classes may seem to overlap.
#' However, e.g. General Category \code{Z} (some space) and Binary Property
#' \code{WHITE_SPACE} matches different character sets.
#'
#'
#' @section Unicode General Categories:
#'
#' The Unicode General Category property of a code point provides the most
#' general classification of that code point.
#' Each code point falls into one and only one Category.
#'
#' \tabular{ll}{
#'  \code{Cc} \tab a C0 or C1 control code\cr
#'  \code{Cf} \tab a format control character\cr
#'  \code{Cn} \tab a reserved unassigned code point or a non-character\cr
#'  \code{Co} \tab a private-use character\cr
#'  \code{Cs} \tab a surrogate code point\cr
#'  \code{Lc} \tab the union of Lu, Ll, Lt\cr
#'  \code{Ll} \tab a lowercase letter\cr
#'  \code{Lm} \tab a modifier letter\cr
#'  \code{Lo} \tab other letters, including syllables and ideographs\cr
#'  \code{Lt} \tab a digraphic character, with first part uppercase\cr
#'  \code{Lu} \tab an uppercase letter\cr
#'  \code{Mc} \tab a spacing combining mark (positive advance width)\cr
#'  \code{Me} \tab an enclosing combining mark\cr
#'  \code{Mn} \tab a non-spacing combining mark (zero advance width)\cr
#'  \code{Nd} \tab a decimal digit\cr
#'  \code{Nl} \tab a letter-like numeric character\cr
#'  \code{No} \tab a numeric character of other type\cr
#'  \code{Pd} \tab a dash or hyphen punctuation mark\cr
#'  \code{Ps} \tab an opening punctuation mark (of a pair)\cr
#'  \code{Pe} \tab a closing punctuation mark (of a pair)\cr
#'  \code{Pc} \tab a connecting punctuation mark, like a tie\cr
#'  \code{Po} \tab a punctuation mark of other type\cr
#'  \code{Pi} \tab an initial quotation mark\cr
#'  \code{Pf} \tab a final quotation mark\cr
#'  \code{Sm} \tab a symbol of mathematical use\cr
#'  \code{Sc} \tab a currency sign\cr
#'  \code{Sk} \tab a non-letter-like modifier symbol\cr
#'  \code{So} \tab a symbol of other type\cr
#'  \code{Zs} \tab a space character (of non-zero width)\cr
#'  \code{Zl} \tab U+2028 LINE SEPARATOR only\cr
#'  \code{Zp} \tab U+2029 PARAGRAPH SEPARATOR only\cr
#'  \code{C}  \tab the union of Cc, Cf, Cs, Co, Cn\cr
#'  \code{L}  \tab the union of Lu, Ll, Lt, Lm, Lo\cr
#'  \code{M}  \tab the union of Mn, Mc, Me\cr
#'  \code{N}  \tab the union of Nd, Nl, No\cr
#'  \code{P}  \tab the union of Pc, Pd, Ps, Pe, Pi, Pf, Po\cr
#'  \code{S}  \tab the union of Sm, Sc, Sk, So\cr
#'  \code{Z}  \tab the union of Zs, Zl, Zp \cr
#' }
#'
#' @section Unicode Binary Properties:
#'
#' Each character may follow many Binary Properties at a time.
#'
#' Here is a comprehensive list of supported Binary Properties:
#'
#' \tabular{ll}{
#'   \code{ALPHABETIC}      \tab alphabetic character\cr
#'   \code{ASCII_HEX_DIGIT} \tab a character matching the \code{[0-9A-Fa-f]} charclass\cr
#'   \code{BIDI_CONTROL}    \tab a format control which have specific functions
#'                              in the Bidi (bidirectional text) Algorithm\cr
#'   \code{BIDI_MIRRORED}   \tab a character that may change display in right-to-left text\cr
#'   \code{DASH}            \tab a kind of a dash character\cr
#'   \code{DEFAULT_IGNORABLE_CODE_POINT} \tab characters that are ignorable in most
#'                                text processing activities,
#'                                e.g. <2060..206F, FFF0..FFFB, E0000..E0FFF>\cr
#'   \code{DEPRECATED}      \tab a deprecated character according
#'           to the current Unicode standard (the usage of deprecated characters
#'           is strongly discouraged)\cr
#'   \code{DIACRITIC}       \tab a character that linguistically modifies
#'              the meaning of another character to which it applies\cr
#'   \code{EXTENDER}        \tab a character that extends the value
#'                              or shape of a preceding alphabetic character,
#'                              e.g. a length and iteration mark.\cr
#'   \code{HEX_DIGIT}       \tab a character commonly
#'                             used for hexadecimal numbers,
#'                             cf. also \code{ASCII_HEX_DIGIT}\cr
#'   \code{HYPHEN} \tab a dash used to mark connections between
#'               pieces of words, plus the Katakana middle dot\cr
#'   \code{ID_CONTINUE} \tab a character that can continue an identifier,
#'                      \code{ID_START}+\code{Mn}+\code{Mc}+\code{Nd}+\code{Pc}\cr
#'   \code{ID_START} \tab a character that can start an identifier,
#'                  \code{Lu}+\code{Ll}+\code{Lt}+\code{Lm}+\code{Lo}+\code{Nl}\cr
#'   \code{IDEOGRAPHIC} \tab a CJKV (Chinese-Japanese-Korean-Vietnamese)
#' ideograph\cr
#'   \code{LOWERCASE} \tab \cr
#'   \code{MATH} \tab \cr
#'   \code{NONCHARACTER_CODE_POINT} \tab \cr
#'   \code{QUOTATION_MARK} \tab \cr
#'   \code{SOFT_DOTTED} \tab a character with a ``soft dot'', like i or j,
#' such that an accent placed on this character causes the dot to disappear\cr
#'   \code{TERMINAL_PUNCTUATION} \tab a punctuation character that generally
#' marks the end of textual units\cr
#'   \code{UPPERCASE} \tab \cr
#'   \code{WHITE_SPACE} \tab a space character or TAB or CR or LF or ZWSP or ZWNBSP\cr
#'   \code{CASE_SENSITIVE} \tab \cr
#'   \code{POSIX_ALNUM} \tab \cr
#'   \code{POSIX_BLANK} \tab \cr
#'   \code{POSIX_GRAPH} \tab \cr
#'   \code{POSIX_PRINT} \tab \cr
#'   \code{POSIX_XDIGIT} \tab \cr
#'   \code{CASED} \tab \cr
#'   \code{CASE_IGNORABLE} \tab \cr
#'   \code{CHANGES_WHEN_LOWERCASED} \tab \cr
#'   \code{CHANGES_WHEN_UPPERCASED} \tab \cr
#'   \code{CHANGES_WHEN_TITLECASED} \tab \cr
#'   \code{CHANGES_WHEN_CASEFOLDED} \tab \cr
#'   \code{CHANGES_WHEN_CASEMAPPED} \tab \cr
#'   \code{CHANGES_WHEN_NFKC_CASEFOLDED} \tab \cr
#' }
#'
#'
#' @section POSIX Character Classes:
#'
#' Beware of using POSIX character classes,
#' e.g. \code{[:punct:]}. ICU User Guide (see below)
#' states that in general they are not well-defined, so may end up
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
#' to portable code (again, in POSIX-like regex engines).
#'
#' So a POSIX flavor of \code{[:punct:]} is more like
#' \code{[\\p{P}\\p{S}]} in \pkg{ICU}. You have been warned.
#'
#'
#' @references
#' \emph{The Unicode Character Database} -- Unicode Standard Annex #44,
#' \url{http://www.unicode.org/reports/tr44/}
#'
#' \emph{UnicodeSet} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/strings/unicodeset}
#'
#' \emph{Properties} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/strings/properties}
#'
#' \emph{C/POSIX Migration} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/posix}
#'
#' \emph{Unicode Script Data}, \url{http://www.unicode.org/Public/UNIDATA/Scripts.txt}
#'
#' \emph{icu::Unicodeset Class Reference} -- ICU4C API Documentation,
#' \url{http://www.icu-project.org/apiref/icu4c/classicu_1_1UnicodeSet.html}
#'
#' @name stringi-search-charclass
#' @rdname stringi-search-charclass
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
#' Examples of the boundary analysis process process include:
#'
#' \itemize{
#' \item Locating appropriate points to word-wrap text to fit
#' within specific margins while displaying or printing,
#' see \code{\link{stri_wrap}} and \code{\link{stri_split_boundaries}}.
#' \item Counting characters, words, sentences, or paragraphs,
#' see \code{\link{stri_count_boundaries}}.
#' \item Making a list of the unique words in a document,
#' cf. \code{\link{stri_extract_all_words}} and then \code{\link{stri_unique}}.
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
#' be appropriate points to wrap lines when displaying the text.
#' \item On the other hand, a break iterator of type \code{sentence}
#' locates sentence boundaries.
#' }
#'
#' For technical details on different classes of text boundaries refer
#' to the \pkg{ICU} User Guide, see below.
#'
#' @references
#' \emph{Boundary Analysis} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/boundaryanalysis}
#'
#' @name stringi-search-boundaries
#' @rdname stringi-search-boundaries
#' @family locale_sensitive
#' @family text_boundaries
#' @family stringi_general_topics
invisible(NULL)
