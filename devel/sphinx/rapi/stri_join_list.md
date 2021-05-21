# stri\_join\_list: Concatenate Strings in a List

## Description

These functions concatenate all the strings in each character vector in a given list. `stri_c_list` and `stri_paste_list` are aliases for `stri_join_list`.

## Usage

```r
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

Other join: [`%s+%`](https://stringi.gagolewski.com/rapi/%25s+%25.html)(), [`stri_dup`](https://stringi.gagolewski.com/rapi/stri_dup.html)(), [`stri_flatten`](https://stringi.gagolewski.com/rapi/stri_flatten.html)(), [`stri_join`](https://stringi.gagolewski.com/rapi/stri_join.html)()

## Examples




```r
stri_join_list(
   stri_extract_all_words(c('Lorem ipsum dolor sit amet.',
   'Spam spam bacon sausage and spam.')),
sep=', ')
## [1] "Lorem, ipsum, dolor, sit, amet"       
## [2] "Spam, spam, bacon, sausage, and, spam"
stri_join_list(
   stri_extract_all_words(c('Lorem ipsum dolor sit amet.',
   'Spam spam bacon sausage and spam.')),
sep=', ', collapse='. ')
## [1] "Lorem, ipsum, dolor, sit, amet. Spam, spam, bacon, sausage, and, spam"
stri_join_list(
   stri_extract_all_regex(
      c('spam spam bacon', '123 456', 'spam 789 sausage'), '\\p{L}+'
   ),
sep=',')
## [1] "spam,spam,bacon" NA                "spam,sausage"
stri_join_list(
   stri_extract_all_regex(
      c('spam spam bacon', '123 456', 'spam 789 sausage'), '\\p{L}+',
      omit_no_match=TRUE
   ),
sep=',', collapse='; ')
## [1] "spam,spam,bacon; spam,sausage"
```
