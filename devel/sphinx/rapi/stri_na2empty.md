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

Other utils: [`stri_list2matrix()`](stri_list2matrix.md), [`stri_remove_empty()`](stri_remove_empty.md), [`stri_replace_na()`](stri_replace_na.md)

## Examples




```r
stri_na2empty(c('a', NA, '', 'b'))
## [1] "a" ""  ""  "b"
```
