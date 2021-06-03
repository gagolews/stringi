# stri\_count\_boundaries: Count the Number of Text Boundaries

## Description

These functions determine the number of text boundaries (like character, word, line, or sentence boundaries) in a string.

## Usage

```r
stri_count_boundaries(str, ..., opts_brkiter = NULL)

stri_count_words(str, locale = NULL)
```

## Arguments

|                |                                                                                                                                                                                                                            |
|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`          | character vector or an object coercible to                                                                                                                                                                                 |
| `...`          | additional settings for `opts_brkiter`                                                                                                                                                                                     |
| `opts_brkiter` | a named list with <span class="pkg">ICU</span> BreakIterator\'s settings, see [`stri_opts_brkiter`](https://stringi.gagolewski.com/rapi/stri_opts_brkiter.html); `NULL` for the default break iterator, i.e., `line_break` |
| `locale`       | `NULL` or `''` for text boundary analysis following the conventions of the default locale, or a single string with locale identifier, see [stringi-locale](../../stringi/help/stringi-locale.html)                         |

## Details

Vectorized over `str`.

For more information on text boundary analysis performed by <span class="pkg">ICU</span>\'s `BreakIterator`, see [stringi-search-boundaries](../../stringi/help/stringi-search-boundaries.html).

In case of `stri_count_words`, just like in [`stri_extract_all_words`](https://stringi.gagolewski.com/rapi/stri_extract_all_words.html) and [`stri_locate_all_words`](https://stringi.gagolewski.com/rapi/stri_locate_all_words.html), <span class="pkg">ICU</span>\'s word `BreakIterator` iterator is used to locate the word boundaries, and all non-word characters (`UBRK_WORD_NONE` rule status) are ignored. This function is equivalent to a call to [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(str, type=\'word\', skip\_word\_none=TRUE, locale=locale).

Note that a `BreakIterator` of type `character` may be used to count the number of *Unicode characters* in a string. The [`stri_length`](https://stringi.gagolewski.com/rapi/stri_length.html) function, which aims to count the number of *Unicode code points*, might report different results.

Moreover, a `BreakIterator` of type `sentence` may be used to count the number of sentences in a text piece.

## Value

Both functions return an integer vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other search\_count: [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`stri_count`](https://stringi.gagolewski.com/rapi/stri_count.html)()

Other locale\_sensitive: `%s<%()`, [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

Other text\_boundaries: [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_brkiter`](https://stringi.gagolewski.com/rapi/stri_opts_brkiter.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_split_lines`](https://stringi.gagolewski.com/rapi/stri_split_lines.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

## Examples




```r
test <- 'The\u00a0above-mentioned    features are very useful. Spam, spam, eggs, bacon, and spam.'
stri_count_boundaries(test, type='word')
## [1] 31
stri_count_boundaries(test, type='sentence')
## [1] 2
stri_count_boundaries(test, type='character')
## [1] 83
stri_count_words(test)
## [1] 13
test2 <- stri_trans_nfkd('\u03c0\u0153\u0119\u00a9\u00df\u2190\u2193\u2192')
stri_count_boundaries(test2, type='character')
## [1] 8
stri_length(test2)
## [1] 9
stri_numbytes(test2)
## [1] 20
```
