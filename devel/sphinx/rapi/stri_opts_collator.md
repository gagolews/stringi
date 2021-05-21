# stri\_opts\_collator: Generate a List with Collator Settings

## Description

A convenience function to tune the <span class="pkg">ICU</span> Collator\'s behavior, e.g., in [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html), as well as [`stri_detect_coll`](https://stringi.gagolewski.com/rapi/stri_detect_coll.html) and other [stringi-search-coll](https://stringi.gagolewski.com/rapi/stringi-search-coll.html) functions.

## Usage

```r
stri_opts_collator(
  locale = NULL,
  strength = 3L,
  alternate_shifted = FALSE,
  french = FALSE,
  uppercase_first = NA,
  case_level = FALSE,
  normalization = FALSE,
  normalisation = normalization,
  numeric = FALSE,
  ...
)

stri_coll(
  locale = NULL,
  strength = 3L,
  alternate_shifted = FALSE,
  french = FALSE,
  uppercase_first = NA,
  case_level = FALSE,
  normalization = FALSE,
  normalisation = normalization,
  numeric = FALSE,
  ...
)
```

## Arguments

|                     |                                                                                                                                                                                                                                                                             |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `locale`            | single string, `NULL` or `''` for default locale                                                                                                                                                                                                                            |
| `strength`          | single integer in {1,2,3,4}, which defines collation strength; `1` for the most permissive collation rules, `4` for the strictest ones                                                                                                                                      |
| `alternate_shifted` | single logical value; `FALSE` treats all the code points with non-ignorable primary weights in the same way, `TRUE` causes code points with primary weights that are equal or below the variable top value to be ignored on primary level and moved to the quaternary level |
| `french`            | single logical value; used in Canadian French; `TRUE` results in secondary weights being considered backwards                                                                                                                                                               |
| `uppercase_first`   | single logical value; `NA` orders upper and lower case letters in accordance to their tertiary weights, `TRUE` forces upper case letters to sort before lower case letters, `FALSE` does the opposite                                                                       |
| `case_level`        | single logical value; controls whether an extra case level (positioned before the third level) is generated or not                                                                                                                                                          |
| `normalization`     | single logical value; if `TRUE`, then incremental check is performed to see whether the input data is in the FCD form. If the data is not in the FCD form, incremental NFD normalization is performed                                                                       |
| `normalisation`     | alias of `normalization`                                                                                                                                                                                                                                                    |
| `numeric`           | single logical value; when turned on, this attribute generates a collation key for the numeric value of substrings of digits; this is a way to get \'100\' to sort AFTER \'2\'                                                                                              |
| `...`               | \[DEPRECATED\] any other arguments passed to this function generate a warning; this argument will be removed in the future                                                                                                                                                  |

## Details

<span class="pkg">ICU</span>\'s *collator* performs a locale-aware, natural-language alike string comparison. This is a more reliable way of establishing relationships between strings than the one provided by base <span style="font-family: Courier New, Courier; color: #666666;">**R**</span>, and definitely one that is more complex and appropriate than ordinary bytewise comparison.

## Value

Returns a named list object; missing settings are left with default values.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Collation* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/collation/>

*ICU Collation Service Architecture* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/collation/architecture.html>

*`icu::Collator` Class Reference* -- ICU4C API Documentation, <https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/classicu_1_1Collator.html>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other locale\_sensitive: [`%s<%`](https://stringi.gagolewski.com/rapi/%25s%3C%25.html)(), [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

Other search\_coll: [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html)

## Examples




```r
stri_cmp('number100', 'number2')
## [1] -1
stri_cmp('number100', 'number2', opts_collator=stri_opts_collator(numeric=TRUE))
## [1] 1
stri_cmp('number100', 'number2', numeric=TRUE) # equivalent
## [1] 1
stri_cmp('above mentioned', 'above-mentioned')
## [1] -1
stri_cmp('above mentioned', 'above-mentioned', alternate_shifted=TRUE)
## [1] 0
```
