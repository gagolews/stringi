# stri\_locale\_info: Query Given Locale

## Description

Provides some basic information on a given locale identifier.

## Usage

```r
stri_locale_info(locale = NULL)
```

## Arguments

|          |                                                                               |
|----------|-------------------------------------------------------------------------------|
| `locale` | `NULL` or `''` for default locale, or a single string with locale identifier. |

## Details

With this function you may obtain some basic information on any provided locale identifier, even if it is unsupported by <span class="pkg">ICU</span> or if you pass a malformed locale identifier (the one that is not, e.g., of the form Language\_Country). See [stringi-locale](https://stringi.gagolewski.com/rapi/stringi-locale.html) for discussion.

This function does not do anything really complicated. In many cases it is similar to a call to [`as.list(stri_split_fixed`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/list.html)(locale, \'\_\', 3L)\[\[1\]\]), with `locale` case mapped. It may be used, however, to get insight on how ICU understands a given locale identifier.

## Value

Returns a list with the following named character strings: `Language`, `Country`, `Variant`, and `Name`, being their underscore separated combination.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other locale\_management: [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`stri_locale_list`](https://stringi.gagolewski.com/rapi/stri_locale_list.html)(), [`stri_locale_set`](https://stringi.gagolewski.com/rapi/stri_locale_set.html)()

## Examples




```r
stri_locale_info('pl_PL')
## $Language
## [1] "pl"
## 
## $Country
## [1] "PL"
## 
## $Variant
## [1] ""
## 
## $Name
## [1] "pl_PL"
stri_locale_info('Pl_pL') # the same result
## $Language
## [1] "pl"
## 
## $Country
## [1] "PL"
## 
## $Variant
## [1] ""
## 
## $Name
## [1] "pl_PL"
```
