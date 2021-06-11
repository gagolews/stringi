# stri\_sprintf: Format Strings

## Description

`stri_sprintf` (synonym: `stri_string_format`) is a Unicode-aware replacement for and enhancement of the built-in [`sprintf`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/sprintf.html) function. Moreover, `stri_printf` prints formatted strings.

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

stri_printf(
  format,
  ...,
  file = "",
  sep = "\n",
  append = FALSE,
  na_string = "NA",
  inf_string = "Inf",
  nan_string = "NaN",
  use_length = FALSE
)
```

## Arguments

|              |                                                                                                                                                                          |
|--------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `format`     | character vector of format strings                                                                                                                                       |
| `...`        | vectors (coercible to integer, real, or character)                                                                                                                       |
| `na_string`  | single string to represent missing values; if `NA`, missing values in `...` result in the corresponding outputs be missing too; use `"NA"` for compatibility with base R |
| `inf_string` | single string to represent the (unsigned) infinity (`NA` allowed)                                                                                                        |
| `nan_string` | single string to represent the not-a-number (`NA` allowed)                                                                                                               |
| `use_length` | single logical value; should the number of code points be used when applying modifiers such as `%20s` instead of the total code point width?                             |
| `file`       | see [`cat`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/cat.html)                                                                                            |
| `sep`        | see [`cat`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/cat.html)                                                                                            |
| `append`     | see [`cat`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/cat.html)                                                                                            |

## Details

Vectorized over `format` and all vectors passed via `...`.

Unicode code points may have various widths when printed on the console (compare [`stri_width`](stri_width.md)). These functions, by default (see the `use_length` argument), take this into account.

These functions are not locale sensitive. For instance, numbers are always formatted in the \"POSIX\" style, e.g., `-123456.789` (no thousands separator, dot as a fractional separator). Such a feature might be added at a later date, though.

All arguments passed via `...` are evaluated. If some of them are unused, a warning is generated. Too few arguments result in an error.

Note that `stri_printf` treats missing values in `...` as `"NA"` strings by default.

All format specifiers supported [`sprintf`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/sprintf.html) are also available here. For the formatting of integers and floating-point values, currently the system `std::snprintf()` is called, but this may change in the future. Format specifiers are normalized and necessary sanity checks are performed.

Supported conversion specifiers: `dioxX` (integers) `feEgGaA` (floats) and `s` (character strings). Supported flags: `-` (left-align), `+` (force output sign or blank when `NaN` or `NA`; numeric only), `<space>` (output minus or space for a sign; numeric only) `0` (pad with 0s; numeric only), `#` (alternative output of some numerics).

## Value

`stri_printf` is used for its side effect, which is printing text on the standard output or other connection/file. Hence, it returns `invisible(NULL)`.

The other functions return a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

`printf` in `glibc`, <https://man.archlinux.org/man/printf.3>

`printf` format strings -- Wikipedia, <https://en.wikipedia.org/wiki/Printf_format_string>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other length: [`%s$%()`](operator_dollar.md), [`stri_isempty()`](stri_isempty.md), [`stri_length()`](stri_length.md), [`stri_numbytes()`](stri_numbytes.md), [`stri_pad_both()`](stri_pad.md), [`stri_width()`](stri_width.md)

## Examples




```r
stri_printf("%4s=%.3f", c("e", "e\u00b2", "\u03c0", "\u03c0\u00b2"),
    c(exp(1), exp(2), pi, pi^2))
##    e=2.718
##   e²=7.389
##    π=3.142
##   π²=9.870
x <- c("xxabcd", "xx\u0105\u0106\u0107\u0108",
    "\u200b\u200b\u200b\u200b\U0001F3F4\U000E0067\U000E0062\U000E0073\U000E0063\U000E0074\U000E007Fabcd")
stri_printf("[%10s]", x)  # minimum width = 10
## [    xxabcd]
## [    xxąĆćĈ]
## [    ​​​​🏴󠁧󠁢󠁳󠁣󠁴󠁿abcd]
stri_printf("[%-10.3s]", x)  # output of max width = 3, but pad to width of 10
## [xxa       ]
## [xxą       ]
## [​​​​🏴󠁧󠁢󠁳󠁣󠁴󠁿a       ]
stri_printf("[%10s]", x, use_length=TRUE)  # minimum number Unicode of code points = 10
## [    xxabcd]
## [    xxąĆćĈ]
## [​​​​🏴󠁧󠁢󠁳󠁣󠁴󠁿abcd]
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
stri_sprintf("UNIX time %1$f is %1$s.", Sys.time())
## [1] "UNIX time 1623398258.326312 is 2021-06-11 17:57:38."
# the following do not work in sprintf()
stri_sprintf("%1$#- *2$.*3$f", 1.23456, 10, 3)  # two asterisks
## [1] " 1.235    "
stri_sprintf(c("%s", "%f"), pi)  # re-coercion needed
## [1] "3.14159265358979" "3.141593"
stri_sprintf("%1$s is %1$f UNIX time.", Sys.time())  # re-coercion needed
## [1] "2021-06-11 17:57:38 is 1623398258.328827 UNIX time."
stri_sprintf(c("%d", "%s"), factor(11:12))  # re-coercion needed
## [1] "1"  "12"
stri_sprintf(c("%s", "%d"), factor(11:12))  # re-coercion needed
## [1] "11" "2"
```
