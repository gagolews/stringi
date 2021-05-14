# operator\_dollar: C-Style Formatting with sprintf as a Binary Operator

## Description

Provides access to base R\'s [`sprintf`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/sprintf.html) in form of a binary operator in a way similar to Python\'s `%` overloaded for strings.

## Usage

```r
e1 %s$% e2

e1 %stri$% e2
```

## Arguments

|      |                                                                                                                                                        |
|------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| `e1` | format strings, see [`sprintf`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/sprintf.html) for syntax                                     |
| `e2` | a list of atomic vectors to be passed to [`sprintf`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/sprintf.html) or a single atomic vector |

## Details

Vectorized over `e1` and `e2`.

`e1 %s$% atomic_vector` is equivalent to `e1 %s$% list(atomic_vector)`.

Note that [`sprintf`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/sprintf.html) takes field width in bytes, not Unicode code points. See Examples for a workaround.

## Value

Returns a character vector.

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
# sprintf field width:
x <- c("abcd", "\u00DF\u00B5\U0001F970", "abcdef")
cat(sprintf("%s%6s%s", "-", x, "-"), sep="\n")
## -  abcd-
## -ßµ🥰-
## -abcdef-
cat(sprintf("%s%s%s", "-", stringi::stri_pad(x, 6), "-"), sep="\n")
## -  abcd-
## -  ßµ🥰-
## -abcdef-
```
