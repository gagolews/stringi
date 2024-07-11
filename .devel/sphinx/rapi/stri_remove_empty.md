# stri_remove_empty: Remove All Empty Strings from a Character Vector

## Description

`stri_remove_empty` (alias `stri_omit_empty`) removes all empty strings from a character vector, and, if `na_empty` is `TRUE`, also gets rid of all missing values.

`stri_remove_empty_na` (alias `stri_omit_empty_na`) removes both empty strings and missing values.

`stri_remove_na` (alias `stri_omit_na`) returns a version of `x` with missing values removed.

## Usage

``` r
stri_remove_empty(x, na_empty = FALSE)

stri_omit_empty(x, na_empty = FALSE)

stri_remove_empty_na(x)

stri_omit_empty_na(x)

stri_remove_na(x)

stri_omit_na(x)
```

## Arguments

|            |                                                    |
|------------|----------------------------------------------------|
| `x`        | a character vector                                 |
| `na_empty` | should missing values be treated as empty strings? |

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other utils: [`stri_list2matrix()`](stri_list2matrix.md), [`stri_na2empty()`](stri_na2empty.md), [`stri_replace_na()`](stri_replace_na.md)

## Examples




``` r
stri_remove_empty(stri_na2empty(c('a', NA, '', 'b')))
```

```
## [1] "a" "b"
```

``` r
stri_remove_empty(c('a', NA, '', 'b'))
```

```
## [1] "a" NA  "b"
```

``` r
stri_remove_empty(c('a', NA, '', 'b'), TRUE)
```

```
## [1] "a" "b"
```

``` r
stri_omit_empty_na(c('a', NA, '', 'b'))
```

```
## [1] "a" "b"
```
