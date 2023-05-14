# stri_dup: Duplicate Strings

## Description

Duplicates each `str`(`e1`) string `times`(`e2`) times and concatenates the results.

## Usage

``` r
stri_dup(str, times)

e1 %s*% e2

e1 %stri*% e2
```

## Arguments

|               |                                                                      |
|---------------|----------------------------------------------------------------------|
| `str`, `e1`   | a character vector of strings to be duplicated                       |
| `times`, `e2` | an integer vector with the numbers of times to duplicate each string |

## Details

Vectorized over all arguments.

`e1 %s*% e2` and `e1 %stri*% e2` are synonyms for `stri_dup(e1, e2)`

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other join: [`%s+%()`](+25s+2B+25.md), [`stri_flatten()`](stri_flatten.md), [`stri_join_list()`](stri_join_list.md), [`stri_join()`](stri_join.md)

## Examples




```r
stri_dup('a', 1:5)
## [1] "a"     "aa"    "aaa"   "aaaa"  "aaaaa"
stri_dup(c('a', NA, 'ba'), 4)
## [1] "aaaa"     NA         "babababa"
stri_dup(c('abc', 'pqrst'), c(4, 2))
## [1] "abcabcabcabc" "pqrstpqrst"
"a" %s*% 5
## [1] "aaaaa"
```
