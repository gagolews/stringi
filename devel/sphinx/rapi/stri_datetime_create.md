# stri_datetime_create: Create a Date-Time Object

## Description

Constructs date-time objects from numeric representations.

## Usage

``` r
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

|           |                                                                                                                                                             |
|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `year`    | integer vector; 0 is 1BC, -1 is 2BC, etc.                                                                                                                   |
| `month`   | integer vector; months are 1-based                                                                                                                          |
| `day`     | integer vector                                                                                                                                              |
| `hour`    | integer vector                                                                                                                                              |
| `minute`  | integer vector                                                                                                                                              |
| `second`  | numeric vector; fractional seconds are allowed                                                                                                              |
| `lenient` | single logical value; should the operation be lenient?                                                                                                      |
| `tz`      | `NULL` or `''` for the default time zone or a single string with time zone identifier, see [`stri_timezone_list`](stri_timezone_list.md)                    |
| `locale`  | `NULL` or `''` for default locale, or a single string with locale identifier; a non-Gregorian calendar may be specified by setting `@calendar=name` keyword |

## Details

Vectorized over `year`, `month`, `day`, `hour`, `hour`, `minute`, and `second`.

## Value

Returns an object of class [`POSIXct`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/DateTimeClasses.html).

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi:<https://dx.doi.org/10.18637/jss.v103.i02>

Other datetime: [`stri_datetime_add()`](stri_datetime_add.md), [`stri_datetime_fields()`](stri_datetime_fields.md), [`stri_datetime_format()`](stri_datetime_format.md), [`stri_datetime_fstr()`](stri_datetime_fstr.md), [`stri_datetime_now()`](stri_datetime_now.md), [`stri_datetime_symbols()`](stri_datetime_symbols.md), [`stri_timezone_get()`](stri_timezone_set.md), [`stri_timezone_info()`](stri_timezone_info.md), [`stri_timezone_list()`](stri_timezone_list.md)

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
