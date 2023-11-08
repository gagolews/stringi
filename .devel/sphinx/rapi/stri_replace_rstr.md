# stri_replace_rstr: Convert gsub-Style Replacement Strings

## Description

Converts a [`gsub`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/gsub.html)-style replacement strings to those which can be used in [`stri_replace`](stri_replace.md). In particular, `$` becomes `\$` and `\1` becomes `$1`.

## Usage

``` r
stri_replace_rstr(x)
```

## Arguments

|     |                  |
|-----|------------------|
| `x` | character vector |

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other search_replace: [`about_search`](about_search.md), [`stri_replace_all()`](stri_replace.md), [`stri_trim_both()`](stri_trim.md)
