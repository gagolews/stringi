# stri\_opts\_fixed: Generate a List with Fixed Pattern Search Engine\'s Settings

## Description

A convenience function used to tune up the behavior of `stri_*_fixed` functions, see [stringi-search-fixed](https://stringi.gagolewski.com/rapi/stringi-search-fixed.html).

## Usage

```r
stri_opts_fixed(case_insensitive = FALSE, overlap = FALSE, ...)
```

## Arguments

|                    |                                                                                                                            |
|--------------------|----------------------------------------------------------------------------------------------------------------------------|
| `case_insensitive` | logical; enable simple case insensitive matching                                                                           |
| `overlap`          | logical; enable overlapping matches\' detection                                                                            |
| `...`              | \[DEPRECATED\] any other arguments passed to this function generate a warning; this argument will be removed in the future |

## Details

Case-insensitive matching uses a simple, single-code point case mapping (via ICU\'s `u_toupper()` function). Full case mappings should be used whenever possible because they produce better results by working on whole strings. They also take into account the string context and the language, see [stringi-search-coll](https://stringi.gagolewski.com/rapi/stringi-search-coll.html).

Searching for overlapping pattern matches is available in [`stri_extract_all_fixed`](https://stringi.gagolewski.com/rapi/stri_extract_all_fixed.html), [`stri_locate_all_fixed`](https://stringi.gagolewski.com/rapi/stri_locate_all_fixed.html), and [`stri_count_fixed`](https://stringi.gagolewski.com/rapi/stri_count_fixed.html) functions.

## Value

Returns a named list object.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*C/POSIX Migration* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/icu/posix.html>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other search\_fixed: [`about_search_fixed`](https://stringi.gagolewski.com/rapi/about_search_fixed.html), [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html)

## Examples




```r
stri_detect_fixed('ala', 'ALA') # case-sensitive by default
## [1] FALSE
stri_detect_fixed('ala', 'ALA', opts_fixed=stri_opts_fixed(case_insensitive=TRUE))
## [1] TRUE
stri_detect_fixed('ala', 'ALA', case_insensitive=TRUE) # equivalent
## [1] TRUE
```
