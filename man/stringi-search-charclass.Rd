\name{stringi-search-charclass}
\alias{stringi-search-charclass}
\title{Character Classes in \pkg{stringi}}
\description{
In this man page we describe how character classes are
declared in the \pkg{stringi} package so that you may
search for their occurrences in your search activities.
}
\details{
All \code{stri_*_charclass} functions in \pkg{stringi}
perform a single character (i.e. Unicode codepoint)
search-based operations.

There are two separate ways to specify character classes in
\pkg{stringi}: \itemize{ \item by claiming a Unicode
General Category, e.g. \code{Lu} for uppercase letters (a
1-2 letter identifier, the same may be used in regexes by
specifying e.g. \code{p{Lu}}) \item by requesting a Unicode
Binary Property, e.g. \code{WHITE_SPACE} } Both of them
provide access to the \pkg{ICU}'s Unicode Character
Database and are described in detail in the sections below.

Additionally, each class identifier may be preceded with
'^', which is a way to request for a complement of a given
character class, i.e. it is used to match characters not in
a class.

Please note that some classes may seem to overlap. However,
e.g. General Category \code{Z} (some space) and Binary
Property \code{WHITE_SPACE} matches different character
sets.
}
\section{Unicode General Categories}{
  The Unicode General Category property of a code point
  provides the most general classification of that code
  point. Each code point falls into one and only on
  Category.

  \itemize{ \item \code{Cc} -- a C0 or C1 control code;
  \item \code{Cf} -- a format control character; \item
  \code{Cn} -- a reserved unassigned code point or a
  non-character; \item \code{Co} -- a private-use
  character; \item \code{Cs} -- a surrogate code point;
  \item \code{Lc} -- the union of Lu, Ll, Lt; \item
  \code{Ll} -- a lowercase letter; \item \code{Lm} -- a
  modifier letter; \item \code{Lo} -- other letters,
  including syllables and ideographs; \item \code{Lt} -- a
  digraphic character, with first part uppercase; \item
  \code{Lu} -- an uppercase letter; \item \code{Mc} -- a
  spacing combining mark (positive advance width); \item
  \code{Me} -- an enclosing combining mark; \item \code{Mn}
  -- a non-spacing combining mark (zero advance width);
  \item \code{Nd} -- a decimal digit; \item \code{Nl} -- a
  letter-like numeric character; \item \code{No} -- a
  numeric character of other type; \item \code{Pd} -- a
  dash or hyphen punctuation mark; \item \code{Ps} -- an
  opening punctuation mark (of a pair); \item \code{Pe} --
  a closing punctuation mark (of a pair); \item \code{Pc}
  -- a connecting punctuation mark, like a tie; \item
  \code{Po} -- a punctuation mark of other type; \item
  \code{Pi} -- an initial quotation mark; \item \code{Pf}
  -- a final quotation mark; \item \code{Sm} -- a symbol of
  mathematical use; \item \code{Sc} -- a currency sign;
  \item \code{Sk} -- a non-letter-like modifier symbol;
  \item \code{So} -- a symbol of other type; \item
  \code{Zs} -- a space character (of non-zero width); \item
  \code{Zl} -- U+2028 LINE SEPARATOR only; \item \code{Zp}
  -- U+2029 PARAGRAPH SEPARATOR only; \item \code{C} -- the
  union of Cc, Cf, Cs, Co, Cn; \item \code{L} -- the union
  of Lu, Ll, Lt, Lm, Lo; \item \code{M} -- the union of Mn,
  Mc, Me; \item \code{N} -- the union of Nd, Nl, No; \item
  \code{P} -- the union of Pc, Pd, Ps, Pe, Pi, Pf, Po;
  \item \code{S} -- the union of Sm, Sc, Sk, So; \item
  \code{Z} -- the union of Zs, Zl, Zp. }
}

