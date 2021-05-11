# stri\_datetime\_fstr: Convert strptime-Style Format Strings

## Description

A function to convert [`strptime`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/strptime.html)/[`strftime`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/strptime.html)-style format strings to <span class="pkg">ICU</span> format strings that may be used in [`stri_datetime_parse`](stri_datetime_format.md) and [`stri_datetime_format`](stri_datetime_format.md) functions.

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

## See Also

Other datetime: [`stri_datetime_add()`,](stri_datetime_add.md) [`stri_datetime_create()`,](stri_datetime_create.md) [`stri_datetime_fields()`,](stri_datetime_fields.md) [`stri_datetime_format()`,](stri_datetime_format.md) [`stri_datetime_now()`,](stri_datetime_now.md) [`stri_datetime_symbols()`,](stri_datetime_symbols.md) [`stri_timezone_get()`,](stri_timezone_set.md) [`stri_timezone_info()`,](stri_timezone_info.md) `stri_timezone_list()`

## Examples




```r
stri_datetime_fstr('%Y-%m-%d %H:%M:%S')
## [1] "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
```
