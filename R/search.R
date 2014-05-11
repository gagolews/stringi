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
#' This man page explains how to perform string search-based
#' operations in \pkg{stringi}.
#'
#' @details
#' There are four independent string searching ``engines'' in \pkg{stringi}.
#' \itemize{
#'    \item \code{stri_*_regex} -- \pkg{ICU}'s regular expressions,
#'         see \link{stringi-search-regex},
#'    \item \code{stri_*_fixed} -- locale-independent bytewise pattern matching,
#'    \item \code{stri_*_coll} -- \pkg{ICU}'s \code{StringSearch},
#'        locale-sensitive, Collator-based ``fixed'' patterns search,
#'        useful for natural language processing tasks,
#'        see \link{stringi-search-fixed},
#'    \item \code{stri_*_charclass} -- character classes search,
#'       e.g. Unicode General Categories or Binary Properties,
#'        see \link{stringi-search-charclass},
#' }
#'
#' Each ``engine'' is able to perform many search-based operations, including:
#' \itemize{
#'    \item \code{stri_detect_*} - detects if a pattern occurs in a string,
#'    see e.g. \code{\link{stri_detect}},
#'    \item \code{stri_count_*} - counts the number of occurrences of text
#'      matching a pattern,
#'    see e.g. \code{\link{stri_count}},
#'    \item \code{stri_locate_*} - locates all, first, or last occurrences of a pattern,
#'    see e.g. \code{\link{stri_locate}},
#'    \item \code{stri_extract_*} - extracts all, first, or last occurrences of a pattern,
#'    see e.g. \code{\link{stri_extract}}
#'    and, in case of regexes, \code{\link{stri_match}},
#'    \item \code{stri_replace_*} - replaces all, first, or last occurrences of a pattern,
#'    see e.g. \code{\link{stri_replace}},
#'    \item \code{stri_split_*} - splits a string into chunks indicated by occurrences of a pattern,
#'    see e.g. \code{\link{stri_split}}.
#' }
#'
#' @name stringi-search
#' @rdname stringi-search
#' @family search_regex
#' @family search_fixed
#' @family search_coll
#' @family search_charclass
#' @family search_detect
#' @family search_count
#' @family search_match
#' @family search_locate
#' @family search_replace
#' @family search_split
#' @family search_extract
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
#' to do string searching,
#' substring extraction, string splitting, etc.
#'
#'
#' @details
#' All \code{stri_*_regex} functions in \pkg{stringi} use
#' the \pkg{ICU} regex engine, which settings may be tuned up (for example
#' to perform case-insensitive search) with the
#' \code{\link{stri_opts_regex}} function.
#'
#'
#' Regular expression patterns in \pkg{ICU} are quite similar in form and behavior
#' to Perl's regexes.  Their implementation is loosely inspired
#' by JDK 1.4 \code{java.util.regex}.
#' \pkg{ICU} Regular Expressions conform to the Unicode Technical Standard #18
#' (see References section) and its features are summarized in
#' the ICU User Guide (see below). A good general introduction
#' to regexes is (Friedl, 2002).
#' Some topics are also covered in the \R manual, see \link{regex}.
#'
#' @section Regexes in \pkg{stringi}:
#' Note that if a given regex \code{pattern} is empty,
#' then all functions in \pkg{stringi} give \code{NA} in result
#' and generate a warning.
#' On syntax error, a quite informative failure message is shown.
#'
#' If you would like to search for a fixed pattern,
#' refer to \link{stringi-search-fixed}.
#' This allows to do a locale-aware text lookup,
#' or a very fast exact-byte search.
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
#' \emph{Unicode Regular Expressions} -- Regex tutorial, \url{http://www.regular-expressions.info/unicode.html}
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
#' provide a way to locate a specific piece of
#' text. Note that locale-sensitive searching, especially
#' on a non-English language text, is a much more complex process
#' than it seems at the first glance.
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
#' Note that, the conversion of input data
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
#' often exhibit poor performance.
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
#' or generate random codepoints with \code{\link{stri_rand_strings}}.
#'
#'
#' @details
#' All \code{stri_*_charclass} functions in \pkg{stringi} perform
#' a single character (Unicode codepoint) search-based operations.
#' Since stringi_0.2-1 you may obtain
#' roughly the same results using \link{stringi-search-regex}.
#' However, these very functions aim to be quite faster.
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
#' denote union, intersection, and asymmetric diference of sets
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
#'
#' @section Unicode properties:
#'
#' Unicode property sets are specified with a POSIX-like syntax,
#' e.g. \code{[:Letter:]}, or with a (extended) Perl-style syntax,
#' e.g. \code{\\p{L}}.
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
#' \itemize{
#' \item \code{Cc} -- a C0 or C1 control code;
#' \item \code{Cf} -- a format control character;
#' \item \code{Cn} -- a reserved unassigned code point or a non-character;
#' \item \code{Co} -- a private-use character;
#' \item \code{Cs} -- a surrogate code point;
#' \item \code{Lc} -- the union of Lu, Ll, Lt;
#' \item \code{Ll} -- a lowercase letter;
#' \item \code{Lm} -- a modifier letter;
#' \item \code{Lo} -- other letters, including syllables and ideographs;
#' \item \code{Lt} -- a digraphic character, with first part uppercase;
#' \item \code{Lu} -- an uppercase letter;
#' \item \code{Mc} -- a spacing combining mark (positive advance width);
#' \item \code{Me} -- an enclosing combining mark;
#' \item \code{Mn} -- a non-spacing combining mark (zero advance width);
#' \item \code{Nd} -- a decimal digit;
#' \item \code{Nl} -- a letter-like numeric character;
#' \item \code{No} -- a numeric character of other type;
#' \item \code{Pd} -- a dash or hyphen punctuation mark;
#' \item \code{Ps} -- an opening punctuation mark (of a pair);
#' \item \code{Pe} -- a closing punctuation mark (of a pair);
#' \item \code{Pc} -- a connecting punctuation mark, like a tie;
#' \item \code{Po} -- a punctuation mark of other type;
#' \item \code{Pi} -- an initial quotation mark;
#' \item \code{Pf} -- a final quotation mark;
#' \item \code{Sm} -- a symbol of mathematical use;
#' \item \code{Sc} -- a currency sign;
#' \item \code{Sk} -- a non-letter-like modifier symbol;
#' \item \code{So} -- a symbol of other type;
#' \item \code{Zs} -- a space character (of non-zero width);
#' \item \code{Zl} -- U+2028 LINE SEPARATOR only;
#' \item \code{Zp} -- U+2029 PARAGRAPH SEPARATOR only;
#' \item \code{C}  -- the union of Cc, Cf, Cs, Co, Cn;
#' \item \code{L}  -- the union of Lu, Ll, Lt, Lm, Lo;
#' \item \code{M}  -- the union of Mn, Mc, Me;
#' \item \code{N}  -- the union of Nd, Nl, No;
#' \item \code{P}  -- the union of Pc, Pd, Ps, Pe, Pi, Pf, Po;
#' \item \code{S}  -- the union of Sm, Sc, Sk, So;
#' \item \code{Z}  -- the union of Zs, Zl, Zp.
#' }
#'
#' @section Unicode Binary Properties:
#'
#' Each character may follow many Binary Properties at a time.
#'
#' Here is the complete list of supported Binary Properties:
#' \itemize{
#' \item \code{ALPHABETIC}      -- alphabetic character;
#' \item \code{ASCII_HEX_DIGIT} -- a character matching the \code{[0-9A-Fa-f]} charclass;
#' \item \code{BIDI_CONTROL}    -- a format control which have specific functions
#'                              in the Bidi (bidirectional text) Algorithm;
#' \item \code{BIDI_MIRRORED}   -- a character that may change display in right-to-left text;
#' \item \code{DASH}            -- a kind of a dash character;
#' \item \code{DEFAULT_IGNORABLE_CODE_POINT} -- characters that are ignorable in most
#'                                text processing activities,
#'                                e.g. <2060..206F, FFF0..FFFB, E0000..E0FFF>;
#' \item \code{DEPRECATED}      -- a deprecated character according
#'           to the current Unicode standard (the usage of deprecated characters
#'           is strongly discouraged);
#' \item \code{DIACRITIC}       -- a character that linguistically modifies
#'              the meaning of another character to which it applies;
#' \item \code{EXTENDER}        -- a character that extends the value
#'                              or shape of a preceding alphabetic character,
#'                              e.g. a length and iteration mark.
#' \item \code{HEX_DIGIT}       -- a character commonly
#'                             used for hexadecimal numbers,
#'                             cf. also \code{ASCII_HEX_DIGIT};
#' \item \code{HYPHEN} -- a dash used to mark connections between
#'               pieces of words, plus the Katakana middle dot;
#' \item \code{ID_CONTINUE} -- a character that can continue an identifier,
#'                      \code{ID_START}+\code{Mn}+\code{Mc}+\code{Nd}+\code{Pc};
#' \item \code{ID_START} -- a character that can start an identifier,
#'                  \code{Lu}+\code{Ll}+\code{Lt}+\code{Lm}+\code{Lo}+\code{Nl};
#' \item \code{IDEOGRAPHIC} -- a CJKV (Chinese-Japanese-Korean-Vietnamese)
#' ideograph;
#' \item \code{LOWERCASE} ;
#' \item \code{MATH} ;
#' \item \code{NONCHARACTER_CODE_POINT} ;
#' \item \code{QUOTATION_MARK} ;
#' \item \code{SOFT_DOTTED} -- a character with a ``soft dot'', like i or j,
#' such that an accent placed on this character causes the dot to disappear;
#' \item \code{TERMINAL_PUNCTUATION} -- a punctuation character that generally
#' marks the end of textual units;
#' \item \code{UPPERCASE} ;
#' \item \code{WHITE_SPACE} -- a space character or TAB or CR or LF or ZWSP or ZWNBSP;
#' \item \code{CASE_SENSITIVE} ;
#' \item \code{POSIX_ALNUM} ;
#' \item \code{POSIX_BLANK} ;
#' \item \code{POSIX_GRAPH} ;
#' \item \code{POSIX_PRINT} ;
#' \item \code{POSIX_XDIGIT} ;
#' \item \code{CASED} ;
#' \item \code{CASE_IGNORABLE} ;
#' \item \code{CHANGES_WHEN_LOWERCASED} ;
#' \item \code{CHANGES_WHEN_UPPERCASED} ;
#' \item \code{CHANGES_WHEN_TITLECASED} ;
#' \item \code{CHANGES_WHEN_CASEFOLDED} ;
#' \item \code{CHANGES_WHEN_CASEMAPPED} ;
#' \item \code{CHANGES_WHEN_NFKC_CASEFOLDED}.
#' }
#' and many more.
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
