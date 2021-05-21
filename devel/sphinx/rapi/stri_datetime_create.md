# stri\_datetime\_create: Create a Date-Time Object

## Description

Constructs date-time objects from numeric representations.

## Usage

```r
stri_datetime_create(
  year,
  month,
  day,
  hour = 12L,
  minute = 0L,
  second = 0,
  lenient = FALSE,
  tz = NULL,
  locale = NULL
)
```

## Arguments

|           |                                                                                                                                                                                |
|-----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `year`    | integer vector; 0 is 1BC, -1 is 2BC, etc.                                                                                                                                      |
| `month`   | integer vector; months are 1-based                                                                                                                                             |
| `day`     | integer vector                                                                                                                                                                 |
| `hour`    | integer vector                                                                                                                                                                 |
| `minute`  | integer vector                                                                                                                                                                 |
| `second`  | numeric vector; fractional seconds are allowed                                                                                                                                 |
| `lenient` | single logical value; should the operation be lenient?                                                                                                                         |
| `tz`      | `NULL` or `''` for the default time zone or a single string with time zone identifier, see [`stri_timezone_list`](https://stringi.gagolewski.com/rapi/stri_timezone_list.html) |
| `locale`  | `NULL` or `''` for default locale, or a single string with locale identifier; a non-Gregorian calendar may be specified by setting `@calendar=name` keyword                    |

## Details

Vectorized over `year`, `month`, `day`, `hour`, `hour`, `minute`, and `second`.

## Value

Returns an object of class [`POSIXct`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/DateTimeClasses.html).

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other datetime: [`stri_datetime_add`](https://stringi.gagolewski.com/rapi/stri_datetime_add.html)(), [`stri_datetime_fields`](https://stringi.gagolewski.com/rapi/stri_datetime_fields.html)(), [`stri_datetime_format`](https://stringi.gagolewski.com/rapi/stri_datetime_format.html)(), [`stri_datetime_fstr`](https://stringi.gagolewski.com/rapi/stri_datetime_fstr.html)(), [`stri_datetime_now`](https://stringi.gagolewski.com/rapi/stri_datetime_now.html)(), [`stri_datetime_symbols`](https://stringi.gagolewski.com/rapi/stri_datetime_symbols.html)(), [`stri_timezone_get`](https://stringi.gagolewski.com/rapi/stri_timezone_get.html)(), [`stri_timezone_info`](https://stringi.gagolewski.com/rapi/stri_timezone_info.html)(), [`stri_timezone_list`](https://stringi.gagolewski.com/rapi/stri_timezone_list.html)()

## Examples




```r
stri_datetime_create(2015, 12, 31, 23, 59, 59.999)
## [1] "2015-12-31 23:59:59 AEDT"
stri_datetime_create(5775, 8, 1, locale='@calendar=hebrew') # 1 Nisan 5775 -> 2015-03-21
## [1] "2015-03-21 12:00:00 AEDT"
stri_datetime_create(2015, 02, 29)
## [1] NA
stri_datetime_create(2015, 02, 29, lenient=TRUE)
## [1] "2015-03-01 12:00:00 AEDT"
```
