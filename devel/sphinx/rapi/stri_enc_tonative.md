# stri_enc_tonative: Convert Strings To Native Encoding

## Description

Converts character strings with declared encodings to the current native encoding.

## Usage

``` r
stri_enc_tonative(str)
```

## Arguments

|       |                                    |
|-------|------------------------------------|
| `str` | a character vector to be converted |

## Details

This function just calls [`stri_encode(str, NULL, NULL)`](stri_encode.md). The current native encoding can be read with [`stri_enc_get`](stri_enc_set.md). Character strings declared to be in `bytes` encoding will fail here.

Note that if working in a UTF-8 environment, resulting strings will be marked with `UTF-8` and not `native`, see [`stri_enc_mark`](stri_enc_mark.md).

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi:<https://dx.doi.org/10.18637/jss.v103.i02>

Other encoding_conversion: [`about_encoding`](about_encoding.md), [`stri_enc_fromutf32()`](stri_enc_fromutf32.md), [`stri_enc_toascii()`](stri_enc_toascii.md), [`stri_enc_toutf32()`](stri_enc_toutf32.md), [`stri_enc_toutf8()`](stri_enc_toutf8.md), [`stri_encode()`](stri_encode.md)
