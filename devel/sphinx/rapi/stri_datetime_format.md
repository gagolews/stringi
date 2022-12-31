# stri_datetime_format: Date and Time Formatting and Parsing

## Description

These functions convert a given date/time object to a character vector, or vice versa.

## Usage

``` r
stri_datetime_format(
  time,
  format = "uuuu-MM-dd HH:mm:ss",
  tz = NULL,
  locale = NULL
)

stri_datetime_parse(
  str,
  format = "uuuu-MM-dd HH:mm:ss",
  lenient = FALSE,
  tz = NULL,
  locale = NULL
)
```

## Arguments

|           |                                                                                                                                                                                                                      |
|-----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `time`    | an object of class [`POSIXct`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/DateTimeClasses.html) (`as.POSIXct` will be called on character vectors and objects of class `POSIXlt`, `Date`, and `factor`) |
| `format`  | character vector, see Details; see also [`stri_datetime_fstr`](stri_datetime_fstr.md)                                                                                                                                |
| `tz`      | `NULL` or `''` for the default time zone or a single string with a timezone identifier, see [`stri_timezone_get`](stri_timezone_set.md) and [`stri_timezone_list`](stri_timezone_list.md)                            |
| `locale`  | `NULL` or `''` for the default locale, or a single string with locale identifier; a non-Gregorian calendar may be specified by setting the `@calendar=name` keyword                                                  |
| `str`     | character vector                                                                                                                                                                                                     |
| `lenient` | single logical value; should date/time parsing be lenient?                                                                                                                                                           |

## Details

Vectorized over `format` and `time` or `str`.

By default, `stri_datetime_format` (for the sake of compatibility with the [`strftime`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/strftime.html) function) formats a date/time object using the current default time zone.

Unspecified fields (e.g., seconds where only hours and minutes are given) are filled with the ones based on current date and time.

`format` may be one of `DT_STYLE` or `DT_relative_STYLE`, where `DT` is equal to `date`, `time`, or `datetime`, and `STYLE` is equal to `full`, `long`, `medium`, or `short`. This gives a locale-dependent date and/or time format. Note that currently <span class="pkg">ICU</span> does not support `relative` `time` formats, thus this flag is currently ignored in such a context.

Otherwise, `format` is a pattern: a string where specific sequences of characters are replaced with date/time data from a calendar when formatting or used to generate data for a calendar when parsing. For example, `y` stands for \'year\'. Characters may be used multiple times: `yy` might produce `99`, whereas `yyyy` yields `1999`. For most numerical fields, the number of characters specifies the field width. For example, if `h` is the hour, `h` might produce `5`, but `hh` yields `05`. For some characters, the count specifies whether an abbreviated or full form should be used.

Two single quotes represent a literal single quote, either inside or outside single quotes. Text within single quotes is not interpreted in any way (except for two adjacent single quotes). Otherwise, all ASCII letters from `a` to `z` and `A` to `Z` are reserved as syntax characters, and require quoting if they are to represent literal characters. In addition, certain ASCII punctuation characters may become available in the future (e.g., `:` being interpreted as the time separator and `/` as a date separator, and replaced by respective locale-sensitive characters in display).

