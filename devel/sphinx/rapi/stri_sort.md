# stri\_sort: Sorting

## Description

This function sorts a character vector according to a locale-dependent lexicographic order.

## Usage

```r
stri_sort(str, decreasing = FALSE, na_last = NA, ..., opts_collator = NULL)
```

## Arguments

|                 |                                                                                                                                                                                                                         |
|-----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`           | a character vector                                                                                                                                                                                                      |
| `decreasing`    | a single logical value; should the sort order be nondecreasing (`FALSE`, default, i.e., weakly increasing) or nonincreasing (`TRUE`)?                                                                                   |
| `na_last`       | a single logical value; controls the treatment of `NA`s in `str`. If `TRUE`, then missing values in `str` are put at the end; if `FALSE`, they are put at the beginning; if `NA`, then they are removed from the output |
| `...`           | additional settings for `opts_collator`                                                                                                                                                                                 |
| `opts_collator` | a named list with <span class="pkg">ICU</span> Collator\'s options, see [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html), `NULL` for default collation options                       |

## Details

For more information on <span class="pkg">ICU</span>\'s Collator and how to tune it up in <span class="pkg">stringi</span>, refer to [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html).

As usual in <span class="pkg">stringi</span>, non-character inputs are coerced to strings, see an example below for a somewhat non-intuitive behavior of lexicographic sorting on numeric inputs.

This function uses a stable sort algorithm (<span class="pkg">STL</span>\'s `stable_sort`), which performs up to *N\*log\^2(N)* element comparisons, where *N* is the length of `str`.

## Value

The result is a sorted version of `str`, i.e., a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Collation* - ICU User Guide, <https://unicode-org.github.io/icu/userguide/collation/>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other locale\_sensitive: `%s<%()`, [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

## Examples




```r
stri_sort(c('hladny', 'chladny'), locale='pl_PL')
## [1] "chladny" "hladny"
stri_sort(c('hladny', 'chladny'), locale='sk_SK')
## [1] "hladny"  "chladny"
stri_sort(sample(LETTERS))
##  [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S"
## [20] "T" "U" "V" "W" "X" "Y" "Z"
stri_sort(c(1, 100, 2, 101, 11, 10))
## [1] "1"   "10"  "100" "101" "11"  "2"
stri_sort(c(1, 100, 2, 101, 11, 10), numeric=TRUE)
## [1] "1"   "2"   "10"  "11"  "100" "101"
```