\section{Unicode Binary Properties}{
  Binary properties identifiers are matched
  case-insensitively, and are slightly normalized. Each
  character may follow many Binary Properties at a time.

  Here is the complete list of supported Binary Properties:
  \itemize{ \item \code{ALPHABETIC} -- alphabetic
  character; \item \code{ASCII_HEX_DIGIT} -- a character
  matching the \code{[0-9A-Fa-f]} regex; \item
  \code{BIDI_CONTROL} -- a format control which have
  specific functions in the Bidi (bidirectional text)
  Algorithm; \item \code{BIDI_MIRRORED} -- a character that
  may change display in right-to-left text; \item
  \code{DASH} -- a kind of a dash character; \item
  \code{DEFAULT_IGNORABLE_CODE_POINT} -- characters that
  are ignorable in most text processing activities, e.g.
  <2060..206F, FFF0..FFFB, E0000..E0FFF>; \item
  \code{DEPRECATED} -- a deprecated character according to
  the current Unicode standard (the usage of deprecated
  characters is strongly discouraged); \item
  \code{DIACRITIC} -- a character that linguistically
  modifies the meaning of another character to which it
  applies; \item \code{EXTENDER} -- a character that
  extends the value or shape of a preceding alphabetic
  character, e.g. a length and iteration mark. \item
  \code{FULL_COMPOSITION_EXCLUSION} ; \item
  \code{GRAPHEME_BASE} ; \item \code{GRAPHEME_EXTEND} ;
  \item \code{GRAPHEME_LINK} ; \item \code{HEX_DIGIT} -- a
  character commonly used for hexadecimal numbers, cf. also
  \code{ASCII_HEX_DIGIT}; \item \code{HYPHEN} -- a dash
  used to mark connections between pieces of words, plus
  the Katakana middle dot; \item \code{ID_CONTINUE} -- a
  character that can continue an identifier,
  \code{ID_START}+\code{Mn}+\code{Mc}+\code{Nd}+\code{Pc};
  \item \code{ID_START} -- a character that can start an
  identifier,
  \code{Lu}+\code{Ll}+\code{Lt}+\code{Lm}+\code{Lo}+\code{Nl};
  \item \code{IDEOGRAPHIC} -- a CJKV
  (Chinese-Japanese-Korean-Vietnamese) ideograph; \item
  \code{IDS_BINARY_OPERATOR} ; \item
  \code{IDS_TRINARY_OPERATOR} ; \item \code{JOIN_CONTROL} ;
  \item \code{LOGICAL_ORDER_EXCEPTION} ; \item
  \code{LOWERCASE} ; \item \code{MATH} ; \item
  \code{NONCHARACTER_CODE_POINT} ; \item
  \code{QUOTATION_MARK} ; \item \code{RADICAL} ; \item
  \code{SOFT_DOTTED} -- a character with a ``soft dot'',
  like i or j, such that an accent placed on this character
  causes the dot to disappear; \item
  \code{TERMINAL_PUNCTUATION} -- a punctuation character
  that generally marks the end of textual units; \item
  \code{UNIFIED_IDEOGRAPH} ; \item \code{UPPERCASE} ; \item
  \code{WHITE_SPACE} -- a space character or TAB or CR or
  LF or ZWSP or ZWNBSP; \item \code{XID_CONTINUE} ; \item
  \code{XID_START} ; \item \code{CASE_SENSITIVE} ; \item
  \code{S_TERM} ; \item \code{VARIATION_SELECTOR} ; \item
  \code{NFD_INERT} ; \item \code{NFKD_INERT} ; \item
  \code{NFC_INERT} ; \item \code{NFKC_INERT} ; \item
  \code{SEGMENT_STARTER} ; \item \code{PATTERN_SYNTAX} ;
  \item \code{PATTERN_WHITE_SPACE} ; \item
  \code{POSIX_ALNUM} ; \item \code{POSIX_BLANK} ; \item
  \code{POSIX_GRAPH} ; \item \code{POSIX_PRINT} ; \item
  \code{POSIX_XDIGIT} ; \item \code{CASED} ; \item
  \code{CASE_IGNORABLE} ; \item
  \code{CHANGES_WHEN_LOWERCASED} ; \item
  \code{CHANGES_WHEN_UPPERCASED} ; \item
  \code{CHANGES_WHEN_TITLECASED} ; \item
  \code{CHANGES_WHEN_CASEFOLDED} ; \item
  \code{CHANGES_WHEN_CASEMAPPED} ; \item
  \code{CHANGES_WHEN_NFKC_CASEFOLDED}. }
}
\references{
\emph{The Unicode Character Database} -- Unicode Standard
Annex #44, \url{http://www.unicode.org/reports/tr44/}
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
\code{\link{stri_trim_right}}; \code{\link{stringi-search}}

Other stringi_general_topics:
\code{\link{stringi-arguments}};
\code{\link{stringi-encoding}};
\code{\link{stringi-locale}};
\code{\link{stringi-package}};
\code{\link{stringi-search-fixed}};
\code{\link{stringi-search-regex}};
\code{\link{stringi-search}}
}

