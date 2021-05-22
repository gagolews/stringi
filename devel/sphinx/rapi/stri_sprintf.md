# stri\_sprintf: Format Strings

## Description

A Unicode-aware replacement for and enhancement of the built-in [`sprintf`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/sprintf.html) function. Moreover, `stri_printf` prints formatted strings.

## Usage

```r
stri_sprintf(
  format,
  ...,
  na_string = NA_character_,
  inf_string = "Inf",
  nan_string = "NaN",
  use_length = FALSE
)

stri_string_format(
  format,
  ...,
  na_string = NA_character_,
  inf_string = "Inf",
  nan_string = "NaN",
  use_length = FALSE
)
```

## Arguments

|              |                                                                                                                                                                                                                        |
|--------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `format`     | character vector of format strings                                                                                                                                                                                     |
| `...`        | vectors (coercible to integer, real, or character)                                                                                                                                                                     |
| `na_string`  | single string to represent the not-a-number                                                                                                                                                                            |
| `inf_string` | single string to represent the (unsigned) infinity                                                                                                                                                                     |
| `use_length` | single logical value; should the number of code points be used when applying modifiers such as `%20s` instead of the total code point width (see [`stri_width`](https://stringi.gagolewski.com/rapi/stri_width.html))? |
| `file`       | see [`cat`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/cat.html)                                                                                                                                        |
| `sep`        | see [`cat`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/cat.html)                                                                                                                                        |
| `append`     | see [`cat`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/cat.html)                                                                                                                                        |

## Details

Vectorized over `format` and all vectors passed via `...`.

`stri_string_format` is a synonym for `stri_sprintf`.

Note that `stri_printf` treats missing values in `...` as `"NA"` strings by default.

Note that Unicode code points may have various widths when printed on the console and that, by default, the function takes that into account. By changing the state of the `use_length` argument, this function act as if each code point was of width 1.

For `%d` and `%f` formats, factors are treated as integer vectors (underlying codes) and so are date and time objects, etc.

This function is not locale sensitive. For instance, numbers are always formatted in the \"POSIX\" style, e.g., `-123456.789`. Such a feature might be added at a later date, though.

All arguments passed via `...` are evaluated. If some of them are unused, a warning is generated. Too few arguments result in an error.

## Value

`stri_printf` is used for its side effect, which is printing text on the standard output or other connection/file. Hence, it returns `invisible(NULL)`.

The other functions return a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

## Examples




```r
#...
stri_printf("%4s=%.3f", c("e", "e\u00b2", "\u03c0", "\u03c0\u00b2"),
    c(exp(1), exp(2), pi, pi^2))
##    e=2.718
##   e²=7.389
##    π=3.142
##   π²=9.870
# vectorization wrt all arguments:
p <- runif(10)
stri_sprintf(ifelse(p > 0.5, "P(Y=1)=%1$.2f", "P(Y=0)=%2$.2f"), p, 1-p)
##  [1] "P(Y=0)=0.71" "P(Y=1)=0.79" "P(Y=0)=0.59" "P(Y=1)=0.88" "P(Y=1)=0.94"
##  [6] "P(Y=0)=0.95" "P(Y=1)=0.53" "P(Y=1)=0.89" "P(Y=1)=0.55" "P(Y=0)=0.54"
# using a "preformatted" logical vector:
x <- c(TRUE, FALSE, FALSE, NA, TRUE, FALSE)
stri_sprintf("%s) %s", letters[seq_along(x)], c("\u2718", "\u2713")[x+1])
## [1] "a) ✓" "b) ✘" "c) ✘" NA     "e) ✓" "f) ✘"
# custom NA/Inf/NaN strings:
stri_printf("%+10.3f", c(-Inf, -0, 0, Inf, NaN, NA_real_),
    na_string="<NA>", nan_string="\U0001F4A9", inf_string="\u221E")
##         -∞
##     -0.000
##     +0.000
##         +∞
##         💩
##       <NA>
```
