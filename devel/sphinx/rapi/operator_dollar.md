# operator_dollar: C-Style Formatting with [`stri_sprintf`](stri_sprintf.md) as a Binary Operator

## Description

Provides access to [`stri_sprintf`](stri_sprintf.md) in form of a binary operator in a way similar to Python\'s `%` overloaded for strings.

Missing values and empty vectors are propagated as usual.

## Usage

``` r
e1 %s$% e2

e1 %stri$% e2
```

## Arguments

|      |                                                                                                      |
|------|------------------------------------------------------------------------------------------------------|
| `e1` | format strings, see [`stri_sprintf`](stri_sprintf.md) for syntax                                     |
| `e2` | a list of atomic vectors to be passed to [`stri_sprintf`](stri_sprintf.md) or a single atomic vector |

## Details

Vectorized over `e1` and `e2`.

`e1 %s$% atomic_vector` is equivalent to `e1 %s$% list(atomic_vector)`.

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi:<https://dx.doi.org/10.18637/jss.v103.i02>

Other length: [`stri_isempty()`](stri_isempty.md), [`stri_length()`](stri_length.md), [`stri_numbytes()`](stri_numbytes.md), [`stri_pad_both()`](stri_pad.md), [`stri_sprintf()`](stri_sprintf.md), [`stri_width()`](stri_width.md)

## Examples




```r
"value='%d'" %s$% 3
## [1] "value='3'"
"value='%d'" %s$% 1:3
## [1] "value='1'" "value='2'" "value='3'"
"%s='%d'" %s$% list("value", 3)
## [1] "value='3'"
"%s='%d'" %s$% list("value", 1:3)
## [1] "value='1'" "value='2'" "value='3'"
"%s='%d'" %s$% list(c("a", "b", "c"), 1)
## [1] "a='1'" "b='1'" "c='1'"
"%s='%d'" %s$% list(c("a", "b", "c"), 1:3)
## [1] "a='1'" "b='2'" "c='3'"
x <- c("abcd", "\u00DF\u00B5\U0001F970", "abcdef")
cat("[%6s]" %s$% x, sep="\n")  # width used, not the number of bytes
## [  abcd]
## [  ßµ🥰]
## [abcdef]
```
