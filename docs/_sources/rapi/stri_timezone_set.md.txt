# stri\_timezone\_set: Set or Get Default Time Zone in <span class="pkg">stringi</span>

## Description

`stri_timezone_set` changes the current default time zone for all functions in the <span class="pkg">stringi</span> package, i.e., establishes the meaning of the "`NULL` time zone" argument to date/time processing functions.

`stri_timezone_get` gets the current default time zone.

For more information on time zone representation in <span class="pkg">ICU</span> and <span class="pkg">stringi</span>, refer to [`stri_timezone_list`](https://stringi.gagolewski.com/rapi/stri_timezone_list.html).

## Usage

```r
stri_timezone_get()

stri_timezone_set(tz)
```

## Arguments

|      |                                     |
|------|-------------------------------------|
| `tz` | single string; time zone identifier |

## Details

Unless the default time zone has already been set using `stri_timezone_set`, the default time zone is determined by querying the OS with methods in <span class="pkg">ICU</span>\'s internal platform utilities.

## Value

`stri_timezone_set` returns a string with previously used timezone, invisibly.

`stri_timezone_get` returns a single string with the current default time zone.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*TimeZone* class -- ICU API Documentation, <https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/classicu_1_1TimeZone.html>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other datetime: [`stri_datetime_add`](https://stringi.gagolewski.com/rapi/stri_datetime_add.html)(), [`stri_datetime_create`](https://stringi.gagolewski.com/rapi/stri_datetime_create.html)(), [`stri_datetime_fields`](https://stringi.gagolewski.com/rapi/stri_datetime_fields.html)(), [`stri_datetime_format`](https://stringi.gagolewski.com/rapi/stri_datetime_format.html)(), [`stri_datetime_fstr`](https://stringi.gagolewski.com/rapi/stri_datetime_fstr.html)(), [`stri_datetime_now`](https://stringi.gagolewski.com/rapi/stri_datetime_now.html)(), [`stri_datetime_symbols`](https://stringi.gagolewski.com/rapi/stri_datetime_symbols.html)(), [`stri_timezone_info`](https://stringi.gagolewski.com/rapi/stri_timezone_info.html)(), [`stri_timezone_list`](https://stringi.gagolewski.com/rapi/stri_timezone_list.html)()

Other timezone: [`stri_timezone_info`](https://stringi.gagolewski.com/rapi/stri_timezone_info.html)(), [`stri_timezone_list`](https://stringi.gagolewski.com/rapi/stri_timezone_list.html)()

## Examples




```r
## Not run: 
oldtz <- stri_timezone_set('Europe/Warsaw')
# ... many time zone-dependent operations
stri_timezone_set(oldtz) # restore previous default time zone

## End(Not run)
```