|            |                                                        |                |                                  |
|:-----------|:-------------------------------------------------------|:---------------|:---------------------------------|
| **Symbol** | **Meaning**                                            | **Example(s)** | **Output**                       |
| G          | era designator                                         | G, GG, or GGG  | AD                               |
|            |                                                        | GGGG           | Anno Domini                      |
|            |                                                        | GGGGG          | A                                |
| y          | year                                                   | yy             | 96                               |
|            |                                                        | y or yyyy      | 1996                             |
| u          | extended year                                          | u              | 4601                             |
| U          | cyclic year name, as in Chinese lunar calendar         | U              |                                  |
| r          | related Gregorian year                                 | r              | 1996                             |
| Q          | quarter                                                | Q or QQ        | 02                               |
|            |                                                        | QQQ            | Q2                               |
|            |                                                        | QQQQ           | 2nd quarter                      |
|            |                                                        | QQQQQ          | 2                                |
| q          | Stand Alone quarter                                    | q or qq        | 02                               |
|            |                                                        | qqq            | Q2                               |
|            |                                                        | qqqq           | 2nd quarter                      |
|            |                                                        | qqqqq          | 2                                |
| M          | month in year                                          | M or MM        | 09                               |
|            |                                                        | MMM            | Sep                              |
|            |                                                        | MMMM           | September                        |
|            |                                                        | MMMMM          | S                                |
| L          | Stand Alone month in year                              | L or LL        | 09                               |
|            |                                                        | LLL            | Sep                              |
|            |                                                        | LLLL           | September                        |
|            |                                                        | LLLLL          | S                                |
| w          | week of year                                           | w or ww        | 27                               |
| W          | week of month                                          | W              | 2                                |
| d          | day in month                                           | d              | 2                                |
|            |                                                        | dd             | 02                               |
| D          | day of year                                            | D              | 189                              |
| F          | day of week in month                                   | F              | 2 (2nd Wed in July)              |
| g          | modified Julian day                                    | g              | 2451334                          |
| E          | day of week                                            | E, EE, or EEE  | Tue                              |
|            |                                                        | EEEE           | Tuesday                          |
|            |                                                        | EEEEE          | T                                |
|            |                                                        | EEEEEE         | Tu                               |
| e          | local day of week                                      | e or ee        | 2                                |
|            | example: if Monday is 1st day, Tuesday is 2nd )        | eee            | Tue                              |
|            |                                                        | eeee           | Tuesday                          |
|            |                                                        | eeeee          | T                                |
|            |                                                        | eeeeee         | Tu                               |
| c          | Stand Alone local day of week                          | c or cc        | 2                                |
|            |                                                        | ccc            | Tue                              |
|            |                                                        | cccc           | Tuesday                          |
|            |                                                        | ccccc          | T                                |
|            |                                                        | cccccc         | Tu                               |
| a          | am/pm marker                                           | a              | pm                               |
| h          | hour in am/pm (1\~12)                                  | h              | 7                                |
|            |                                                        | hh             | 07                               |
| H          | hour in day (0\~23)                                    | H              | 0                                |
|            |                                                        | HH             | 00                               |
| k          | hour in day (1\~24)                                    | k              | 24                               |
|            |                                                        | kk             | 24                               |
| K          | hour in am/pm (0\~11)                                  | K              | 0                                |
|            |                                                        | KK             | 00                               |
| m          | minute in hour                                         | m              | 4                                |
|            |                                                        | mm             | 04                               |
| s          | second in minute                                       | s              | 5                                |
|            |                                                        | ss             | 05                               |
| S          | fractional second - truncates (like other time fields) | S              | 2                                |
|            | to the count of letters when formatting. Appends       | SS             | 23                               |
|            | zeros if more than 3 letters specified. Truncates at   | SSS            | 235                              |
|            | three significant digits when parsing.                 | SSSS           | 2350                             |
| A          | milliseconds in day                                    | A              | 61201235                         |
| z          | Time Zone: specific non-location                       | z, zz, or zzz  | PDT                              |
|            |                                                        | zzzz           | Pacific Daylight Time            |
| Z          | Time Zone: ISO8601 basic hms? / RFC 822                | Z, ZZ, or ZZZ  | -0800                            |
|            | Time Zone: long localized GMT (=OOOO)                  | ZZZZ           | GMT-08:00                        |
|            | Time Zone: ISO8601 extended hms? (=XXXXX)              | ZZZZZ          | -08:00, -07:52:58, Z             |
| O          | Time Zone: short localized GMT                         | O              | GMT-8                            |
|            | Time Zone: long localized GMT (=ZZZZ)                  | OOOO           | GMT-08:00                        |
| v          | Time Zone: generic non-location                        | v              | PT                               |
|            | (falls back first to VVVV)                             | vvvv           | Pacific Time or Los Angeles Time |
| V          | Time Zone: short time zone ID                          | V              | uslax                            |
|            | Time Zone: long time zone ID                           | VV             | America/Los_Angeles              |
|            | Time Zone: time zone exemplar city                     | VVV            | Los Angeles                      |
|            | Time Zone: generic location (falls back to OOOO)       | VVVV           | Los Angeles Time                 |
| X          | Time Zone: ISO8601 basic hm?, with Z for 0             | X              | -08, +0530, Z                    |
|            | Time Zone: ISO8601 basic hm, with Z                    | XX             | -0800, Z                         |
|            | Time Zone: ISO8601 extended hm, with Z                 | XXX            | -08:00, Z                        |
|            | Time Zone: ISO8601 basic hms?, with Z                  | XXXX           | -0800, -075258, Z                |
|            | Time Zone: ISO8601 extended hms?, with Z               | XXXXX          | -08:00, -07:52:58, Z             |
| x          | Time Zone: ISO8601 basic hm?, without Z for 0          | x              | -08, +0530                       |
|            | Time Zone: ISO8601 basic hm, without Z                 | xx             | -0800                            |
|            | Time Zone: ISO8601 extended hm, without Z              | xxx            | -08:00                           |
|            | Time Zone: ISO8601 basic hms?, without Z               | xxxx           | -0800, -075258                   |
|            | Time Zone: ISO8601 extended hms?, without Z            | xxxxx          | -08:00, -07:52:58                |
| \'         | escape for text                                        | \'             | (nothing)                        |
| \' \'      | two single quotes produce one                          | \' \'          | \'                               |

