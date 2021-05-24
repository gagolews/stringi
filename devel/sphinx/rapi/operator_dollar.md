# operator\_dollar: C-Style Formatting with [`stri_sprintf`](https://stringi.gagolewski.com/rapi/stri_sprintf.html) as a Binary Operator

## Description

Provides access to [`stri_sprintf`](https://stringi.gagolewski.com/rapi/stri_sprintf.html) in form of a binary operator in a way similar to Python\'s `%` overloaded for strings.

## Usage

```r
e1 %s$% e2

e1 %stri$% e2
```

## Arguments

|      |                                                                                                                                            |
|------|--------------------------------------------------------------------------------------------------------------------------------------------|
| `e1` | format strings, see [`stri_sprintf`](https://stringi.gagolewski.com/rapi/stri_sprintf.html) for syntax                                     |
| `e2` | a list of atomic vectors to be passed to [`stri_sprintf`](https://stringi.gagolewski.com/rapi/stri_sprintf.html) or a single atomic vector |

## Details

Vectorized over `e1` and `e2`.

`e1 %s$% atomic_vector` is equivalent to `e1 %s$% list(atomic_vector)`.

## Value

Returns a character vector

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other length: [`stri_isempty`](https://stringi.gagolewski.com/rapi/stri_isempty.html)(), [`stri_length`](https://stringi.gagolewski.com/rapi/stri_length.html)(), [`stri_numbytes`](https://stringi.gagolewski.com/rapi/stri_numbytes.html)(), [`stri_pad_both`](https://stringi.gagolewski.com/rapi/stri_pad_both.html)(), [`stri_sprintf`](https://stringi.gagolewski.com/rapi/stri_sprintf.html)(), [`stri_width`](https://stringi.gagolewski.com/rapi/stri_width.html)()

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
