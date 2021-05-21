# stri\_datetime\_now: Get Current Date and Time

## Description

Returns the current date and time.

## Usage

```r
stri_datetime_now()
```

## Details

The current date and time in <span class="pkg">stringi</span> is represented as the (signed) number of seconds since 1970-01-01 00:00:00 UTC. UTC leap seconds are ignored.

## Value

Returns an object of class [`POSIXct`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/DateTimeClasses.html).

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other datetime: [`stri_datetime_add`](https://stringi.gagolewski.com/rapi/stri_datetime_add.html)(), [`stri_datetime_create`](https://stringi.gagolewski.com/rapi/stri_datetime_create.html)(), [`stri_datetime_fields`](https://stringi.gagolewski.com/rapi/stri_datetime_fields.html)(), [`stri_datetime_format`](https://stringi.gagolewski.com/rapi/stri_datetime_format.html)(), [`stri_datetime_fstr`](https://stringi.gagolewski.com/rapi/stri_datetime_fstr.html)(), [`stri_datetime_symbols`](https://stringi.gagolewski.com/rapi/stri_datetime_symbols.html)(), [`stri_timezone_get`](https://stringi.gagolewski.com/rapi/stri_timezone_get.html)(), [`stri_timezone_info`](https://stringi.gagolewski.com/rapi/stri_timezone_info.html)(), [`stri_timezone_list`](https://stringi.gagolewski.com/rapi/stri_timezone_list.html)()
