# stri\_enc\_fromutf32: Convert From UTF-32

## Description

This function converts integer vectors, representing sequences of UTF-32 code points, to UTF-8 strings.

## Usage

```r
stri_enc_fromutf32(vec)
```

## Arguments

|       |                                                                                                                                          |
|-------|------------------------------------------------------------------------------------------------------------------------------------------|
| `vec` | a list of integer vectors (or objects coercible to such vectors) or `NULL`s. For convenience, a single integer vector can also be given. |

## Details

UTF-32 is a 32-bit encoding where each Unicode code point corresponds to exactly one integer value.

This function is a vectorized version of [`intToUtf8`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/utf8Conversion.html). As usual in <span class="pkg">stringi</span>, it returns character strings in UTF-8. See [`stri_enc_toutf32`](stri_enc_toutf32.md) for a dual operation.

If an ill-defined code point is given, a warning is generated and the corresponding string is set to `NA`. Note that `0`s are not allowed in `vec`, as they are used internally to mark the end of a string (in the C API).

See also [`stri_encode`](stri_encode.md) for decoding arbitrary byte sequences from any given encoding.

## Value

Returns a character vector (in UTF-8). `NULL`s in the input list are converted to `NA_character_`.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other encoding\_conversion: [`about_encoding`](about_encoding.md), [`stri_enc_toascii()`,](stri_enc_toascii.md) [`stri_enc_tonative()`,](stri_enc_tonative.md) [`stri_enc_toutf32()`,](stri_enc_toutf32.md) [`stri_enc_toutf8()`,](stri_enc_toutf8.md) `stri_encode()`