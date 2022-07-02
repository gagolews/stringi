# stri_escape_unicode: Escape Unicode Code Points

## Description

Escapes all Unicode (not ASCII-printable) code points.

## Usage

``` r
stri_escape_unicode(str)
```

## Arguments

|       |                  |
|-------|------------------|
| `str` | character vector |

## Details

For non-printable and certain special (well-known, see also R man page [Quotes](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Quotes.html)) ASCII characters the following (also recognized in R) convention is used. We get `\a`, `\b`, `\t`, `\n`, `\v`, `\f`, `\r`, `\"`, `\'`, `\\` or either \\uXXXX (4 hex digits) or \\UXXXXXXXX (8 hex digits) otherwise.

As usual, any input string is converted to Unicode before executing the escape process.

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi:<https://dx.doi.org/10.18637/jss.v103.i02>

Other escape: [`stri_unescape_unicode()`](stri_unescape_unicode.md)

## Examples




```r
stri_escape_unicode('a\u0105!')
## [1] "a\\u0105!"
```
