# stri_locale_set:

## Description

`stri_locale_set` changes the default locale for all the functions in the <span class="pkg">stringi</span> package, i.e., establishes the meaning of the "`NULL` locale" argument of locale-sensitive functions. `stri_locale_get` gives the current default locale.

## Usage

``` r
stri_locale_set(locale)

stri_locale_get()
```

## Arguments

|          |                                                                                                                                                          |
|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `locale` | single string of the form `Language`, `Language_Country`, or `Language_Country_Variant`, e.g., `'en_US'`, see [`stri_locale_list`](stri_locale_list.md). |

## Details

See [stringi-locale](about_locale.md) for more information on the effect of changing the default locale.

`stri_locale_get` is the same as [`stri_locale_info(NULL)$Name`](stri_locale_info.md).

## Value

`stri_locale_set` returns a string with previously used locale, invisibly.

`stri_locale_get` returns a string of the form `Language`, `Language_Country`, or `Language_Country_Variant`, e.g., `'en_US'`.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other locale_management: [`about_locale`](about_locale.md), [`stri_locale_info()`](stri_locale_info.md), [`stri_locale_list()`](stri_locale_list.md)

## Examples




```r
## Not run: 
oldloc <- stri_locale_set('pt_BR')
```

```
## You are now working with stringi_1.7.9003 (pt_BR.UTF-8; ICU4C 74.1 [bundle]; Unicode 15.1)
```

```r
# ... some locale-dependent operations
# ... note that you may always modify a locale per-call
# ... changing the default locale is convenient if you perform
# ... many operations
stri_locale_set(oldloc) # restore the previous default locale
```

```
## You are now working with stringi_1.7.9003 (en_AU.UTF-8; ICU4C 74.1 [bundle]; Unicode 15.1)
```

```r
## End(Not run)
```
