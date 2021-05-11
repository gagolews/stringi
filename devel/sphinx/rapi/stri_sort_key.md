# stri\_sort\_key: Sort Keys

## Description

This function computes a locale-dependent sort key, which is an alternative character representation of the string that, when ordered in the C locale (which orders using the underlying bytes directly), will give an equivalent ordering to the original string. It is useful for enhancing algorithms that sort only in the C locale (e.g., the `strcmp` function in libc) with the ability to be locale-aware.

## Usage

```r
stri_sort_key(str, ..., opts_collator = NULL)
```

## Arguments

|                 |                                                                                                                                                             |
|-----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`           | a character vector                                                                                                                                          |
| `...`           | additional settings for `opts_collator`                                                                                                                     |
| `opts_collator` | a named list with <span class="pkg">ICU</span> Collator\'s options, see [`stri_opts_collator`](stri_opts_collator.md), `NULL` for default collation options |

## Details

For more information on <span class="pkg">ICU</span>\'s Collator and how to tune it up in <span class="pkg">stringi</span>, refer to [`stri_opts_collator`](stri_opts_collator.md).

See also [`stri_rank`](stri_rank.md) for ranking strings with a single character vector, i.e., generating relative sort keys.

## Value

The result is a character vector with the same length as `str` that contains the sort keys. The output is marked as `bytes`-encoded.

## References

*Collation* - ICU User Guide, <http://userguide.icu-project.org/collation>

## See Also

Other locale\_sensitive: [`%s<%()`,](operator_compare.md) [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_coll`](about_search_coll.md), [`stri_compare()`,](stri_compare.md) [`stri_count_boundaries()`,](stri_count_boundaries.md) [`stri_duplicated()`,](stri_duplicated.md) [`stri_enc_detect2()`,](stri_enc_detect2.md) [`stri_extract_all_boundaries()`,](stri_extract_boundaries.md) [`stri_locate_all_boundaries()`,](stri_locate_boundaries.md) [`stri_opts_collator()`,](stri_opts_collator.md) [`stri_order()`,](stri_order.md) [`stri_rank()`,](stri_rank.md) [`stri_sort()`,](stri_sort.md) [`stri_split_boundaries()`,](stri_split_boundaries.md) [`stri_trans_tolower()`,](stri_trans_casemap.md) [`stri_unique()`,](stri_unique.md) `stri_wrap()`

## Examples




```r
stri_sort_key(c('hladny', 'chladny'), locale='pl_PL')
## [1] "8@*0DZ\001\n\001\n"  ".8@*0DZ\001\v\001\v"
stri_sort_key(c('hladny', 'chladny'), locale='sk_SK')
## [1] "8@*0DZ\001\n\001\n"     "9\002@*0DZ\001\n\001\n"
```
