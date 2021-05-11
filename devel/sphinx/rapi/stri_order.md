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
| `opts_collator` | a named list with <span class="pkg">ICU</span> Collator\'s options, see [`stri_opts_collator`](stri_opts_collator.md), `NULL` for default collation options                                                             |

## Details

For more information on <span class="pkg">ICU</span>\'s Collator and how to tune it up in <span class="pkg">stringi</span>, refer to [`stri_opts_collator`](stri_opts_collator.md).

As usual in <span class="pkg">stringi</span>, non-character inputs are coerced to strings, see an example below for a somewhat non-intuitive behavior of lexicographic sorting on numeric inputs.

This function uses a stable sort algorithm (<span class="pkg">STL</span>\'s `stable_sort`), which performs up to *N\*log\^2(N)* element comparisons, where *N* is the length of `str`.

For ordering with regards to multiple criteria (such as sorting data frames by more than 1 column), see [`stri_rank`](stri_rank.md).

## Value

The function yields an integer vector that gives the sort order.

## References

*Collation* - ICU User Guide, <http://userguide.icu-project.org/collation>

## See Also

Other locale\_sensitive: [`%s<%()`,](operator_compare.md) [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_coll`](about_search_coll.md), [`stri_compare()`,](stri_compare.md) [`stri_count_boundaries()`,](stri_count_boundaries.md) [`stri_duplicated()`,](stri_duplicated.md) [`stri_enc_detect2()`,](stri_enc_detect2.md) [`stri_extract_all_boundaries()`,](stri_extract_boundaries.md) [`stri_locate_all_boundaries()`,](stri_locate_boundaries.md) [`stri_opts_collator()`,](stri_opts_collator.md) [`stri_rank()`,](stri_rank.md) [`stri_sort_key()`,](stri_sort_key.md) [`stri_sort()`,](stri_sort.md) [`stri_split_boundaries()`,](stri_split_boundaries.md) [`stri_trans_tolower()`,](stri_trans_casemap.md) [`stri_unique()`,](stri_unique.md) `stri_wrap()`

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
