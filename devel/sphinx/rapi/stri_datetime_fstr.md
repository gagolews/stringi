# stri_datetime_fstr: Convert `strptime`-Style Format Strings

## Description

This function converts [`strptime`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/strptime.html) or [`strftime`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/strftime.html)-style format strings to <span class="pkg">ICU</span> format strings that may be used in [`stri_datetime_parse`](stri_datetime_format.md) and [`stri_datetime_format`](stri_datetime_format.md) functions.

## Usage

``` r
stri_datetime_fstr(x, ignore_special = TRUE)
```

## Arguments

|                  |                                                                                                                                                        |
|------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| `x`              | character vector of date/time format strings                                                                                                           |
| `ignore_special` | if `FALSE`, special identifiers like `"datetime_full"` or `date_relative_short` (see [`stri_datetime_format`](stri_datetime_format.md)) are left as-is |

## Details

For more details on conversion specifiers please refer to the manual page of [`strptime`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/strptime.html). Most of the formatters of the form `%x`, where `x` is a letter, are supported. Moreover, each `%%` is replaced with `%`.

Warnings are given in the case of `%x`, `%X`, `%u`, `%w`, `%g`, `%G`, `%c`, `%U`, and `%W` as in such circumstances either <span class="pkg">ICU</span> does not support the functionality requested using the string format API or there are some inconsistencies between base R and <span class="pkg">ICU</span>.

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi:<https://dx.doi.org/10.18637/jss.v103.i02>

Other datetime: [`stri_datetime_add()`](stri_datetime_add.md), [`stri_datetime_create()`](stri_datetime_create.md), [`stri_datetime_fields()`](stri_datetime_fields.md), [`stri_datetime_format()`](stri_datetime_format.md), [`stri_datetime_now()`](stri_datetime_now.md), [`stri_datetime_symbols()`](stri_datetime_symbols.md), [`stri_timezone_get()`](stri_timezone_set.md), [`stri_timezone_info()`](stri_timezone_info.md), [`stri_timezone_list()`](stri_timezone_list.md)

## Examples




```r
stri_datetime_fstr('%Y-%m-%d %H:%M:%S')
## [1] "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
```
