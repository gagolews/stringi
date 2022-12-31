# stri_length: Count the Number of Code Points

## Description

This function returns the number of code points in each string.

## Usage

``` r
stri_length(str)
```

## Arguments

|       |                                            |
|-------|--------------------------------------------|
| `str` | character vector or an object coercible to |

## Details

Note that the number of code points is not the same as the \'width\' of the string when printed on the console.

If a given string is in UTF-8 and has not been properly normalized (e.g., by [`stri_trans_nfc`](stri_trans_nf.md)), the returned counts may sometimes be misleading. See [`stri_count_boundaries`](stri_count_boundaries.md) for a method to count *Unicode characters*. Moreover, if an incorrect UTF-8 byte sequence is detected, then a warning is generated and the corresponding output element is set to `NA`, see also [`stri_enc_toutf8`](stri_enc_toutf8.md) for a method to deal with such cases.

Missing values are handled properly. For \'byte\' encodings we get, as usual, an error.

## Value

Returns an integer vector of the same length as `str`.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other length: [`%s$%()`](+25s+24+25.md), [`stri_isempty()`](stri_isempty.md), [`stri_numbytes()`](stri_numbytes.md), [`stri_pad_both()`](stri_pad.md), [`stri_sprintf()`](stri_sprintf.md), [`stri_width()`](stri_width.md)

## Examples




```r
stri_length(LETTERS)
##  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
stri_length(c('abc', '123', '\u0105\u0104'))
## [1] 3 3 2
stri_length('\u0105') # length is one, but...
## [1] 1
stri_numbytes('\u0105') # 2 bytes are used
## [1] 2
stri_numbytes(stri_trans_nfkd('\u0105')) # 3 bytes here but...
## [1] 3
stri_length(stri_trans_nfkd('\u0105')) # ...two code points (!)
## [1] 2
stri_count_boundaries(stri_trans_nfkd('\u0105'), type='character') # ...and one Unicode character
## [1] 1
```
