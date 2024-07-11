# stri_sort: String Sorting

## Description

This function sorts a character vector according to a locale-dependent lexicographic order.

## Usage

``` r
stri_sort(str, decreasing = FALSE, na_last = NA, ..., opts_collator = NULL)
```

## Arguments

|  |  |
|----|----|
| `str` | a character vector |
| `decreasing` | a single logical value; should the sort order be nondecreasing (`FALSE`, default, i.e., weakly increasing) or nonincreasing (`TRUE`)? |
| `na_last` | a single logical value; controls the treatment of `NA`s in `str`. If `TRUE`, then missing values in `str` are put at the end; if `FALSE`, they are put at the beginning; if `NA`, then they are removed from the output |
| `...` | additional settings for `opts_collator` |
| `opts_collator` | a named list with <span class="pkg">ICU</span> Collator\'s options, see [`stri_opts_collator`](stri_opts_collator.md), `NULL` for default collation options |

## Details

For more information on <span class="pkg">ICU</span>\'s Collator and how to tune it up in <span class="pkg">stringi</span>, refer to [`stri_opts_collator`](stri_opts_collator.md).

As usual in <span class="pkg">stringi</span>, non-character inputs are coerced to strings, see an example below for a somewhat non-intuitive behavior of lexicographic sorting on numeric inputs.

This function uses a stable sort algorithm (<span class="pkg">STL</span>\'s `stable_sort`), which performs up to $N*log^2(N)$ element comparisons, where $N$ is the length of `str`.

## Value

The result is a sorted version of `str`, i.e., a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Collation* - ICU User Guide, <https://unicode-org.github.io/icu/userguide/collation/>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other locale_sensitive: [`%s<%()`](+25s+3C+25.md), [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_coll`](about_search_coll.md), [`stri_compare()`](stri_compare.md), [`stri_count_boundaries()`](stri_count_boundaries.md), [`stri_duplicated()`](stri_duplicated.md), [`stri_enc_detect2()`](stri_enc_detect2.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_opts_collator()`](stri_opts_collator.md), [`stri_order()`](stri_order.md), [`stri_rank()`](stri_rank.md), [`stri_sort_key()`](stri_sort_key.md), [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_trans_tolower()`](stri_trans_casemap.md), [`stri_unique()`](stri_unique.md), [`stri_wrap()`](stri_wrap.md)

## Examples




``` r
stri_sort(c('hladny', 'chladny'), locale='pl_PL')
```

```
## [1] "chladny" "hladny"
```

``` r
stri_sort(c('hladny', 'chladny'), locale='sk_SK')
```

```
## [1] "hladny"  "chladny"
```

``` r
stri_sort(sample(LETTERS))
```

```
##  [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S"
## [20] "T" "U" "V" "W" "X" "Y" "Z"
```

``` r
stri_sort(c(1, 100, 2, 101, 11, 10))  # lexicographic order
```

```
## [1] "1"   "10"  "100" "101" "11"  "2"
```

``` r
stri_sort(c(1, 100, 2, 101, 11, 10), numeric=TRUE)  # OK for integers
```

```
## [1] "1"   "2"   "10"  "11"  "100" "101"
```

``` r
stri_sort(c(0.25, 0.5, 1, -1, -2, -3), numeric=TRUE)  # incorrect
```

```
## [1] "-1"   "-2"   "-3"   "0.5"  "0.25" "1"
```
