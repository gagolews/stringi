## This file is part of the 'stringi' package for R.
##
## Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
##
##
## Permission is hereby granted, free of charge, to any person obtaining
## a copy of this software and associated documentation files (the "Software"),
## to deal in the Software without restriction, including without limitation
## the rights to use, copy, modify, merge, publish, distribute, sublicense,
## and/or sell copies of the Software, and to permit persons to whom
## the Software is furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included
## in all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
## EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
## IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
## DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
## TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
## THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#' @title String Searching
#'
#' @description
#' This man page explains how to perform string search-based
#' operations in \pkg{stringi}.
#'
#' @details
#' There are three independent string searching ``engines'' in \pkg{stringi}.
#' \itemize{
#'    \item \code{stri_*_regex} -- \pkg{ICU}'s regular expressions,
#'         see \link{stringi-search-regex},
#'    \item \code{stri_*_fixed} -- \pkg{ICU}'s \code{StringSearch},
#'        locale-sensitive ``fixed'' patterns search , see \link{stringi-search-fixed},
#'    \item \code{stri_*_charclass} -- character classes search:
#'    more exactly, location of either Unicode General Categories or Binary Properties,
#'        see \link{stringi-search-charclass},
#' }
#'
#' Each ``engine'' is able to perform many search-based operations:
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
#' to Perl's regexes.  Their implementation loosely bases
#' on JDK 1.4 package \code{java.util.regex}.
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
#' Locale-Sensitive Text Searching in \pkg{stringi}
#'
#' @description
#' String searching facilities described in this very man page
#' provide a way to detect and extract a specific piece of
#' text. Note that locale-sensitive searching , especially on a non-English language
#' text, is a much more complex process than one may think at the first glance.
#'
#'
#'
#' @section Locale-Aware String Search Engine:
#'
#' By default, all \code{stri_*_fixed} functions in \pkg{stringi} utilize
#' \pkg{ICU}'s \code{StringSearch} engine --
#' which is a language-aware string search algorithm.
#' Note that a bitwise match will not give correct results in cases of:
#' \enumerate{
#' \item accented letters;
#' \item conjoined letters;
#' \item ignorable punctuation;
#' \item ignorable case.
#' }
#' The matches are defined using the notion of ``canonical equivalence''
#' between strings.
#'
#' This string search engines uses a modified version of the Boyer-Moore
#' algorithm (cf. Werner, 1999),
#' with time complexity of
#' O(n+p) (\code{n == length(str)}, \code{p == length(pattern)}).
#' According to the ICU User Guide,
#' the Boyer-Moore searching algorithm is based on automata
#' or combinatorial properties of strings and pre-processes
#' the pattern and known to be much faster than the linear search when
#' search pattern length is longer.
#' The Boyer-Moore search is faster than the linear search when
#' the pattern text is longer than 3 or 4 characters.
#'
#' Tuning the Collator's parameters allows you to perform correct matching
#' that properly takes into account accented letters, conjoined letters,
#' and ignorable punctuation and letter case.
#'
#' For more information on \pkg{ICU}'s Collator and SearchEngine
#' and how to tune it up
#' in \pkg{stringi}, refer to \code{\link{stri_opts_collator}}.
#'
#'
#'
#' @section Byte Compare:
#'
#' If \code{opts_collator} is \code{NA}, then a very fast (for small p)
#' bitwise (locale independent) search is performed, with time complexity of
#' O(n*p) (\code{n == length(str)}, \code{p == length(pattern)})
#' [Naive implementation
#' - to be upgraded in some future version of \pkg{stringi}].
#' For a natural language, non-English text this is, however, not what
#' you probably want.
#'
#' You should note that, however, the conversion of input data
#' to Unicode is done as usual.
#'
#' @section General Notes:
#'
#' In all the functions, if a given fixed search \code{pattern}
#' is empty, then the result is \code{NA}
#' and a warning is generated.
#'
#'
#' @references
#' \emph{ICU String Search Service} -- ICU User Guide,
#'  \url{http://userguide.icu-project.org/collation/icu-string-search-service}
#'
#' L. Werner, \emph{Efficient Text Searching in Java}, 1999,
#' \url{http://icu-project.org/docs/papers/efficient_text_searching_in_java.html}
#'
#' @name stringi-search-fixed
#' @rdname stringi-search-fixed
#' @family search_fixed
#' @family locale_sensitive
#' @family stringi_general_topics
invisible(NULL)



