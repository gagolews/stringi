# stri_unescape_unicode: Un-escape All Escape Sequences

## Description

Un-escapes all known escape sequences

## Usage

``` r
stri_unescape_unicode(str)
```

## Arguments

|       |                  |
|-------|------------------|
| `str` | character vector |

## Details

Uses <span class="pkg">ICU</span> facilities to un-escape Unicode character sequences.

The following ASCII standard escapes are recognized: `\a`, `\b`, `\t`, `\n`, `\v`, `\?`, `\e`, `\f`, `\r`, `\"`, `\'`, `\\`.

Moreover, the function understands the following ones: `\uXXXX` (4 hex digits), `\UXXXXXXXX` (8 hex digits), `\xXX` (1-2 hex digits), `\ooo` (1-3 octal digits), `\cX` (control-X; X is masked with 0x1F). For `\xXX` and `\ooo`, beware of non-valid UTF-8 byte sequences.

Note that some versions of R on Windows cannot handle characters defined with \\UXXXXXXXX. We are working on that.

## Value

Returns a character vector. If an escape sequence is ill-formed, result will be `NA` and a warning will be given.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other escape: [`stri_escape_unicode()`](stri_escape_unicode.md)

## Examples




```r
stri_unescape_unicode('a\\u0105!\\u0032\\n')
```

```
## [1] "aą!2\n"
```
