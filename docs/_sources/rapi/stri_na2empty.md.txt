# stri\_na2empty: Replace NAs with Empty Strings

## Description

This function replaces all missing values with empty strings. See [`stri_replace_na`](https://stringi.gagolewski.com/rapi/stri_replace_na.html) for a generalization.

## Usage

```r
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

Other utils: [`stri_list2matrix`](https://stringi.gagolewski.com/rapi/stri_list2matrix.html)(), [`stri_remove_empty`](https://stringi.gagolewski.com/rapi/stri_remove_empty.html)(), [`stri_replace_na`](https://stringi.gagolewski.com/rapi/stri_replace_na.html)()

## Examples




```r
stri_na2empty(c('a', NA, '', 'b'))
## [1] "a" ""  ""  "b"
```
