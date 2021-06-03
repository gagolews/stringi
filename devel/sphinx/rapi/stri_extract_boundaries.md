# stri\_extract\_boundaries: Extract Data Between Text Boundaries

## Description

These functions extract data between text boundaries.

## Usage

```r
stri_extract_all_boundaries(
  str,
  simplify = FALSE,
  omit_no_match = FALSE,
  ...,
  opts_brkiter = NULL
)

stri_extract_last_boundaries(str, ..., opts_brkiter = NULL)

stri_extract_first_boundaries(str, ..., opts_brkiter = NULL)

stri_extract_all_words(
  str,
  simplify = FALSE,
  omit_no_match = FALSE,
  locale = NULL
)

stri_extract_first_words(str, locale = NULL)

stri_extract_last_words(str, locale = NULL)
```

## Arguments

|                 |                                                                                                                                                                                                                            |
|-----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`           | character vector or an object coercible to                                                                                                                                                                                 |
| `simplify`      | single logical value; if `TRUE` or `NA`, then a character matrix is returned; otherwise (the default), a list of character vectors is given, see Value                                                                     |
| `omit_no_match` | single logical value; if `FALSE`, then a missing value will indicate that there are no words                                                                                                                               |
| `...`           | additional settings for `opts_brkiter`                                                                                                                                                                                     |
| `opts_brkiter`  | a named list with <span class="pkg">ICU</span> BreakIterator\'s settings, see [`stri_opts_brkiter`](https://stringi.gagolewski.com/rapi/stri_opts_brkiter.html); `NULL` for the default break iterator, i.e., `line_break` |
| `locale`        | `NULL` or `''` for text boundary analysis following the conventions of the default locale, or a single string with locale identifier, see [stringi-locale](../../stringi/help/stringi-locale.html)                         |

## Details

Vectorized over `str`.

For more information on text boundary analysis performed by <span class="pkg">ICU</span>\'s `BreakIterator`, see [stringi-search-boundaries](../../stringi/help/stringi-search-boundaries.html).

In case of `stri_extract_*_words`, just like in [`stri_count_words`](https://stringi.gagolewski.com/rapi/stri_count_words.html), <span class="pkg">ICU</span>\'s word `BreakIterator` iterator is used to locate the word boundaries, and all non-word characters (`UBRK_WORD_NONE` rule status) are ignored.

## Value

For `stri_extract_all_*`, if `simplify=FALSE` (the default), then a list of character vectors is returned. Each string consists of a separate word. In case of `omit_no_match=FALSE` and if there are no words or if a string is missing, a single `NA` is provided on output.

Otherwise, [`stri_list2matrix`](https://stringi.gagolewski.com/rapi/stri_list2matrix.html) with `byrow=TRUE` argument is called on the resulting object. In such a case, a character matrix with `length(str)` rows is returned. Note that [`stri_list2matrix`](https://stringi.gagolewski.com/rapi/stri_list2matrix.html)\'s `fill` argument is set to an empty string and `NA`, for `simplify` `TRUE` and `NA`, respectively.

For `stri_extract_first_*` and `stri_extract_last_*`, a character vector is returned. A `NA` element indicates a no-match.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other search\_extract: [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`stri_extract_all`](https://stringi.gagolewski.com/rapi/stri_extract_all.html)(), [`stri_match_all`](https://stringi.gagolewski.com/rapi/stri_match_all.html)()

Other locale\_sensitive: `%s<%()`, [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

Other text\_boundaries: [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_brkiter`](https://stringi.gagolewski.com/rapi/stri_opts_brkiter.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_split_lines`](https://stringi.gagolewski.com/rapi/stri_split_lines.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

## Examples




```r
stri_extract_all_words('stringi: THE string processing package 123.48...')
## [[1]]
## [1] "stringi"    "THE"        "string"     "processing" "package"   
## [6] "123.48"
```
