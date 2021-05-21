# stri\_enc\_toutf8: Convert Strings To UTF-8

## Description

Converts character strings with declared marked encodings to UTF-8 strings.

## Usage

```r
stri_enc_toutf8(str, is_unknown_8bit = FALSE, validate = FALSE)
```

## Arguments

|                   |                                                   |
|-------------------|---------------------------------------------------|
| `str`             | a character vector to be converted                |
| `is_unknown_8bit` | a single logical value, see Details               |
| `validate`        | a single logical value (can be `NA`), see Details |

## Details

If `is_unknown_8bit` is set to `FALSE` (the default), then R encoding marks are used, see [`stri_enc_mark`](https://stringi.gagolewski.com/rapi/stri_enc_mark.html). Bytes-marked strings will cause the function to fail.

If a string is in UTF-8 and has a byte order mark (BOM), then the BOM will be silently removed from the output string.

If the default encoding is UTF-8, see [`stri_enc_get`](https://stringi.gagolewski.com/rapi/stri_enc_get.html), then strings marked with `native` are -- for efficiency reasons -- returned as-is, i.e., with unchanged markings. A similar behavior is observed when calling [`enc2utf8`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/Encoding.html).

For `is_unknown_8bit=TRUE`, if a string is declared to be neither in ASCII nor in UTF-8, then all byte codes \> 127 are replaced with the Unicode REPLACEMENT CHARACTER (\\Ufffd). Note that the REPLACEMENT CHARACTER may be interpreted as Unicode missing value for single characters. Here a `bytes`-marked string is assumed to use an 8-bit encoding that extends the ASCII map.

What is more, setting `validate` to `TRUE` or `NA` in both cases validates the resulting UTF-8 byte stream. If `validate=TRUE`, then in case of any incorrect byte sequences, they will be replaced with the REPLACEMENT CHARACTER. This option may be used in a case where you want to fix an invalid UTF-8 byte sequence. For `NA`, a bogus string will be replaced with a missing value.

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other encoding\_conversion: [`about_encoding`](https://stringi.gagolewski.com/rapi/about_encoding.html), [`stri_enc_fromutf32`](https://stringi.gagolewski.com/rapi/stri_enc_fromutf32.html)(), [`stri_enc_toascii`](https://stringi.gagolewski.com/rapi/stri_enc_toascii.html)(), [`stri_enc_tonative`](https://stringi.gagolewski.com/rapi/stri_enc_tonative.html)(), [`stri_enc_toutf32`](https://stringi.gagolewski.com/rapi/stri_enc_toutf32.html)(), [`stri_encode`](https://stringi.gagolewski.com/rapi/stri_encode.html)()
