# about\_stringi: THE String Processing Package

## Description

<span class="pkg">stringi</span> is THE R package for fast, correct, consistent, and convenient string/text manipulation. It gives predictable results on every platform, in each locale, and under any native character encoding.

**Keywords**: R, text processing, character strings, internationalization, localization, ICU, ICU4C, i18n, l10n, Unicode.

**Homepage**: <https://stringi.gagolewski.com/>

**License**: The BSD-3-clause license for the package code, the ICU license for the accompanying ICU4C distribution, and the UCD license for the Unicode Character Database. See the COPYRIGHTS and LICENSE file for more details.

## Details

Manual pages on general topics:

-   [about\_encoding](https://stringi.gagolewski.com/rapi/about_encoding.html) -- character encoding issues, including information on encoding management in <span class="pkg">stringi</span>, as well as on encoding detection and conversion.

-   [about\_locale](https://stringi.gagolewski.com/rapi/about_locale.html) -- locale issues, including locale management and specification in <span class="pkg">stringi</span>, and the list of locale-sensitive operations. In particular, see [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html) for a description of the string collation algorithm, which is used for string comparing, ordering, ranking, sorting, case-folding, and searching.

-   [about\_arguments](https://stringi.gagolewski.com/rapi/about_arguments.html) -- information on how <span class="pkg">stringi</span> handles the arguments passed to its function.

## Facilities available

Refer to the following:

-   [about\_search](https://stringi.gagolewski.com/rapi/about_search.html) for string searching facilities; these include pattern searching, matching, string splitting, and so on. The following independent search engines are provided:

    -   [about\_search\_regex](https://stringi.gagolewski.com/rapi/about_search_regex.html) -- with ICU (Java-like) regular expressions,

    -   [about\_search\_fixed](https://stringi.gagolewski.com/rapi/about_search_fixed.html) -- fast, locale-independent, byte-wise pattern matching,

    -   [about\_search\_coll](https://stringi.gagolewski.com/rapi/about_search_coll.html) -- locale-aware pattern matching for natural language processing tasks,

    -   [about\_search\_charclass](https://stringi.gagolewski.com/rapi/about_search_charclass.html) -- seeking elements of particular character classes, like "all whites-paces" or "all digits",

    -   [about\_search\_boundaries](https://stringi.gagolewski.com/rapi/about_search_boundaries.html) -- text boundary analysis.

-   [`stri_datetime_format`](https://stringi.gagolewski.com/rapi/stri_datetime_format.html) for date/time formatting and parsing. Also refer to the links therein for other date/time/time zone- related operations.

-   [`stri_stats_general`](https://stringi.gagolewski.com/rapi/stri_stats_general.html) and [`stri_stats_latex`](https://stringi.gagolewski.com/rapi/stri_stats_latex.html) for gathering some fancy statistics on a character vector\'s contents.

-   [`stri_join`](https://stringi.gagolewski.com/rapi/stri_join.html), [`stri_dup`](https://stringi.gagolewski.com/rapi/stri_dup.html), [`%s+%`](https://stringi.gagolewski.com/rapi/%25s+%25.html), and [`stri_flatten`](https://stringi.gagolewski.com/rapi/stri_flatten.html) for concatenation-based operations.

-   [`stri_sub`](https://stringi.gagolewski.com/rapi/stri_sub.html) for extracting and replacing substrings, and [`stri_reverse`](https://stringi.gagolewski.com/rapi/stri_reverse.html) for a joyful function to reverse all code points in a string.

-   [`stri_length`](https://stringi.gagolewski.com/rapi/stri_length.html) (among others) for determining the number of code points in a string. See also [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html) for counting the number of Unicode characters and [`stri_width`](https://stringi.gagolewski.com/rapi/stri_width.html) for approximating the width of a string.

-   [`stri_trim`](https://stringi.gagolewski.com/rapi/stri_trim.html) (among others) for trimming characters from the beginning or/and end of a string, see also [about\_search\_charclass](https://stringi.gagolewski.com/rapi/about_search_charclass.html), and [`stri_pad`](https://stringi.gagolewski.com/rapi/stri_pad.html) for padding strings so that they are of the same width. Additionally, [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html) wraps text into lines.

-   [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html) (among others) for case mapping, i.e., conversion to lower, UPPER, or Title Case, [`stri_trans_nfc`](https://stringi.gagolewski.com/rapi/stri_trans_nfc.html) (among others) for Unicode normalization, [`stri_trans_char`](https://stringi.gagolewski.com/rapi/stri_trans_char.html) for translating individual code points, and [`stri_trans_general`](https://stringi.gagolewski.com/rapi/stri_trans_general.html) for other universal yet powerful text transforms, including transliteration.

-   [`stri_cmp`](https://stringi.gagolewski.com/rapi/stri_cmp.html), [`%s<%`](https://stringi.gagolewski.com/rapi/%25s%3C%25.html), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html), and [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html) for collation-based, locale-aware operations, see also [about\_locale](https://stringi.gagolewski.com/rapi/about_locale.html).

-   [`stri_split_lines`](https://stringi.gagolewski.com/rapi/stri_split_lines.html) (among others) to split a string into text lines.

-   [`stri_escape_unicode`](https://stringi.gagolewski.com/rapi/stri_escape_unicode.html) (among others) for escaping some code points.

-   [`stri_rand_strings`](https://stringi.gagolewski.com/rapi/stri_rand_strings.html), [`stri_rand_shuffle`](https://stringi.gagolewski.com/rapi/stri_rand_shuffle.html), and [`stri_rand_lipsum`](https://stringi.gagolewski.com/rapi/stri_rand_lipsum.html) for generating (pseudo)random strings.

-   [`stri_read_raw`](https://stringi.gagolewski.com/rapi/stri_read_raw.html), [`stri_read_lines`](https://stringi.gagolewski.com/rapi/stri_read_lines.html), and [`stri_write_lines`](https://stringi.gagolewski.com/rapi/stri_write_lines.html) for reading and writing text files.

Note that each man page provides many further links to other interesting facilities and topics.

## Author(s)

Marek Gagolewski, with contributions from Bartek Tartanus and many others. ICU4C was developed by IBM, Unicode, Inc., and others.

## References

*<span class="pkg">stringi</span> Package homepage*, <https://stringi.gagolewski.com/>

*ICU -- International Components for Unicode*, <http://site.icu-project.org/>

*ICU4C API Documentation*, <https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/>

*The Unicode Consortium*, <https://home.unicode.org/>

*UTF-8, a transformation format of ISO 10646* -- RFC 3629, <https://tools.ietf.org/html/rfc3629>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other stringi\_general\_topics: [`about_arguments`](https://stringi.gagolewski.com/rapi/about_arguments.html), [`about_encoding`](https://stringi.gagolewski.com/rapi/about_encoding.html), [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_charclass`](https://stringi.gagolewski.com/rapi/about_search_charclass.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`about_search_fixed`](https://stringi.gagolewski.com/rapi/about_search_fixed.html), [`about_search_regex`](https://stringi.gagolewski.com/rapi/about_search_regex.html), [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html)
