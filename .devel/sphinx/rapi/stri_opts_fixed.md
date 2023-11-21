# stri_opts_fixed: Generate a List with Fixed Pattern Search Engine\'s Settings

## Description

A convenience function used to tune up the behavior of `stri_*_fixed` functions, see [stringi-search-fixed](about_search_fixed.md).

## Usage

``` r
stri_opts_fixed(case_insensitive = FALSE, overlap = FALSE)
```

## Arguments

|                    |                                                  |
|--------------------|--------------------------------------------------|
| `case_insensitive` | logical; enable simple case insensitive matching |
| `overlap`          | logical; enable overlapping matches\' detection  |

## Details

Case-insensitive matching uses a simple, single-code point case mapping (via ICU\'s `u_toupper()` function). Full case mappings should be used whenever possible because they produce better results by working on whole strings. They also take into account the string context and the language, see [stringi-search-coll](about_search_coll.md).

Searching for overlapping pattern matches is available in [`stri_extract_all_fixed`](stri_extract.md), [`stri_locate_all_fixed`](stri_locate.md), and [`stri_count_fixed`](stri_count.md) functions.

## Value

Returns a named list object.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*C/POSIX Migration* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/icu/posix.html>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other search_fixed: [`about_search_fixed`](about_search_fixed.md), [`about_search`](about_search.md)

## Examples




```r
stri_detect_fixed('ala', 'ALA') # case-sensitive by default
```

```
## [1] FALSE
```

```r
stri_detect_fixed('ala', 'ALA', opts_fixed=stri_opts_fixed(case_insensitive=TRUE))
```

```
## [1] TRUE
```

```r
stri_detect_fixed('ala', 'ALA', case_insensitive=TRUE) # equivalent
```

```
## [1] TRUE
```
