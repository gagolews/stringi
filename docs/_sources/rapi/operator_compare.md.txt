# operator\_compare: Compare Strings with or without Collation

## Description

Relational operators for comparing corresponding strings in two character vectors, with a typical R look-and-feel.

## Usage

```r
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

These functions call [`stri_cmp_le`](https://stringi.gagolewski.com/rapi/stri_cmp_le.html) or its friends, using the default collator options. As a consequence, they are vectorized over `e1` and `e2`.

`%stri==%` tests for canonical equivalence of strings (see [`stri_cmp_equiv`](https://stringi.gagolewski.com/rapi/stri_cmp_equiv.html)) and is a locale-dependent operation.

`%stri===%` performs a locale-independent, code point-based comparison.

## Value

All the functions return a logical vector indicating the result of a pairwise comparison. As usual, the elements of shorter vectors are recycled if necessary.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other locale\_sensitive: [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

## Examples




```r
'a' %stri<% 'b'
## [1] TRUE
c('a', 'b', 'c') %stri>=% 'b'
## [1] FALSE  TRUE  TRUE
```
