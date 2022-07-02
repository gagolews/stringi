# stri_timezone_info: Query a Given Time Zone

## Description

Provides some basic information on a given time zone identifier.

## Usage

``` r
stri_timezone_info(tz = NULL, locale = NULL, display_type = "long")
```

## Arguments

|                |                                                                                                                                               |
|----------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| `tz`           | `NULL` or `''` for default time zone, or a single string with time zone ID otherwise                                                          |
| `locale`       | `NULL` or `''` for default locale, or a single string with locale identifier                                                                  |
| `display_type` | single string; one of `'short'`, `'long'`, `'generic_short'`, `'generic_long'`, `'gmt_short'`, `'gmt_long'`, `'common'`, `'generic_location'` |

## Details

Used to fetch basic information on any supported time zone.

For more information on time zone representation in <span class="pkg">ICU</span>, see [`stri_timezone_list`](stri_timezone_list.md).

## Value

Returns a list with the following named components:

1.  `ID` (time zone identifier),

2.  `Name` (localized human-readable time zone name),

3.  `Name.Daylight` (localized human-readable time zone name when DST is used, if available),

4.  `Name.Windows` (Windows time zone ID, if available),

5.  `RawOffset` (raw GMT offset, in hours, before taking daylight savings into account), and

6.  `UsesDaylightTime` (states whether a time zone uses daylight savings time in the current Gregorian calendar year).

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi: [10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other datetime: [`stri_datetime_add()`](stri_datetime_add.md), [`stri_datetime_create()`](stri_datetime_create.md), [`stri_datetime_fields()`](stri_datetime_fields.md), [`stri_datetime_format()`](stri_datetime_format.md), [`stri_datetime_fstr()`](stri_datetime_fstr.md), [`stri_datetime_now()`](stri_datetime_now.md), [`stri_datetime_symbols()`](stri_datetime_symbols.md), [`stri_timezone_get()`](stri_timezone_set.md), [`stri_timezone_list()`](stri_timezone_list.md)

Other timezone: [`stri_timezone_get()`](stri_timezone_set.md), [`stri_timezone_list()`](stri_timezone_list.md)

## Examples




```r
stri_timezone_info()
## $ID
## [1] "Australia/Melbourne"
## 
## $Name
## [1] "Australian Eastern Standard Time"
## 
## $Name.Daylight
## [1] "Australian Eastern Daylight Time"
## 
## $Name.Windows
## [1] "AUS Eastern Standard Time"
## 
## $RawOffset
## [1] 10
## 
## $UsesDaylightTime
## [1] TRUE
stri_timezone_info(locale='sk_SK')
## $ID
## [1] "Australia/Melbourne"
## 
## $Name
## [1] "východoaustrálsky štandardný čas"
## 
## $Name.Daylight
## [1] "východoaustrálsky letný čas"
## 
## $Name.Windows
## [1] "AUS Eastern Standard Time"
## 
## $RawOffset
## [1] 10
## 
## $UsesDaylightTime
## [1] TRUE
sapply(c('short', 'long', 'generic_short', 'generic_long',
         'gmt_short', 'gmt_long', 'common', 'generic_location'),
  function(e) stri_timezone_info('Europe/London', display_type=e))
##                  short               long                 
## ID               "Europe/London"     "Europe/London"      
## Name             "GMT"               "Greenwich Mean Time"
## Name.Daylight    "GMT+1"             "British Summer Time"
## Name.Windows     "GMT Standard Time" "GMT Standard Time"  
## RawOffset        0                   0                    
## UsesDaylightTime TRUE                TRUE                 
##                  generic_short         generic_long         
## ID               "Europe/London"       "Europe/London"      
## Name             "United Kingdom Time" "United Kingdom Time"
## Name.Daylight    "United Kingdom Time" "United Kingdom Time"
## Name.Windows     "GMT Standard Time"   "GMT Standard Time"  
## RawOffset        0                     0                    
## UsesDaylightTime TRUE                  TRUE                 
##                  gmt_short           gmt_long            common             
## ID               "Europe/London"     "Europe/London"     "Europe/London"    
## Name             "+0000"             "GMT"               "GMT"              
## Name.Daylight    "+0100"             "GMT+01:00"         "GMT+1"            
## Name.Windows     "GMT Standard Time" "GMT Standard Time" "GMT Standard Time"
## RawOffset        0                   0                   0                  
## UsesDaylightTime TRUE                TRUE                TRUE               
##                  generic_location     
## ID               "Europe/London"      
## Name             "United Kingdom Time"
## Name.Daylight    "United Kingdom Time"
## Name.Windows     "GMT Standard Time"  
## RawOffset        0                    
## UsesDaylightTime TRUE
```
