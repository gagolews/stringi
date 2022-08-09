# stri_count_boundaries: Count the Number of Text Boundaries

## Description

These functions determine the number of text boundaries (like character, word, line, or sentence boundaries) in a string.

## Usage

``` r
stri_count_boundaries(str, ..., opts_brkiter = NULL)

stri_count_words(str, locale = NULL)
```

## Arguments

|                |                                                                                                                                                                                      |
|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`          | character vector or an object coercible to                                                                                                                                           |
| `...`          | additional settings for `opts_brkiter`                                                                                                                                               |
| `opts_brkiter` | a named list with <span class="pkg">ICU</span> BreakIterator\'s settings, see [`stri_opts_brkiter`](stri_opts_brkiter.md); `NULL` for the default break iterator, i.e., `line_break` |
| `locale`       | `NULL` or `''` for text boundary analysis following the conventions of the default locale, or a single string with locale identifier, see [stringi-locale](about_locale.md)          |

## Details

Vectorized over `str`.

For more information on text boundary analysis performed by <span class="pkg">ICU</span>\'s `BreakIterator`, see [stringi-search-boundaries](about_search_boundaries.md).

In case of `stri_count_words`, just like in [`stri_extract_all_words`](stri_extract_boundaries.md) and [`stri_locate_all_words`](stri_locate_boundaries.md), <span class="pkg">ICU</span>\'s word `BreakIterator` iterator is used to locate the word boundaries, and all non-word characters (`UBRK_WORD_NONE` rule status) are ignored. This function is equivalent to a call to [`stri_count_boundaries(str, type='word', skip_word_none=TRUE, locale=locale)`](stri_count_boundaries.md).

Note that a `BreakIterator` of type `character` may be used to count the number of *Unicode characters* in a string. The [`stri_length`](stri_length.md) function, which aims to count the number of *Unicode code points*, might report different results.

Moreover, a `BreakIterator` of type `sentence` may be used to count the number of sentences in a text piece.

## Value

Both functions return an integer vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other search_count: [`about_search`](about_search.md), [`stri_count()`](stri_count.md)

Other locale_sensitive: [`%s<%()`](+25s+3C+25.md), [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_coll`](about_search_coll.md), [`stri_compare()`](stri_compare.md), [`stri_duplicated()`](stri_duplicated.md), [`stri_enc_detect2()`](stri_enc_detect2.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_opts_collator()`](stri_opts_collator.md), [`stri_order()`](stri_order.md), [`stri_rank()`](stri_rank.md), [`stri_sort_key()`](stri_sort_key.md), [`stri_sort()`](stri_sort.md), [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_trans_tolower()`](stri_trans_casemap.md), [`stri_unique()`](stri_unique.md), [`stri_wrap()`](stri_wrap.md)

Other text_boundaries: [`about_search_boundaries`](about_search_boundaries.md), [`about_search`](about_search.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_opts_brkiter()`](stri_opts_brkiter.md), [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_split_lines()`](stri_split_lines.md), [`stri_trans_tolower()`](stri_trans_casemap.md), [`stri_wrap()`](stri_wrap.md)

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
