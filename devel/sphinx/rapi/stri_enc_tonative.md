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

This function just calls [`stri_encode(str, NULL, NULL)`. The current native encoding can be read with](stri_encode.md) [`stri_enc_get`](stri_enc_set.md). Character strings declared to be in `bytes` encoding will fail here.

Note that if working in a UTF-8 environment, resulting strings will be marked with `UTF-8` and not `native`, see [`stri_enc_mark`](stri_enc_mark.md).

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other encoding\_conversion: [`about_encoding`](about_encoding.md), [`stri_enc_fromutf32()`,](stri_enc_fromutf32.md) [`stri_enc_toascii()`,](stri_enc_toascii.md) [`stri_enc_toutf32()`,](stri_enc_toutf32.md) [`stri_enc_toutf8()`,](stri_enc_toutf8.md) `stri_encode()`
