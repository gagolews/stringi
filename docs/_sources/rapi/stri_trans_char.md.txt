# stri_trans_char: Translate Characters

## Description

Translates Unicode code points in each input string.

## Usage

``` r
stri_trans_char(str, pattern, replacement)
```

## Arguments

|               |                                                                  |
|---------------|------------------------------------------------------------------|
| `str`         | character vector                                                 |
| `pattern`     | a single character string providing code points to be translated |
| `replacement` | a single character string giving translated code points          |

## Details

Vectorized over `str` and with respect to each code point in `pattern` and `replacement`.

If `pattern` and `replacement` consist of a different number of code points, then the extra code points in the longer of the two are ignored, with a warning.

If code points in a given `pattern` are not unique, the last corresponding replacement code point is used.

Time complexity for each string in `str` is O(`stri_length(str)*stri_length(pattern)`).

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other transform: [`stri_trans_general()`](stri_trans_general.md), [`stri_trans_list()`](stri_trans_list.md), [`stri_trans_nfc()`](stri_trans_nf.md), [`stri_trans_tolower()`](stri_trans_casemap.md)

## Examples




```r
stri_trans_char('id.123', '.', '_')
## [1] "id_123"
stri_trans_char('babaab', 'ab', '01')
## [1] "101001"
stri_trans_char('GCUACGGAGCUUCGGAGCUAG', 'ACGT', 'TGCA')
## [1] "CGUTGCCTCGUUGCCTCGUTC"
```
