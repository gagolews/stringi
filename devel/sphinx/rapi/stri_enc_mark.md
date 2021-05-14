# stri\_enc\_mark: Get Declared Encodings of Each String

## Description

Reads declared encodings for each string in a character vector as seen by <span class="pkg">stringi</span>.

## Usage

```r
stri_enc_mark(str)
```

## Arguments

|       |                                                               |
|-------|---------------------------------------------------------------|
| `str` | character vector or an object coercible to a character vector |

## Details

According to [`Encoding`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/Encoding.html), <span style="font-family: Courier New, Courier; color: #666666;">**R**</span> has a simple encoding marking mechanism: strings can be declared to be in `latin1`, `UTF-8` or `bytes`.

Moreover, we may check (via the R/C API) whether a string is in ASCII (<span style="font-family: Courier New, Courier; color: #666666;">**R**</span> assumes that this holds if and only if all bytes in a string are not greater than 127, so there is an implicit assumption that your platform uses an encoding that extends ASCII) or in the system\'s default (a.k.a. `unknown` in [`Encoding`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/Encoding.html)) encoding.

Intuitively, the default encoding should be equivalent to the one you use on `stdin` (e.g., your \'keyboard\'). In <span class="pkg">stringi</span> we assume that such an encoding is equivalent to the one returned by [`stri_enc_get`](stri_enc_set.md). It is automatically detected by <span class="pkg">ICU</span> to match -- by default -- the encoding part of the `LC_CTYPE` category as given by [`Sys.getlocale`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/locales.html).

## Value

Returns a character vector of the same length as `str`. Unlike in the [`Encoding`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/Encoding.html) function, here the possible encodings are: `ASCII`, `latin1`, `bytes`, `native`, and `UTF-8`. Additionally, missing values are handled properly.

This gives exactly the same data that is used by all the functions in <span class="pkg">stringi</span> to re-encode their inputs.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other encoding\_management: [`about_encoding`](about_encoding.md), [`stri_enc_info()`,](stri_enc_info.md) [`stri_enc_list()`,](stri_enc_list.md) `stri_enc_set()`
