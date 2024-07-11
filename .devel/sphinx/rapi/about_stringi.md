# about_stringi: Fast and Portable Character String Processing in R

## Description

<span class="pkg">stringi</span> is THE R package for fast, correct, consistent, and convenient string/text manipulation. It gives predictable results on every platform, in each locale, and under any native character encoding.

**Keywords**: R, text processing, character strings, internationalization, localization, ICU, ICU4C, i18n, l10n, Unicode.

**Homepage**: <https://stringi.gagolewski.com/>

**License**: The BSD-3-clause license for the package code, the ICU license for the accompanying ICU4C distribution, and the UCD license for the Unicode Character Database. See the COPYRIGHTS and LICENSE file for more details.

## Details

Manual pages on general topics:

-   [about_encoding](about_encoding.md) -- character encoding issues, including information on encoding management in <span class="pkg">stringi</span>, as well as on encoding detection and conversion.

-   [about_locale](about_locale.md) -- locale issues, including locale management and specification in <span class="pkg">stringi</span>, and the list of locale-sensitive operations. In particular, see [`stri_opts_collator`](stri_opts_collator.md) for a description of the string collation algorithm, which is used for string comparing, ordering, ranking, sorting, case-folding, and searching.

-   [about_arguments](about_arguments.md) -- information on how <span class="pkg">stringi</span> handles the arguments passed to its function.

## Facilities available

Refer to the following:

-   [about_search](about_search.md) for string searching facilities; these include pattern searching, matching, string splitting, and so on. The following independent search engines are provided:

    -   [about_search_regex](about_search_regex.md) -- with ICU (Java-like) regular expressions,

    -   [about_search_fixed](about_search_fixed.md) -- fast, locale-independent, byte-wise pattern matching,

    -   [about_search_coll](about_search_coll.md) -- locale-aware pattern matching for natural language processing tasks,

    -   [about_search_charclass](about_search_charclass.md) -- seeking elements of particular character classes, like "all whites-paces" or "all digits",

    -   [about_search_boundaries](about_search_boundaries.md) -- text boundary analysis.

-   [`stri_datetime_format`](stri_datetime_format.md) for date/time formatting and parsing. Also refer to the links therein for other date/time/time zone- related operations.

-   [`stri_stats_general`](stri_stats_general.md) and [`stri_stats_latex`](stri_stats_latex.md) for gathering some fancy statistics on a character vector\'s contents.

-   [`stri_join`](stri_join.md), [`stri_dup`](stri_dup.md), [`%s+%`](+25s+2B+25.md), and [`stri_flatten`](stri_flatten.md) for concatenation-based operations.

-   [`stri_sub`](stri_sub.md) for extracting and replacing substrings, and [`stri_reverse`](stri_reverse.md) for a joyful function to reverse all code points in a string.

-   [`stri_length`](stri_length.md) (among others) for determining the number of code points in a string. See also [`stri_count_boundaries`](stri_count_boundaries.md) for counting the number of Unicode characters and [`stri_width`](stri_width.md) for approximating the width of a string.

-   [`stri_trim`](stri_trim.md) (among others) for trimming characters from the beginning or/and end of a string, see also [about_search_charclass](about_search_charclass.md), and [`stri_pad`](stri_pad.md) for padding strings so that they are of the same width. Additionally, [`stri_wrap`](stri_wrap.md) wraps text into lines.

-   [`stri_trans_tolower`](stri_trans_casemap.md) (among others) for case mapping, i.e., conversion to lower, UPPER, or Title Case, [`stri_trans_nfc`](stri_trans_nf.md) (among others) for Unicode normalization, [`stri_trans_char`](stri_trans_char.md) for translating individual code points, and [`stri_trans_general`](stri_trans_general.md) for other universal text transforms, including transliteration.

-   [`stri_cmp`](stri_compare.md), [`%s<%`](+25s+3C+25.md), [`stri_order`](stri_order.md), [`stri_sort`](stri_sort.md), [`stri_rank`](stri_rank.md), [`stri_unique`](stri_unique.md), and [`stri_duplicated`](stri_duplicated.md) for collation-based, locale-aware operations, see also [about_locale](about_locale.md).

-   [`stri_split_lines`](stri_split_lines.md) (among others) to split a string into text lines.

-   [`stri_escape_unicode`](stri_escape_unicode.md) (among others) for escaping some code points.

-   [`stri_rand_strings`](stri_rand_strings.md), [`stri_rand_shuffle`](stri_rand_shuffle.md), and [`stri_rand_lipsum`](stri_rand_lipsum.md) for generating (pseudo)random strings.

-   [`stri_read_raw`](stri_read_raw.md), [`stri_read_lines`](stri_read_lines.md), and [`stri_write_lines`](stri_write_lines.md) for reading and writing text files.

Note that each man page provides many further links to other interesting facilities and topics.

## Author(s)

Marek Gagolewski, with contributions from Bartek Tartanus and many others. ICU4C was developed by IBM, Unicode, Inc., and others.

## References

*<span class="pkg">stringi</span> Package Homepage*, <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

*ICU -- International Components for Unicode*, <https://icu.unicode.org/>

*ICU4C API Documentation*, <https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/>

*The Unicode Consortium*, <https://home.unicode.org/>

*UTF-8, A Transformation Format of ISO 10646* -- RFC 3629, <https://www.rfc-editor.org/rfc/rfc3629>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other stringi_general_topics: [`about_arguments`](about_arguments.md), [`about_encoding`](about_encoding.md), [`about_locale`](about_locale.md), [`about_search`](about_search.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_charclass`](about_search_charclass.md), [`about_search_coll`](about_search_coll.md), [`about_search_fixed`](about_search_fixed.md), [`about_search_regex`](about_search_regex.md)
