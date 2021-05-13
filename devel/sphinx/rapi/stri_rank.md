# stri\_rank: Ranking

## Description

This function ranks each string in a character vector according to a locale-dependent lexicographic order. It is a portable replacement for the base `xtfrm` function.

## Usage

```r
stri_rank(str, ..., opts_collator = NULL)
```

## Arguments

|                 |                                                                                                                                                             |
|-----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`           | a character vector                                                                                                                                          |
| `...`           | additional settings for `opts_collator`                                                                                                                     |
| `opts_collator` | a named list with <span class="pkg">ICU</span> Collator\'s options, see [`stri_opts_collator`](stri_opts_collator.md), `NULL` for default collation options |

## Details

Missing values result in missing ranks and tied observations receive the same ranks (based on min).

For more information on <span class="pkg">ICU</span>\'s Collator and how to tune it up in <span class="pkg">stringi</span>, refer to [`stri_opts_collator`](stri_opts_collator.md).

## Value

The result is a vector of ranks corresponding to each string in `str`.

## References

*Collation* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/collation/>

## See Also

Other locale\_sensitive: [`%s<%()`,](operator_compare.md) [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_coll`](about_search_coll.md), [`stri_compare()`,](stri_compare.md) [`stri_count_boundaries()`,](stri_count_boundaries.md) [`stri_duplicated()`,](stri_duplicated.md) [`stri_enc_detect2()`,](stri_enc_detect2.md) [`stri_extract_all_boundaries()`,](stri_extract_boundaries.md) [`stri_locate_all_boundaries()`,](stri_locate_boundaries.md) [`stri_opts_collator()`,](stri_opts_collator.md) [`stri_order()`,](stri_order.md) [`stri_sort_key()`,](stri_sort_key.md) [`stri_sort()`,](stri_sort.md) [`stri_split_boundaries()`,](stri_split_boundaries.md) [`stri_trans_tolower()`,](stri_trans_casemap.md) [`stri_unique()`,](stri_unique.md) `stri_wrap()`

## Examples




```r
stri_rank(c('hladny', 'chladny'), locale='pl_PL')
## [1] 2 1
stri_rank(c('hladny', 'chladny'), locale='sk_SK')
## [1] 1 2
stri_rank("a" %s+% c(1, 100, 2, 101, 11, 10))  # lexicographic order
## [1] 1 3 6 4 5 2
stri_rank("a" %s+% c(1, 100, 2, 101, 11, 10), numeric=TRUE)
## [1] 1 5 2 6 4 3
# Ordering a data frame with respect to two criteria:
X <- data.frame(a=c("b", NA, "b", "b", NA, "a", "a", "c"), b=runif(8))
X[order(stri_rank(X$a), X$b), ]
##      a          b
## 7    a 0.49545428
## 6    a 0.50992992
## 1    b 0.07629792
## 3    b 0.42492544
## 4    b 0.87540627
## 8    c 0.07672819
## 5 <NA> 0.06144096
## 2 <NA> 0.47204805
```
