# stri\_enc\_tonative: Convert Strings To Native Encoding

## Description

Converts character strings with declared encodings to the current native encoding.

## Usage

```r
stri_enc_tonative(str)
```

## Arguments

|       |                                    |
|-------|------------------------------------|
| `str` | a character vector to be converted |

## Details

This function just calls [`stri_encode`](https://stringi.gagolewski.com/rapi/stri_encode.html)(str, NULL, NULL). The current native encoding can be read with [`stri_enc_get`](https://stringi.gagolewski.com/rapi/stri_enc_get.html). Character strings declared to be in `bytes` encoding will fail here.

Note that if working in a UTF-8 environment, resulting strings will be marked with `UTF-8` and not `native`, see [`stri_enc_mark`](https://stringi.gagolewski.com/rapi/stri_enc_mark.html).

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other encoding\_conversion: [`about_encoding`](https://stringi.gagolewski.com/rapi/about_encoding.html), [`stri_enc_fromutf32`](https://stringi.gagolewski.com/rapi/stri_enc_fromutf32.html)(), [`stri_enc_toascii`](https://stringi.gagolewski.com/rapi/stri_enc_toascii.html)(), [`stri_enc_toutf32`](https://stringi.gagolewski.com/rapi/stri_enc_toutf32.html)(), [`stri_enc_toutf8`](https://stringi.gagolewski.com/rapi/stri_enc_toutf8.html)(), [`stri_encode`](https://stringi.gagolewski.com/rapi/stri_encode.html)()
