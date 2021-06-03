# stri\_order: Ordering Permutation

## Description

This function finds a permutation which rearranges the strings in a given character vector into the ascending or descending locale-dependent lexicographic order.

## Usage

```r
stri_order(str, decreasing = FALSE, na_last = TRUE, ..., opts_collator = NULL)
```

## Arguments

|                 |                                                                                                                                                                                                                         |
|-----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`           | a character vector                                                                                                                                                                                                      |
| `decreasing`    | a single logical value; should the sort order be nondecreasing (`FALSE`, default) or nonincreasing (`TRUE`)?                                                                                                            |
| `na_last`       | a single logical value; controls the treatment of `NA`s in `str`. If `TRUE`, then missing values in `str` are put at the end; if `FALSE`, they are put at the beginning; if `NA`, then they are removed from the output |
| `...`           | additional settings for `opts_collator`                                                                                                                                                                                 |
| `opts_collator` | a named list with <span class="pkg">ICU</span> Collator\'s options, see [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html), `NULL` for default collation options                       |

## Details

For more information on <span class="pkg">ICU</span>\'s Collator and how to tune it up in <span class="pkg">stringi</span>, refer to [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html).

As usual in <span class="pkg">stringi</span>, non-character inputs are coerced to strings, see an example below for a somewhat non-intuitive behavior of lexicographic sorting on numeric inputs.

This function uses a stable sort algorithm (<span class="pkg">STL</span>\'s `stable_sort`), which performs up to *N\*log\^2(N)* element comparisons, where *N* is the length of `str`.

For ordering with regards to multiple criteria (such as sorting data frames by more than 1 column), see [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html).

## Value

The function yields an integer vector that gives the sort order.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Collation* - ICU User Guide, <https://unicode-org.github.io/icu/userguide/collation/>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other locale\_sensitive: `%s<%()`, [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

## Examples




```r
stri_order(c('hladny', 'chladny'), locale='pl_PL')
## [1] 2 1
stri_order(c('hladny', 'chladny'), locale='sk_SK')
## [1] 1 2
stri_order(c(1, 100, 2, 101, 11, 10))
## [1] 1 6 2 4 5 3
stri_order(c(1, 100, 2, 101, 11, 10), numeric=TRUE)
## [1] 1 3 6 5 2 4
```
