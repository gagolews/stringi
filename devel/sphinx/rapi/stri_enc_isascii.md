# stri\_enc\_isascii: Check If a Data Stream Is Possibly in ASCII

## Description

The function checks whether all bytes in a string are \<= 127.

## Usage

```r
stri_enc_isascii(str)
```

## Arguments

|       |                                                            |
|-------|------------------------------------------------------------|
| `str` | character vector, a raw vector, or a list of `raw` vectors |

## Details

This function is independent of the way <span style="font-family: Courier New, Courier; color: #666666;">**R**</span> marks encodings in character strings (see [Encoding](https://stat.ethz.ch/R-manual/R-patched/library/base/html/Encoding.html) and [stringi-encoding](../../stringi/help/stringi-encoding.html)).

## Value

Returns a logical vector. The i-th element indicates whether the i-th string corresponds to a valid ASCII byte sequence.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other encoding\_detection: [`about_encoding`](https://stringi.gagolewski.com/rapi/about_encoding.html), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_enc_detect`](https://stringi.gagolewski.com/rapi/stri_enc_detect.html)(), [`stri_enc_isutf16be`](https://stringi.gagolewski.com/rapi/stri_enc_isutf16be.html)(), [`stri_enc_isutf8`](https://stringi.gagolewski.com/rapi/stri_enc_isutf8.html)()

## Examples




```r
stri_enc_isascii(letters[1:3])
## [1] TRUE TRUE TRUE
stri_enc_isascii('\u0105\u0104')
## [1] FALSE
```
