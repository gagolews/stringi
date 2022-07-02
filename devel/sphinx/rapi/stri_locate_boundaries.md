# stri_locate_boundaries: Locate Text Boundaries

## Description

These functions locate text boundaries (like character, word, line, or sentence boundaries). Use `stri_locate_all_*` to locate all the matches. `stri_locate_first_*` and `stri_locate_last_*` give the first or the last matches, respectively.

## Usage

``` r
stri_locate_all_boundaries(
  str,
  omit_no_match = FALSE,
  get_length = FALSE,
  ...,
  opts_brkiter = NULL
)

stri_locate_last_boundaries(str, get_length = FALSE, ..., opts_brkiter = NULL)

stri_locate_first_boundaries(str, get_length = FALSE, ..., opts_brkiter = NULL)

stri_locate_all_words(
  str,
  omit_no_match = FALSE,
  locale = NULL,
  get_length = FALSE
)

stri_locate_last_words(str, locale = NULL, get_length = FALSE)

stri_locate_first_words(str, locale = NULL, get_length = FALSE)
```

## Arguments

|                 |                                                                                                                                                                                |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`           | character vector or an object coercible to                                                                                                                                     |
| `omit_no_match` | single logical value; if `TRUE`, a no-match will be indicated by a matrix with 0 rows `stri_locate_all_*` only                                                                 |
| `get_length`    | single logical value; if `FALSE` (default), generate *from-to* matrices; otherwise, output *from-length* ones                                                                  |
| `...`           | additional settings for `opts_brkiter`                                                                                                                                         |
| `opts_brkiter`  | named list with <span class="pkg">ICU</span> BreakIterator\'s settings, see [`stri_opts_brkiter`](stri_opts_brkiter.md); `NULL` for default break iterator, i.e., `line_break` |
| `locale`        | `NULL` or `''` for text boundary analysis following the conventions of the default locale, or a single string with locale identifier, see [stringi-locale](about_locale.md)    |

## Details

Vectorized over `str`.

For more information on text boundary analysis performed by <span class="pkg">ICU</span>\'s `BreakIterator`, see [stringi-search-boundaries](about_search_boundaries.md).

For `stri_locate_*_words`, just like in [`stri_extract_all_words`](stri_extract_boundaries.md) and [`stri_count_words`](stri_count_boundaries.md), <span class="pkg">ICU</span>\'s word `BreakIterator` iterator is used to locate the word boundaries, and all non-word characters (`UBRK_WORD_NONE` rule status) are ignored. This function is equivalent to a call to `stri_locate_*_boundaries(str, type='word', skip_word_none=TRUE, locale=locale)`

## Value

`stri_locate_all_*` yields a list of `length(str)` integer matrices. `stri_locate_first_*` and `stri_locate_last_*` generate return an integer matrix. See [`stri_locate`](stri_locate.md) for more details.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi: [10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other search_locate: [`about_search`](about_search.md), [`stri_locate_all()`](stri_locate.md)

Other indexing: [`stri_locate_all()`](stri_locate.md), [`stri_sub_all()`](stri_sub_all.md), [`stri_sub()`](stri_sub.md)

Other locale_sensitive: [`%s<%()`](+25s+3C+25.md), [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_coll`](about_search_coll.md), [`stri_compare()`](stri_compare.md), [`stri_count_boundaries()`](stri_count_boundaries.md), [`stri_duplicated()`](stri_duplicated.md), [`stri_enc_detect2()`](stri_enc_detect2.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_opts_collator()`](stri_opts_collator.md), [`stri_order()`](stri_order.md), [`stri_rank()`](stri_rank.md), [`stri_sort_key()`](stri_sort_key.md), [`stri_sort()`](stri_sort.md), [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_trans_tolower()`](stri_trans_casemap.md), [`stri_unique()`](stri_unique.md), [`stri_wrap()`](stri_wrap.md)

Other text_boundaries: [`about_search_boundaries`](about_search_boundaries.md), [`about_search`](about_search.md), [`stri_count_boundaries()`](stri_count_boundaries.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_opts_brkiter()`](stri_opts_brkiter.md), [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_split_lines()`](stri_split_lines.md), [`stri_trans_tolower()`](stri_trans_casemap.md), [`stri_wrap()`](stri_wrap.md)

## Examples




```r
test <- 'The\u00a0above-mentioned    features are very useful. Spam, spam, eggs, bacon, and spam.'
stri_locate_all_words(test)
## [[1]]
##       start end
##  [1,]     1   3
##  [2,]     5   9
##  [3,]    11  19
##  [4,]    24  31
##  [5,]    33  35
##  [6,]    37  40
##  [7,]    42  47
##  [8,]    50  53
##  [9,]    56  59
## [10,]    62  65
## [11,]    68  72
## [12,]    75  77
## [13,]    79  82
stri_locate_all_boundaries(
    'Mr. Jones and Mrs. Brown are very happy. So am I, Prof. Smith.',
    type='sentence',
    locale='en_US@ss=standard' # ICU >= 56 only
)
## [[1]]
##      start end
## [1,]     1  41
## [2,]    42  62
```