Note that any characters in the pattern that are not in the ranges of `[a-z]` and `[A-Z]` will be treated as quoted text. For instance, characters like `:`, `.`, (a space), `#` and `@` will appear in the resulting time text even if they are not enclosed within single quotes. The single quote is used to "escape" the letters. Two single quotes in a row, inside or outside a quoted sequence, represent a "real" single quote.

A few examples:

|                                |                                                   |
|:-------------------------------|:--------------------------------------------------|
| **Example Pattern**            | **Result**                                        |
| yyyy.MM.dd \'at\' HH:mm:ss zzz | 2015.12.31 at 23:59:59 GMT+1                      |
| EEE, MMM d, \'\'yy             | czw., gru 31, \'15                                |
| h:mm a                         | 11:59 PM                                          |
| hh \'o\'\'clock\' a, zzzz      | 11 o\'clock PM, GMT+01:00                         |
| K:mm a, z                      | 11:59 PM, GMT+1                                   |
| yyyyy.MMMM.dd GGG hh:mm aaa    | 2015.grudnia.31 n.e. 11:59 PM                     |
| uuuu-MM-dd\'T\'HH:mm:ssZ       | 2015-12-31T23:59:59+0100 (the ISO 8601 guideline) |
|                                |                                                   |

## Value

`stri_datetime_format` returns a character vector.

`stri_datetime_parse` returns an object of class [`POSIXct`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/DateTimeClasses.html).

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Formatting Dates and Times* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/format_parse/datetime/>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other datetime: [`stri_datetime_add()`](stri_datetime_add.md), [`stri_datetime_create()`](stri_datetime_create.md), [`stri_datetime_fields()`](stri_datetime_fields.md), [`stri_datetime_fstr()`](stri_datetime_fstr.md), [`stri_datetime_now()`](stri_datetime_now.md), [`stri_datetime_symbols()`](stri_datetime_symbols.md), [`stri_timezone_get()`](stri_timezone_set.md), [`stri_timezone_info()`](stri_timezone_info.md), [`stri_timezone_list()`](stri_timezone_list.md)

## Examples




```r
x <- c('2015-02-28', '2015-02-29')
stri_datetime_parse(x, 'yyyy-MM-dd')
## [1] "2015-02-28 12:20:55 AEDT" NA
stri_datetime_parse(x, 'yyyy-MM-dd', lenient=TRUE)
## [1] "2015-02-28 12:20:55 AEDT" "2015-03-01 12:20:55 AEDT"
stri_datetime_parse(x %s+% " 00:00:00", "yyyy-MM-dd HH:mm:ss")
## [1] "2015-02-28 00:00:00 AEDT" NA
stri_datetime_parse('19 lipca 2015', 'date_long', locale='pl_PL')
## [1] "2015-07-19 12:20:55 AEST"
stri_datetime_format(stri_datetime_now(), 'datetime_relative_medium')
## [1] "today, 12:20:55 pm"
```
