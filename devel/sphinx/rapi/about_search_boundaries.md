# about\_search\_boundaries: Text Boundary Analysis in <span class="pkg">stringi</span>

## Description

Text boundary analysis is the process of locating linguistic boundaries while formatting and handling text.

## Details

Examples of the boundary analysis process include:

-   Locating positions to word-wrap text to fit within specific margins while displaying or printing, see [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html) and [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html).

-   Counting characters, words, sentences, or paragraphs, see [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html).

-   Making a list of the unique words in a document, see [`stri_extract_all_words`](https://stringi.gagolewski.com/rapi/stri_extract_all_words.html) and then [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html).

-   Capitalizing the first letter of each word or sentence, see also [`stri_trans_totitle`](https://stringi.gagolewski.com/rapi/stri_trans_totitle.html).

-   Locating a particular unit of the text (for example, finding the third word in the document), see [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html).

Generally, text boundary analysis is a locale-dependent operation. For example, in Japanese and Chinese one does not separate words with spaces - a line break can occur even in the middle of a word. These languages have punctuation and diacritical marks that cannot start or end a line, so this must also be taken into account.

<span class="pkg">stringi</span> uses <span class="pkg">ICU</span>\'s `BreakIterator` to locate specific text boundaries. Note that the `BreakIterator`\'s behavior may be controlled in come cases, see [`stri_opts_brkiter`](https://stringi.gagolewski.com/rapi/stri_opts_brkiter.html).

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

Other locale\_sensitive: [`%s<%`](https://stringi.gagolewski.com/rapi/%25s%3C%25.html)(), [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

Other text\_boundaries: [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_brkiter`](https://stringi.gagolewski.com/rapi/stri_opts_brkiter.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_split_lines`](https://stringi.gagolewski.com/rapi/stri_split_lines.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

Other stringi\_general\_topics: [`about_arguments`](https://stringi.gagolewski.com/rapi/about_arguments.html), [`about_encoding`](https://stringi.gagolewski.com/rapi/about_encoding.html), [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_charclass`](https://stringi.gagolewski.com/rapi/about_search_charclass.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`about_search_fixed`](https://stringi.gagolewski.com/rapi/about_search_fixed.html), [`about_search_regex`](https://stringi.gagolewski.com/rapi/about_search_regex.html), [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`about_stringi`](https://stringi.gagolewski.com/rapi/about_stringi.html)
