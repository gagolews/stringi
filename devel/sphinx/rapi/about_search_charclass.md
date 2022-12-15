# about_search_charclass: Character Classes in <span class="pkg">stringi</span>

## Description

Here we describe how character classes (sets) can be specified in the <span class="pkg">stringi</span> package. These are useful for defining search patterns (note that the <span class="pkg">ICU</span> regex engine uses the same scheme for denoting character classes) or, e.g., generating random code points with [`stri_rand_strings`](stri_rand_strings.md).

## Details

All `stri_*_charclass` functions in <span class="pkg">stringi</span> perform a single character (i.e., Unicode code point) search-based operations. You may obtain the same results using [about_search_regex](about_search_regex.md). However, these very functions aim to be faster.

Character classes are defined using <span class="pkg">ICU</span>\'s `UnicodeSet` patterns. Below we briefly summarize their syntax. For more details refer to the bibliographic References below.

## `UnicodeSet` patterns

A `UnicodeSet` represents a subset of Unicode code points (recall that <span class="pkg">stringi</span> converts strings in your native encoding to Unicode automatically). Legal code points are U+0000 to U+10FFFF, inclusive.

Patterns either consist of series of characters bounded by square brackets (such patterns follow a syntax similar to that employed by regular expression character classes) or of Perl-like Unicode property set specifiers.

`[]` denotes an empty set, `[a]` -- a set consisting of character "a", `[\u0105]` -- a set with character U+0105, and `[abc]` -- a set with "a", "b", and "c".

`[a-z]` denotes a set consisting of characters "a" through "z" inclusively, in Unicode code point order.

Some set-theoretic operations are available. `^` denotes the complement, e.g., `[^a-z]` contains all characters but "a" through "z". Moreover, `[[pat1][pat2]]`, `[[pat1]\&[pat2]]`, and `[[pat1]-[pat2]]` denote union, intersection, and asymmetric difference of sets specified by `pat1` and `pat2`, respectively.

Note that all white-spaces are ignored unless they are quoted or back-slashed (white spaces can be freely used for clarity, as `[a c d-f m]` means the same as `[acd-fm]`). <span class="pkg">stringi</span> does not allow including multi-character strings (see `UnicodeSet` API documentation). Also, empty string patterns are disallowed.

Any character may be preceded by a backslash in order to remove its special meaning.

A malformed pattern always results in an error.

