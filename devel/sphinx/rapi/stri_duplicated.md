# stri\_duplicated: Determine Duplicated Elements

## Description

`stri_duplicated()` determines which strings in a character vector are duplicates of other elements.

`stri_duplicated_any()` determines if there are any duplicated strings in a character vector.

## Usage

```r
stri_duplicated(
  str,
  from_last = FALSE,
  fromLast = from_last,
  ...,
  opts_collator = NULL
)

stri_duplicated_any(
  str,
  from_last = FALSE,
  fromLast = from_last,
  ...,
  opts_collator = NULL
)
```

## Arguments

|                 |                                                                                                                                                                                                   |
|-----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`           | a character vector                                                                                                                                                                                |
| `from_last`     | a single logical value; indicates whether search should be performed from the last to the first string                                                                                            |
| `fromLast`      | \[DEPRECATED\] alias of `from_last`                                                                                                                                                               |
| `...`           | additional settings for `opts_collator`                                                                                                                                                           |
| `opts_collator` | a named list with <span class="pkg">ICU</span> Collator\'s options, see [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html), `NULL` for default collation options |

## Details

Missing values are regarded as equal.

Unlike [`duplicated`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/duplicated.html) and [`anyDuplicated`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/duplicated.html), these functions test for canonical equivalence of strings (and not whether the strings are just bytewise equal) Such operations are locale-dependent. Hence, `stri_duplicated` and `stri_duplicated_any` are significantly slower (but much better suited for natural language processing) than their base R counterparts.

See also [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html) for extracting unique elements.

## Value

`stri_duplicated()` returns a logical vector of the same length as `str`. Each of its elements indicates whether a canonically equivalent string was already found in `str`.

`stri_duplicated_any()` returns a single non-negative integer. Value of 0 indicates that all the elements in `str` are unique. Otherwise, it gives the index of the first non-unique element.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Collation* - ICU User Guide, <https://unicode-org.github.io/icu/userguide/collation/>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other locale\_sensitive: [`%s<%`](https://stringi.gagolewski.com/rapi/%25s%3C%25.html)(), [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

## Examples




```r
# In the following examples, we have 3 duplicated values,
# 'a' - 2 times, NA - 1 time
stri_duplicated(c('a', 'b', 'a', NA, 'a', NA))
## [1] FALSE FALSE  TRUE FALSE  TRUE  TRUE
stri_duplicated(c('a', 'b', 'a', NA, 'a', NA), from_last=TRUE)
## [1]  TRUE FALSE  TRUE  TRUE FALSE FALSE
stri_duplicated_any(c('a', 'b', 'a', NA, 'a', NA))
## [1] 3
# compare the results:
stri_duplicated(c('\u0105', stri_trans_nfkd('\u0105')))
## [1] FALSE  TRUE
duplicated(c('\u0105', stri_trans_nfkd('\u0105')))
## [1] FALSE FALSE
stri_duplicated(c('gro\u00df', 'GROSS', 'Gro\u00df', 'Gross'), strength=1)
## [1] FALSE  TRUE  TRUE  TRUE
duplicated(c('gro\u00df', 'GROSS', 'Gro\u00df', 'Gross'))
## [1] FALSE FALSE FALSE FALSE
```
