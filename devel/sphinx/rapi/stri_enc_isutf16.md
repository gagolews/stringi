# stri_enc_isutf16: Check If a Data Stream Is Possibly in UTF-16 or UTF-32

## Description

These functions detect whether a given byte stream is valid UTF-16LE, UTF-16BE, UTF-32LE, or UTF-32BE.

## Usage

``` r
stri_enc_isutf16be(str)

stri_enc_isutf16le(str)

stri_enc_isutf32be(str)

stri_enc_isutf32le(str)
```

## Arguments

|       |                                                            |
|-------|------------------------------------------------------------|
| `str` | character vector, a raw vector, or a list of `raw` vectors |

## Details

These functions are independent of the way <span style="font-family: Courier New, Courier; color: #666666;">**R**</span> marks encodings in character strings (see [Encoding](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Encoding.html) and [stringi-encoding](about_encoding.md)). Most often, these functions act on raw vectors.

A result of `FALSE` means that a string is surely not valid UTF-16 or UTF-32. However, false positives are possible.

Also note that a data stream may be sometimes classified as both valid UTF-16LE and UTF-16BE.

## Value

Returns a logical vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other encoding_detection: [`about_encoding`](about_encoding.md), [`stri_enc_detect2()`](stri_enc_detect2.md), [`stri_enc_detect()`](stri_enc_detect.md), [`stri_enc_isascii()`](stri_enc_isascii.md), [`stri_enc_isutf8()`](stri_enc_isutf8.md)
