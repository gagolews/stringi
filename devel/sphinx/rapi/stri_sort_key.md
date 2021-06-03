# stri\_sort\_key: Sort Keys

## Description

This function computes a locale-dependent sort key, which is an alternative character representation of the string that, when ordered in the C locale (which orders using the underlying bytes directly), will give an equivalent ordering to the original string. It is useful for enhancing algorithms that sort only in the C locale (e.g., the `strcmp` function in libc) with the ability to be locale-aware.

## Usage

```r
stri_sort_key(str, ..., opts_collator = NULL)
```

## Arguments

|                 |                                                                                                                                                                                                   |
|-----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`           | a character vector                                                                                                                                                                                |
| `...`           | additional settings for `opts_collator`                                                                                                                                                           |
| `opts_collator` | a named list with <span class="pkg">ICU</span> Collator\'s options, see [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html), `NULL` for default collation options |

## Details

For more information on <span class="pkg">ICU</span>\'s Collator and how to tune it up in <span class="pkg">stringi</span>, refer to [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html).

See also [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html) for ranking strings with a single character vector, i.e., generating relative sort keys.

## Value

The result is a character vector with the same length as `str` that contains the sort keys. The output is marked as `bytes`-encoded.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Collation* - ICU User Guide, <https://unicode-org.github.io/icu/userguide/collation/>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other locale\_sensitive: `%s<%()`, [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

## Examples




```r
stri_sort_key(c('hladny', 'chladny'), locale='pl_PL')
## [1] "8@*0DZ\001\n\001\n"  ".8@*0DZ\001\v\001\v"
stri_sort_key(c('hladny', 'chladny'), locale='sk_SK')
## [1] "8@*0DZ\001\n\001\n"     "9\002@*0DZ\001\n\001\n"
```
