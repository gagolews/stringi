# stri\_enc\_toutf32: Convert Strings To UTF-32

## Description

UTF-32 is a 32-bit encoding where each Unicode code point corresponds to exactly one integer value. This function converts a character vector to a list of integer vectors so that, e.g., individual code points may be easily accessed, changed, etc.

## Usage

```r
stri_enc_toutf32(str)
```

## Arguments

|       |                                                                |
|-------|----------------------------------------------------------------|
| `str` | a character vector (or an object coercible to) to be converted |

## Details

See [`stri_enc_fromutf32`](https://stringi.gagolewski.com/rapi/stri_enc_fromutf32.html) for a dual operation.

This function is roughly equivalent to a vectorized call to [`utf8ToInt(enc2utf8(str))`. If you want a list of raw vectors on output, use](https://stat.ethz.ch/R-manual/R-patched/library/base/html/utf8Conversion.html) [`stri_encode`](https://stringi.gagolewski.com/rapi/stri_encode.html).

Unlike `utf8ToInt`, if ill-formed UTF-8 byte sequences are detected, a corresponding element is set to NULL and a warning is generated. To deal with such issues, use, e.g., [`stri_enc_toutf8`](https://stringi.gagolewski.com/rapi/stri_enc_toutf8.html).

## Value

Returns a list of integer vectors. Missing values are converted to `NULL`s.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other encoding\_conversion: [`about_encoding`](https://stringi.gagolewski.com/rapi/about_encoding.html), [`stri_enc_fromutf32`](https://stringi.gagolewski.com/rapi/stri_enc_fromutf32.html)(), [`stri_enc_toascii`](https://stringi.gagolewski.com/rapi/stri_enc_toascii.html)(), [`stri_enc_tonative`](https://stringi.gagolewski.com/rapi/stri_enc_tonative.html)(), [`stri_enc_toutf8`](https://stringi.gagolewski.com/rapi/stri_enc_toutf8.html)(), [`stri_encode`](https://stringi.gagolewski.com/rapi/stri_encode.html)()
