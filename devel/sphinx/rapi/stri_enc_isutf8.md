# stri\_enc\_isutf8: Check If a Data Stream Is Possibly in UTF-8

## Description

The function checks whether given sequences of bytes forms a proper UTF-8 string.

## Usage

```r
stri_enc_isutf8(str)
```

## Arguments

|       |                                                            |
|-------|------------------------------------------------------------|
| `str` | character vector, a raw vector, or a list of `raw` vectors |

## Details

`FALSE` means that a string is certainly not valid UTF-8. However, false positives are possible. For instance, `(c4,85)` represents (\'a with ogonek\') in UTF-8 as well as (\'A umlaut\', \'Ellipsis\') in WINDOWS-1250. Also note that UTF-8, as well as most 8-bit encodings, extend ASCII (note that [`stri_enc_isascii`](https://stringi.gagolewski.com/rapi/stri_enc_isascii.html) implies that [`stri_enc_isutf8`](https://stringi.gagolewski.com/rapi/stri_enc_isutf8.html)).

However, the longer the sequence, the greater the possibility that the result is indeed in UTF-8 -- this is because not all sequences of bytes are valid UTF-8.

This function is independent of the way <span style="font-family: Courier New, Courier; color: #666666;">**R**</span> marks encodings in character strings (see [Encoding](https://stat.ethz.ch/R-manual/R-patched/library/base/html/Encoding.html) and [stringi-encoding](../../stringi/help/stringi-encoding.html)).

## Value

Returns a logical vector. Its i-th element indicates whether the i-th string corresponds to a valid UTF-8 byte sequence.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other encoding\_detection: [`about_encoding`](https://stringi.gagolewski.com/rapi/about_encoding.html), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_enc_detect`](https://stringi.gagolewski.com/rapi/stri_enc_detect.html)(), [`stri_enc_isascii`](https://stringi.gagolewski.com/rapi/stri_enc_isascii.html)(), [`stri_enc_isutf16be`](https://stringi.gagolewski.com/rapi/stri_enc_isutf16be.html)()

## Examples




```r
stri_enc_isutf8(letters[1:3])
## [1] TRUE TRUE TRUE
stri_enc_isutf8('\u0105\u0104')
## [1] TRUE
stri_enc_isutf8('\u1234\u0222')
## [1] TRUE
```
