# stri\_locale\_list: List Available Locales

## Description

Creates a character vector with all available locale identifies.

## Usage

```r
stri_locale_list()
```

## Details

Note that some of the services may be unavailable in some locales. Querying for locale-specific services is always performed during the resource request.

See [stringi-locale](about_locale.md) for more information.

## Value

Returns a character vector with locale identifiers that are known to <span class="pkg">ICU</span>.

## See Also

Other locale\_management: [`about_locale`](about_locale.md), [`stri_locale_info()`,](stri_locale_info.md) `stri_locale_set()`
