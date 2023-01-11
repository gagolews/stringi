# stri_datetime_add: Date and Time Arithmetic

## Description

Modifies a date-time object by adding a specific amount of time units.

## Usage

``` r
stri_datetime_add(
  time,
  value = 1L,
  units = "seconds",
  tz = NULL,
  locale = NULL
)

stri_datetime_add(time, units = "seconds", tz = NULL, locale = NULL) <- value
```

## Arguments

|          |                                                                                                                                                                                                                      |
|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `time`   | an object of class [`POSIXct`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/DateTimeClasses.html) (`as.POSIXct` will be called on character vectors and objects of class `POSIXlt`, `Date`, and `factor`) |
| `value`  | integer vector; signed number of units to add to `time`                                                                                                                                                              |
| `units`  | single string; one of `'years'`, `'months'`, `'weeks'`, `'days'`, `'hours'`, `'minutes'`, `'seconds'`, or `'milliseconds'`                                                                                           |
| `tz`     | `NULL` or `''` for the default time zone or a single string with a timezone identifier,                                                                                                                              |
| `locale` | `NULL` or `''` for default locale, or a single string with locale identifier; a non-Gregorian calendar may be specified by setting the `@calendar=name` keyword                                                      |

## Details

Vectorized over `time` and `value`.

Note that, e.g., January, 31 + 1 month = February, 28 or 29.

## Value

Both functions return an object of class [`POSIXct`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/DateTimeClasses.html).

The replacement version of `stri_datetime_add` modifies the state of the `time` object.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Calendar Classes* - ICU User Guide, <https://unicode-org.github.io/icu/userguide/datetime/calendar/>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other datetime: [`stri_datetime_create()`](stri_datetime_create.md), [`stri_datetime_fields()`](stri_datetime_fields.md), [`stri_datetime_format()`](stri_datetime_format.md), [`stri_datetime_fstr()`](stri_datetime_fstr.md), [`stri_datetime_now()`](stri_datetime_now.md), [`stri_datetime_symbols()`](stri_datetime_symbols.md), [`stri_timezone_get()`](stri_timezone_set.md), [`stri_timezone_info()`](stri_timezone_info.md), [`stri_timezone_list()`](stri_timezone_list.md)

## Examples




```r
x <- stri_datetime_now()
stri_datetime_add(x, units='months') <- 2
print(x)
## [1] "2023-03-11 12:04:36 AEDT"
stri_datetime_add(x, -2, units='months')
## [1] "2023-01-11 12:04:36 AEDT"
stri_datetime_add(stri_datetime_create(2014, 4, 20), 1, units='years')
## [1] "2015-04-20 12:00:00 AEST"
stri_datetime_add(stri_datetime_create(2014, 4, 20), 1, units='years', locale='@calendar=hebrew')
## [1] "2015-04-09 12:00:00 AEST"
stri_datetime_add(stri_datetime_create(2016, 1, 31), 1, units='months')
## [1] "2016-02-29 12:00:00 AEDT"
```
