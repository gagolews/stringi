# stri\_locale\_set: Set or Get Default Locale in <span class="pkg">stringi</span>

## Description

`stri_locale_set` changes the default locale for all the functions in the <span class="pkg">stringi</span> package, i.e., establishes the meaning of the "`NULL` locale" argument of locale-sensitive functions. `stri_locale_get` gives the current default locale.

## Usage

```r
stri_locale_set(locale)

stri_locale_get()
```

## Arguments

|          |                                                                                                                                                                                                |
|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `locale` | single string of the form `Language`, `Language_Country`, or `Language_Country_Variant`, e.g., `'en_US'`, see [`stri_locale_list`](https://stringi.gagolewski.com/rapi/stri_locale_list.html). |

## Details

See [stringi-locale](https://stringi.gagolewski.com/rapi/stringi-locale.html) for more information on the effect of changing the default locale.

`stri_locale_get` is the same as [`stri_locale_info`](https://stringi.gagolewski.com/rapi/stri_locale_info.html)(NULL)\$Name.

## Value

`stri_locale_set` returns a string with previously used locale, invisibly.

`stri_locale_get` returns a string of the form `Language`, `Language_Country`, or `Language_Country_Variant`, e.g., `'en_US'`.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other locale\_management: [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`stri_locale_info`](https://stringi.gagolewski.com/rapi/stri_locale_info.html)(), [`stri_locale_list`](https://stringi.gagolewski.com/rapi/stri_locale_list.html)()

## Examples




```r
## Not run: 
oldloc <- stri_locale_set('pt_BR')
## You are now working with stringi_1.6.2.9001 (pt_BR.UTF-8; ICU4C 69.1 [bundle]; Unicode 13.0)
# ... some locale-dependent operations
# ... note that you may always modify a locale per-call
# ... changing the default locale is convenient if you perform
# ... many operations
stri_locale_set(oldloc) # restore the previous default locale
## You are now working with stringi_1.6.2.9001 (en_AU.UTF-8; ICU4C 69.1 [bundle]; Unicode 13.0)
## End(Not run)
```
