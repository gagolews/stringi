# stri_encode: Convert Strings Between Given Encodings

## Description

These functions convert strings between encodings. They aim to serve as a more portable and faster replacement for <span style="font-family: Courier New, Courier; color: #666666;">**R**</span>\'s own [`iconv`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/iconv.html).

## Usage

``` r
stri_encode(str, from = NULL, to = NULL, to_raw = FALSE)

stri_conv(str, from = NULL, to = NULL, to_raw = FALSE)
```

## Arguments

|          |                                                                                                                                                                                                  |
|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`    | a character vector, a raw vector, or a list of `raw` vectors to be converted                                                                                                                     |
| `from`   | input encoding: `NULL` or `''` for the default encoding or internal encoding marks\' usage (see Details); otherwise, a single string with encoding name, see [`stri_enc_list`](stri_enc_list.md) |
| `to`     | target encoding: `NULL` or `''` for default encoding (see [`stri_enc_get`](stri_enc_set.md)), or a single string with encoding name                                                              |
| `to_raw` | a single logical value; indicates whether a list of raw vectors rather than a character vector should be returned                                                                                |

## Details

`stri_conv` is an alias for `stri_encode`.

Refer to [`stri_enc_list`](stri_enc_list.md) for the list of supported encodings and [stringi-encoding](about_encoding.md) for a general discussion.

If `from` is either missing, `''`, or `NULL`, and if `str` is a character vector then the marked encodings are used (see [`stri_enc_mark`](stri_enc_mark.md)) -- in such a case `bytes`-declared strings are disallowed. Otherwise, i.e., if `str` is a `raw`-type vector or a list of raw vectors, we assume that the input encoding is the current default encoding as given by [`stri_enc_get`](stri_enc_set.md).

However, if `from` is given explicitly, the internal encoding declarations are always ignored.

For `to_raw=FALSE`, the output strings always have the encodings marked according to the target converter used (as specified by `to`) and the current default Encoding (`ASCII`, `latin1`, `UTF-8`, `native`, or `bytes` in all other cases).

Note that some issues might occur if `to` indicates, e.g, UTF-16 or UTF-32, as the output strings may have embedded NULs. In such cases, please use `to_raw=TRUE` and consider specifying a byte order marker (BOM) for portability reasons (e.g., set `UTF-16` or `UTF-32` which automatically adds the BOMs).

Note that `stri_encode(as.raw(data), 'encodingname')` is a clever substitute for [`rawToChar`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/rawConversion.html).

In the current version of <span class="pkg">stringi</span>, if an incorrect code point is found on input, it is replaced with the default (for that target encoding) \'missing/erroneous\' character (with a warning), e.g., the SUBSTITUTE character (U+001A) or the REPLACEMENT one (U+FFFD). Occurrences thereof can be located in the output string to diagnose the problematic sequences, e.g., by calling: `stri_locate_all_regex(converted_string, '[\ufffd\u001a]'`.

Because of the way this function is currently implemented, maximal size of a single string to be converted cannot exceed \~0.67 GB.

## Value

If `to_raw` is `FALSE`, then a character vector with encoded strings (and appropriate encoding marks) is returned. Otherwise, a list of vectors of type raw is produced.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Conversion* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/conversion/>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other encoding_conversion: [`about_encoding`](about_encoding.md), [`stri_enc_fromutf32()`](stri_enc_fromutf32.md), [`stri_enc_toascii()`](stri_enc_toascii.md), [`stri_enc_tonative()`](stri_enc_tonative.md), [`stri_enc_toutf32()`](stri_enc_toutf32.md), [`stri_enc_toutf8()`](stri_enc_toutf8.md)
