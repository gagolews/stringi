# stri\_datetime\_fstr: Convert strptime-Style Format Strings

## Description

A function to convert [`strptime`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/strptime.html)/[`strftime`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/strptime.html)-style format strings to <span class="pkg">ICU</span> format strings that may be used in [`stri_datetime_parse`](https://stringi.gagolewski.com/rapi/stri_datetime_parse.html) and [`stri_datetime_format`](https://stringi.gagolewski.com/rapi/stri_datetime_format.html) functions.

## Usage

```r
stri_datetime_fstr(x)
```

## Arguments

|     |                                                         |
|-----|---------------------------------------------------------|
| `x` | character vector consisting of date/time format strings |

## Details

For more details on conversion specifiers please refer to the manual page of [`strptime`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/strptime.html). Most of the formatters of the form `%x`, where `x` is a letter, are supported. Moreover, each `%%` is replaced with `%`.

Warnings are given in case of `%x`, `%X`, `%u`, `%w`, `%g`, `%G`, `%c`, `%U` and `%W` as in such circumstances either <span class="pkg">ICU</span> does not support the functionality requested using the format-strings API or there are some inconsistencies between base R and <span class="pkg">ICU</span>.

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other datetime: [`stri_datetime_add`](https://stringi.gagolewski.com/rapi/stri_datetime_add.html)(), [`stri_datetime_create`](https://stringi.gagolewski.com/rapi/stri_datetime_create.html)(), [`stri_datetime_fields`](https://stringi.gagolewski.com/rapi/stri_datetime_fields.html)(), [`stri_datetime_format`](https://stringi.gagolewski.com/rapi/stri_datetime_format.html)(), [`stri_datetime_now`](https://stringi.gagolewski.com/rapi/stri_datetime_now.html)(), [`stri_datetime_symbols`](https://stringi.gagolewski.com/rapi/stri_datetime_symbols.html)(), [`stri_timezone_get`](https://stringi.gagolewski.com/rapi/stri_timezone_get.html)(), [`stri_timezone_info`](https://stringi.gagolewski.com/rapi/stri_timezone_info.html)(), [`stri_timezone_list`](https://stringi.gagolewski.com/rapi/stri_timezone_list.html)()

## Examples




```r
stri_datetime_fstr('%Y-%m-%d %H:%M:%S')
## [1] "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
```
