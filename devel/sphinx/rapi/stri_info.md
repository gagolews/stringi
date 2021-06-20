# stri\_info: Query Default Settings for <span class="pkg">stringi</span>

## Description

Gives the current default settings used by the <span class="pkg">ICU</span> library.

## Usage

```r
stri_info(short = FALSE)
```

## Arguments

|         |                                                                                           |
|---------|-------------------------------------------------------------------------------------------|
| `short` | logical; whether or not the results should be given in a concise form; defaults to `TRUE` |

## Value

If `short` is `TRUE`, then a single string providing information on the default character encoding, locale, and Unicode as well as <span class="pkg">ICU</span> version is returned.

Otherwise, a list with the following components is returned:

-   `Unicode.version` -- version of Unicode supported by the <span class="pkg">ICU</span> library;

-   `ICU.version` -- <span class="pkg">ICU</span> library version used;

-   `Locale` -- contains information on default locale, as returned by [`stri_locale_info`](stri_locale_info.md);

-   `Charset.internal` -- fixed at `c('UTF-8', 'UTF-16')`;

-   `Charset.native` -- information on the default encoding, as returned by [`stri_enc_info`](stri_enc_info.md);

-   `ICU.system` -- logical; `TRUE` indicates that the system <span class="pkg">ICU</span> libs are used, otherwise <span class="pkg">ICU</span> was built together with <span class="pkg">stringi</span>;

-   `ICU.UTF8` -- logical; `TRUE` if the internal `U_CHARSET_IS_UTF8` flag is defined and set.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>