#' @title Character Classes in \pkg{stringi}
#'
#' @description
#' In this man page we describe how character classes are
#' declared in the \pkg{stringi} package
#' so that you may search for their occurrences in your search activities.
#'
#'
#' @details
#' All \code{stri_*_charclass} functions in \pkg{stringi} perform
#' a single character (i.e. Unicode codepoint) search-based operations.
#'
#'
#' There are two separate ways to specify character classes in \pkg{stringi}:
#' \itemize{
#' \item by claiming a Unicode General Category, e.g. \code{Lu} for uppercase letters
#' (a 1-2 letter identifier, the same may be used in regexes by specifying
#' e.g. \code{p{Lu}})
#' \item by requesting a Unicode Binary Property, e.g. \code{WHITE_SPACE}
#' }
#' Both of them provide access to the \pkg{ICU}'s Unicode Character Database
#' and are described in detail in the sections below.
#'
#' Additionally, each class identifier may be preceded with '^',
#' which is a way to request for a complement of a given character class,
#' i.e. it is used to match characters not in a class.
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
#' Each code point falls into one and only on Category.
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
#'
#'
#' @section Unicode Binary Properties:
#'
#' Binary properties identifiers are matched case-insensitively,
#' and are slightly normalized.
#' Each character may follow many Binary Properties at a time.
#'
#' Here is the complete list of supported Binary Properties:
#' \itemize{
#' \item \code{ALPHABETIC}      -- alphabetic character;
#' \item \code{ASCII_HEX_DIGIT} -- a character matching the \code{[0-9A-Fa-f]} regex;
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
#' \item \code{FULL_COMPOSITION_EXCLUSION} ;
#' \item \code{GRAPHEME_BASE}  ;
#' \item \code{GRAPHEME_EXTEND}  ;
#' \item \code{GRAPHEME_LINK}  ;
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
#' \item \code{IDS_BINARY_OPERATOR} ;
#' \item \code{IDS_TRINARY_OPERATOR} ;
#' \item \code{JOIN_CONTROL} ;
#' \item \code{LOGICAL_ORDER_EXCEPTION} ;
#' \item \code{LOWERCASE} ;
#' \item \code{MATH} ;
#' \item \code{NONCHARACTER_CODE_POINT} ;
#' \item \code{QUOTATION_MARK} ;
#' \item \code{RADICAL} ;
#' \item \code{SOFT_DOTTED} -- a character with a ``soft dot'', like i or j,
#' such that an accent placed on this character causes the dot to disappear;
#' \item \code{TERMINAL_PUNCTUATION} -- a punctuation character that generally
#' marks the end of textual units;
#' \item \code{UNIFIED_IDEOGRAPH} ;
#' \item \code{UPPERCASE} ;
#' \item \code{WHITE_SPACE} -- a space character or TAB or CR or LF or ZWSP or ZWNBSP;
#' \item \code{XID_CONTINUE} ;
#' \item \code{XID_START} ;
#' \item \code{CASE_SENSITIVE} ;
#' \item \code{S_TERM} ;
#' \item \code{VARIATION_SELECTOR} ;
#' \item \code{NFD_INERT} ;
#' \item \code{NFKD_INERT} ;
#' \item \code{NFC_INERT} ;
#' \item \code{NFKC_INERT} ;
#' \item \code{SEGMENT_STARTER} ;
#' \item \code{PATTERN_SYNTAX} ;
#' \item \code{PATTERN_WHITE_SPACE} ;
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
#'
#'
#' @references
#' \emph{The Unicode Character Database} -- Unicode Standard Annex #44,
#' \url{http://www.unicode.org/reports/tr44/}
#'
#' @name stringi-search-charclass
#' @rdname stringi-search-charclass
#' @family search_charclass
#' @family stringi_general_topics
invisible(NULL)
