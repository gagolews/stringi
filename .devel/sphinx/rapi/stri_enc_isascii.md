# stri_enc_isascii: Check If a Data Stream Is Possibly in ASCII

## Description

The function checks whether all bytes in a string are \<= 127.

## Usage

``` r
stri_enc_isascii(str)
```

## Arguments

|       |                                                            |
|-------|------------------------------------------------------------|
| `str` | character vector, a raw vector, or a list of `raw` vectors |

## Details

This function is independent of the way <span class="rlang">**R**</span> marks encodings in character strings (see [Encoding](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Encoding.html) and [stringi-encoding](about_encoding.md)).

## Value

Returns a logical vector. The i-th element indicates whether the i-th string corresponds to a valid ASCII byte sequence.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other encoding_detection: [`about_encoding`](about_encoding.md), [`stri_enc_detect2()`](stri_enc_detect2.md), [`stri_enc_detect()`](stri_enc_detect.md), [`stri_enc_isutf16be()`](stri_enc_isutf16.md), [`stri_enc_isutf8()`](stri_enc_isutf8.md)

## Examples




```r
stri_enc_isascii(letters[1:3])
```

```
## [1] TRUE TRUE TRUE
```

```r
stri_enc_isascii('\u0105\u0104')
```

```
## [1] FALSE
```
