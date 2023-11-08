# stri_na2empty: Replace NAs with Empty Strings

## Description

This function replaces all missing values with empty strings. See [`stri_replace_na`](stri_replace_na.md) for a generalization.

## Usage

``` r
stri_na2empty(x)
```

## Arguments

|     |                    |
|-----|--------------------|
| `x` | a character vector |

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other utils: [`stri_list2matrix()`](stri_list2matrix.md), [`stri_remove_empty()`](stri_remove_empty.md), [`stri_replace_na()`](stri_replace_na.md)

## Examples




```r
stri_na2empty(c('a', NA, '', 'b'))
```

```
## [1] "a" ""  ""  "b"
```
