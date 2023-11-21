# stri_join_list: Concatenate Strings in a List

## Description

These functions concatenate all the strings in each character vector in a given list. `stri_c_list` and `stri_paste_list` are aliases for `stri_join_list`.

## Usage

``` r
stri_join_list(x, sep = "", collapse = NULL)

stri_c_list(x, sep = "", collapse = NULL)

stri_paste_list(x, sep = "", collapse = NULL)
```

## Arguments

|            |                                                                            |
|------------|----------------------------------------------------------------------------|
| `x`        | a list consisting of character vectors                                     |
| `sep`      | a single string; separates strings in each of the character vectors in `x` |
| `collapse` | a single string or `NULL`; an optional results separator                   |

## Details

Unless `collapse` is `NULL`, the result will be a single string. Otherwise, you get a character vector of length equal to the length of `x`.

Vectors in `x` of length 0 are silently ignored.

If `collapse` or `sep` has length greater than 1, then only the first string will be used.

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other join: [`%s+%()`](+25s+2B+25.md), [`stri_dup()`](stri_dup.md), [`stri_flatten()`](stri_flatten.md), [`stri_join()`](stri_join.md)

## Examples




```r
stri_join_list(
   stri_extract_all_words(c('Lorem ipsum dolor sit amet.',
   'Spam spam bacon sausage and spam.')),
sep=', ')
```

```
## [1] "Lorem, ipsum, dolor, sit, amet"       
## [2] "Spam, spam, bacon, sausage, and, spam"
```

```r
stri_join_list(
   stri_extract_all_words(c('Lorem ipsum dolor sit amet.',
   'Spam spam bacon sausage and spam.')),
sep=', ', collapse='. ')
```

```
## [1] "Lorem, ipsum, dolor, sit, amet. Spam, spam, bacon, sausage, and, spam"
```

```r
stri_join_list(
   stri_extract_all_regex(
      c('spam spam bacon', '123 456', 'spam 789 sausage'), '\\p{L}+'
   ),
sep=',')
```

```
## [1] "spam,spam,bacon" NA                "spam,sausage"
```

```r
stri_join_list(
   stri_extract_all_regex(
      c('spam spam bacon', '123 456', 'spam 789 sausage'), '\\p{L}+',
      omit_no_match=TRUE
   ),
sep=',', collapse='; ')
```

```
## [1] "spam,spam,bacon; spam,sausage"
```
