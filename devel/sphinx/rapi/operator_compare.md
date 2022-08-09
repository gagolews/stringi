# operator_compare: Compare Strings with or without Collation

## Description

Relational operators for comparing corresponding strings in two character vectors, with a typical R look-and-feel.

## Usage

``` r
e1 %s<% e2

e1 %s<=% e2

e1 %s>% e2

e1 %s>=% e2

e1 %s==% e2

e1 %s!=% e2

e1 %s===% e2

e1 %s!==% e2

e1 %stri<% e2

e1 %stri<=% e2

e1 %stri>% e2

e1 %stri>=% e2

e1 %stri==% e2

e1 %stri!=% e2

e1 %stri===% e2

e1 %stri!==% e2
```

## Arguments

|          |                                                             |
|----------|-------------------------------------------------------------|
| `e1, e2` | character vectors or objects coercible to character vectors |

## Details

These functions call [`stri_cmp_le`](stri_compare.md) or its friends, using the default collator options. As a consequence, they are vectorized over `e1` and `e2`.

`%stri==%` tests for canonical equivalence of strings (see [`stri_cmp_equiv`](stri_compare.md)) and is a locale-dependent operation.

`%stri===%` performs a locale-independent, code point-based comparison.

## Value

All the functions return a logical vector indicating the result of a pairwise comparison. As usual, the elements of shorter vectors are recycled if necessary.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other locale_sensitive: [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_coll`](about_search_coll.md), [`stri_compare()`](stri_compare.md), [`stri_count_boundaries()`](stri_count_boundaries.md), [`stri_duplicated()`](stri_duplicated.md), [`stri_enc_detect2()`](stri_enc_detect2.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_opts_collator()`](stri_opts_collator.md), [`stri_order()`](stri_order.md), [`stri_rank()`](stri_rank.md), [`stri_sort_key()`](stri_sort_key.md), [`stri_sort()`](stri_sort.md), [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_trans_tolower()`](stri_trans_casemap.md), [`stri_unique()`](stri_unique.md), [`stri_wrap()`](stri_wrap.md)

## Examples




```r
'a' %stri<% 'b'
## [1] TRUE
c('a', 'b', 'c') %stri>=% 'b'
## [1] FALSE  TRUE  TRUE
```
