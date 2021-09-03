# about\_search\_boundaries: Text Boundary Analysis in <span class="pkg">stringi</span>

## Description

Text boundary analysis is the process of locating linguistic boundaries while formatting and handling text.

## Details

Examples of the boundary analysis process include:

-   Locating positions to word-wrap text to fit within specific margins while displaying or printing, see [`stri_wrap`](stri_wrap.md) and [`stri_split_boundaries`](stri_split_boundaries.md).

-   Counting characters, words, sentences, or paragraphs, see [`stri_count_boundaries`](stri_count_boundaries.md).

-   Making a list of the unique words in a document, see [`stri_extract_all_words`](stri_extract_boundaries.md) and then [`stri_unique`](stri_unique.md).

-   Capitalizing the first letter of each word or sentence, see also [`stri_trans_totitle`](stri_trans_casemap.md).

-   Locating a particular unit of the text (for example, finding the third word in the document), see [`stri_locate_all_boundaries`](stri_locate_boundaries.md).

Generally, text boundary analysis is a locale-dependent operation. For example, in Japanese and Chinese one does not separate words with spaces - a line break can occur even in the middle of a word. These languages have punctuation and diacritical marks that cannot start or end a line, so this must also be taken into account.

<span class="pkg">stringi</span> uses <span class="pkg">ICU</span>\'s `BreakIterator` to locate specific text boundaries. Note that the `BreakIterator`\'s behavior may be controlled in come cases, see [`stri_opts_brkiter`](stri_opts_brkiter.md).

-   The `character` boundary iterator tries to match what a user would think of as a "character" -- a basic unit of a writing system for a language -- which may be more than just a single Unicode code point.

-   The `word` boundary iterator locates the boundaries of words, for purposes such as "Find whole words" operations.

-   The `line_break` iterator locates positions that would be appropriate to wrap lines when displaying the text.

-   The break iterator of type `sentence` locates sentence boundaries.

For technical details on different classes of text boundaries refer to the <span class="pkg">ICU</span> User Guide, see below.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Boundary Analysis* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/boundaryanalysis/>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other locale\_sensitive: [`%s<%()`](+25s+3C+25.md), [`about_locale`](about_locale.md), [`about_search_coll`](about_search_coll.md), [`stri_compare()`](stri_compare.md), [`stri_count_boundaries()`](stri_count_boundaries.md), [`stri_duplicated()`](stri_duplicated.md), [`stri_enc_detect2()`](stri_enc_detect2.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_opts_collator()`](stri_opts_collator.md), [`stri_order()`](stri_order.md), [`stri_rank()`](stri_rank.md), [`stri_sort_key()`](stri_sort_key.md), [`stri_sort()`](stri_sort.md), [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_trans_tolower()`](stri_trans_casemap.md), [`stri_unique()`](stri_unique.md), [`stri_wrap()`](stri_wrap.md)

Other text\_boundaries: [`about_search`](about_search.md), [`stri_count_boundaries()`](stri_count_boundaries.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_opts_brkiter()`](stri_opts_brkiter.md), [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_split_lines()`](stri_split_lines.md), [`stri_trans_tolower()`](stri_trans_casemap.md), [`stri_wrap()`](stri_wrap.md)

Other stringi\_general\_topics: [`about_arguments`](about_arguments.md), [`about_encoding`](about_encoding.md), [`about_locale`](about_locale.md), [`about_search_charclass`](about_search_charclass.md), [`about_search_coll`](about_search_coll.md), [`about_search_fixed`](about_search_fixed.md), [`about_search_regex`](about_search_regex.md), [`about_search`](about_search.md), [`about_stringi`](about_stringi.md)
