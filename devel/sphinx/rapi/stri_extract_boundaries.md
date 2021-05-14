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

|                 |                                                                                                                                                                                      |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`           | character vector or an object coercible to                                                                                                                                           |
| `simplify`      | single logical value; if `TRUE` or `NA`, then a character matrix is returned; otherwise (the default), a list of character vectors is given, see Value                               |
| `omit_no_match` | single logical value; if `FALSE`, then a missing value will indicate that there are no words                                                                                         |
| `...`           | additional settings for `opts_brkiter`                                                                                                                                               |
| `opts_brkiter`  | a named list with <span class="pkg">ICU</span> BreakIterator\'s settings, see [`stri_opts_brkiter`](stri_opts_brkiter.md); `NULL` for the default break iterator, i.e., `line_break` |
| `locale`        | `NULL` or `''` for text boundary analysis following the conventions of the default locale, or a single string with locale identifier, see [stringi-locale](about_locale.md)          |

## Details

Vectorized over `str`.

For more information on text boundary analysis performed by <span class="pkg">ICU</span>\'s `BreakIterator`, see [stringi-search-boundaries](about_search_boundaries.md).

In case of `stri_extract_*_words`, just like in [`stri_count_words`](stri_count_boundaries.md), <span class="pkg">ICU</span>\'s word `BreakIterator` iterator is used to locate the word boundaries, and all non-word characters (`UBRK_WORD_NONE` rule status) are ignored.

## Value

For `stri_extract_all_*`, if `simplify=FALSE` (the default), then a list of character vectors is returned. Each string consists of a separate word. In case of `omit_no_match=FALSE` and if there are no words or if a string is missing, a single `NA` is provided on output.

Otherwise, [`stri_list2matrix`](stri_list2matrix.md) with `byrow=TRUE` argument is called on the resulting object. In such a case, a character matrix with `length(str)` rows is returned. Note that [`stri_list2matrix`](stri_list2matrix.md)\'s `fill` argument is set to an empty string and `NA`, for `simplify` `TRUE` and `NA`, respectively.

For `stri_extract_first_*` and `stri_extract_last_*`, a character vector is returned. A `NA` element indicates a no-match.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other search\_extract: [`about_search`](about_search.md), [`stri_extract_all()`,](stri_extract.md) `stri_match_all()`

Other locale\_sensitive: [`%s<%()`,](operator_compare.md) [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_coll`](about_search_coll.md), [`stri_compare()`,](stri_compare.md) [`stri_count_boundaries()`,](stri_count_boundaries.md) [`stri_duplicated()`,](stri_duplicated.md) [`stri_enc_detect2()`,](stri_enc_detect2.md) [`stri_locate_all_boundaries()`,](stri_locate_boundaries.md) [`stri_opts_collator()`,](stri_opts_collator.md) [`stri_order()`,](stri_order.md) [`stri_rank()`,](stri_rank.md) [`stri_sort_key()`,](stri_sort_key.md) [`stri_sort()`,](stri_sort.md) [`stri_split_boundaries()`,](stri_split_boundaries.md) [`stri_trans_tolower()`,](stri_trans_casemap.md) [`stri_unique()`,](stri_unique.md) `stri_wrap()`

Other text\_boundaries: [`about_search_boundaries`](about_search_boundaries.md), [`about_search`](about_search.md), [`stri_count_boundaries()`,](stri_count_boundaries.md) [`stri_locate_all_boundaries()`,](stri_locate_boundaries.md) [`stri_opts_brkiter()`,](stri_opts_brkiter.md) [`stri_split_boundaries()`,](stri_split_boundaries.md) [`stri_split_lines()`,](stri_split_lines.md) [`stri_trans_tolower()`,](stri_trans_casemap.md) `stri_wrap()`

## Examples




```r
stri_extract_all_words('stringi: THE string processing package 123.48...')
## [[1]]
## [1] "stringi"    "THE"        "string"     "processing" "package"   
## [6] "123.48"
```
