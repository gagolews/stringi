# stri_enc_set:

## Description

`stri_enc_set` sets the encoding used to re-encode strings internally (i.e., by <span class="rlang">**R**</span>) declared to be in native encoding, see [stringi-encoding](about_encoding.md) and [`stri_enc_mark`](stri_enc_mark.md). `stri_enc_get` returns the currently used default encoding.

## Usage

``` r
stri_enc_set(enc)

stri_enc_get()
```

## Arguments

|       |                                                                                                                      |
|-------|----------------------------------------------------------------------------------------------------------------------|
| `enc` | single string; character encoding name, see [`stri_enc_list`](stri_enc_list.md) for the list of supported encodings. |

## Details

`stri_enc_get` is the same as [`stri_enc_info(NULL)$Name.friendly`](stri_enc_info.md).

Note that changing the default encoding may have undesired consequences. Unless you are an expert user and you know what you are doing, `stri_enc_set` should only be used if <span class="pkg">ICU</span> fails to detect your system\'s encoding correctly (while testing <span class="pkg">stringi</span> we only encountered such a situation on a very old Solaris machine). Note that <span class="pkg">ICU</span> tries to match the encoding part of the `LC_CTYPE` category as given by [`Sys.getlocale`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/locales.html).

If you set a default encoding that is neither a superset of ASCII, nor an 8-bit encoding, a warning will be generated, see [stringi-encoding](about_encoding.md) for discussion.

`stri_enc_set` has no effect if the system ICU assumes that the default charset is always UTF-8 (i.e., where the internal `U_CHARSET_IS_UTF8` is defined and set to 1), see [`stri_info`](stri_info.md).

## Value

`stri_enc_set` returns a string with previously used character encoding, invisibly.

`stri_enc_get` returns a string with current default character encoding.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other encoding_management: [`about_encoding`](about_encoding.md), [`stri_enc_info()`](stri_enc_info.md), [`stri_enc_list()`](stri_enc_list.md), [`stri_enc_mark()`](stri_enc_mark.md)