Set expressions at a glance (according to <https://unicode-org.github.io/icu/userguide/strings/regexp.html>):

Some examples:

`[abc]`

:   Match any of the characters a, b or c.

`[^abc]`

:   Negation -- match any character except a, b or c.

`[A-M]`

:   Range -- match any character from A to M. The characters to include are determined by Unicode code point ordering.

`[\u0000-\U0010ffff]`

:   Range -- match all characters.

`[\p{Letter}]` or `[\p{General_Category=Letter}]` or `[\p{L}]`

:   Characters with Unicode Category = Letter. All forms shown are equivalent.

`[\P{Letter}]`

:   Negated property (Note the upper case `\P`) -- match everything except Letters.

`[\p{numeric_value=9}]`

:   Match all numbers with a numeric value of 9. Any Unicode Property may be used in set expressions.

`[\p{Letter}&\p{script=cyrillic}]`

:   Set intersection -- match the set of all Cyrillic letters.

`[\p{Letter}-\p{script=latin}]`

:   Set difference -- match all non-Latin letters.

`[[a-z][A-Z][0-9]]` or `[a-zA-Z0-9]`

:   Implicit union of sets -- match ASCII letters and digits (the two forms are equivalent).

`[:script=Greek:]`

:   Alternative POSIX-like syntax for properties -- equivalent to `\p{script=Greek}`.

## Unicode properties

Unicode property sets are specified with a POSIX-like syntax, e.g., `[:Letter:]`, or with a (extended) Perl-style syntax, e.g., `\p{L}`. The complements of the above sets are `[:^Letter:]` and `\P{L}`, respectively.

The names are normalized before matching (for example, the match is case-insensitive). Moreover, many names have short aliases.

Among predefined Unicode properties we find, e.g.:

-   Unicode General Categories, e.g., `Lu` for uppercase letters,

-   Unicode Binary Properties, e.g., `WHITE_SPACE`,

and many more (including Unicode scripts).

Each property provides access to the large and comprehensive Unicode Character Database. Generally, the list of properties available in <span class="pkg">ICU</span> is not well-documented. Please refer to the References section for some links.

Please note that some classes might overlap. However, e.g., General Category `Z` (some space) and Binary Property `WHITE_SPACE` matches different character sets.

## Unicode General Categories

The Unicode General Category property of a code point provides the most general classification of that code point. Each code point falls into one and only one Category.

`Cc`

:   a C0 or C1 control code.

`Cf`

:   a format control character.

`Cn`

:   a reserved unassigned code point or a non-character.

`Co`

:   a private-use character.

`Cs`

:   a surrogate code point.

`Lc`

:   the union of Lu, Ll, Lt.

`Ll`

:   a lowercase letter.

`Lm`

:   a modifier letter.

`Lo`

:   other letters, including syllables and ideographs.

`Lt`

:   a digraphic character, with the first part uppercase.

`Lu`

:   an uppercase letter.

`Mc`

:   a spacing combining mark (positive advance width).

`Me`

:   an enclosing combining mark.

`Mn`

:   a non-spacing combining mark (zero advance width).

`Nd`

:   a decimal digit.

`Nl`

:   a letter-like numeric character.

`No`

:   a numeric character of other type.

`Pd`

:   a dash or hyphen punctuation mark.

`Ps`

:   an opening punctuation mark (of a pair).

`Pe`

:   a closing punctuation mark (of a pair).

`Pc`

:   a connecting punctuation mark, like a tie.

`Po`

:   a punctuation mark of other type.

`Pi`

:   an initial quotation mark.

`Pf`

:   a final quotation mark.

`Sm`

:   a symbol of mathematical use.

`Sc`

:   a currency sign.

`Sk`

:   a non-letter-like modifier symbol.

`So`

:   a symbol of other type.

`Zs`

:   a space character (of non-zero width).

`Zl`

:   U+2028 LINE SEPARATOR only.

`Zp`

:   U+2029 PARAGRAPH SEPARATOR only.

`C`

:   the union of Cc, Cf, Cs, Co, Cn.

`L`

:   the union of Lu, Ll, Lt, Lm, Lo.

`M`

:   the union of Mn, Mc, Me.

`N`

:   the union of Nd, Nl, No.

`P`

:   the union of Pc, Pd, Ps, Pe, Pi, Pf, Po.

`S`

:   the union of Sm, Sc, Sk, So.

`Z`

:   the union of Zs, Zl, Zp

## Unicode Binary Properties

Each character may follow many Binary Properties at a time.

Here is a comprehensive list of supported Binary Properties:

`ALPHABETIC`

:   alphabetic character.

`ASCII_HEX_DIGIT`

:   a character matching the `[0-9A-Fa-f]` charclass.

`BIDI_CONTROL`

:   a format control which have specific functions in the Bidi (bidirectional text) Algorithm.

`BIDI_MIRRORED`

:   a character that may change display in right-to-left text.

`DASH`

:   a kind of a dash character.

`DEFAULT_IGNORABLE_CODE_POINT`

:   characters that are ignorable in most text processing activities, e.g., \<2060..206F, FFF0..FFFB, E0000..E0FFF\>.

`DEPRECATED`

:   a deprecated character according to the current Unicode standard (the usage of deprecated characters is strongly discouraged).

`DIACRITIC`

:   a character that linguistically modifies the meaning of another character to which it applies.

`EXTENDER`

:   a character that extends the value or shape of a preceding alphabetic character, e.g., a length and iteration mark.

`HEX_DIGIT`

:   a character commonly used for hexadecimal numbers, see also `ASCII_HEX_DIGIT`.

`HYPHEN`

:   a dash used to mark connections between pieces of words, plus the Katakana middle dot.

`ID_CONTINUE`

:   a character that can continue an identifier, `ID_START`+`Mn`+`Mc`+`Nd`+`Pc`.

`ID_START`

:   a character that can start an identifier, `Lu`+`Ll`+`Lt`+`Lm`+`Lo`+`Nl`.

`IDEOGRAPHIC`

:   a CJKV (Chinese-Japanese-Korean-Vietnamese) ideograph.

`LOWERCASE`

:   \...

`MATH`

:   \...

`NONCHARACTER_CODE_POINT`

:   \...

`QUOTATION_MARK`

:   \...

`SOFT_DOTTED`

:   a character with a "soft dot", like i or j, such that an accent placed on this character causes the dot to disappear.

`TERMINAL_PUNCTUATION`

:   a punctuation character that generally marks the end of textual units.

`UPPERCASE`

:   \...

`WHITE_SPACE`

:   a space character or TAB or CR or LF or ZWSP or ZWNBSP.

`CASE_SENSITIVE`

:   \...

`POSIX_ALNUM`

:   \...

`POSIX_BLANK`

:   \...

`POSIX_GRAPH`

:   \...

`POSIX_PRINT`

:   \...

`POSIX_XDIGIT`

:   \...

`CASED`

:   \...

`CASE_IGNORABLE`

:   \...

`CHANGES_WHEN_LOWERCASED`

:   \...

`CHANGES_WHEN_UPPERCASED`

:   \...

`CHANGES_WHEN_TITLECASED`

:   \...

`CHANGES_WHEN_CASEFOLDED`

:   \...

`CHANGES_WHEN_CASEMAPPED`

:   \...

`CHANGES_WHEN_NFKC_CASEFOLDED`

:   \...

`EMOJI`

:   Since ICU 57

`EMOJI_PRESENTATION`

:   Since ICU 57

`EMOJI_MODIFIER`

:   Since ICU 57

`EMOJI_MODIFIER_BASE`

:   Since ICU 57

## POSIX Character Classes

Avoid using POSIX character classes, e.g., `[:punct:]`. The ICU User Guide (see below) states that in general they are not well-defined, so you may end up with something different than you expect.

In particular, in POSIX-like regex engines, `[:punct:]` stands for the character class corresponding to the `ispunct()` classification function (check out `man 3 ispunct` on UNIX-like systems). According to ISO/IEC 9899:1990 (ISO C90), the `ispunct()` function tests for any printing character except for space or a character for which `isalnum()` is true. However, in a POSIX setting, the details of what characters belong into which class depend on the current locale. So the `[:punct:]` class does not lead to a portable code (again, in POSIX-like regex engines).

Therefore, a POSIX flavor of `[:punct:]` is more like `[\p{P}\p{S}]` in <span class="pkg">ICU</span>. You have been warned.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*The Unicode Character Database* -- Unicode Standard Annex #44, <https://www.unicode.org/reports/tr44/>

*UnicodeSet* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/strings/unicodeset.html>

*Properties* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/strings/properties.html>

*C/POSIX Migration* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/icu/posix.html>

*Unicode Script Data*, <https://www.unicode.org/Public/UNIDATA/Scripts.txt>

*icu::Unicodeset Class Reference* -- ICU4C API Documentation, <https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/classicu_1_1UnicodeSet.html>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other search_charclass: [`about_search`](about_search.md), [`stri_trim_both()`](stri_trim.md)

Other stringi_general_topics: [`about_arguments`](about_arguments.md), [`about_encoding`](about_encoding.md), [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_coll`](about_search_coll.md), [`about_search_fixed`](about_search_fixed.md), [`about_search_regex`](about_search_regex.md), [`about_search`](about_search.md), [`about_stringi`](about_stringi.md)
