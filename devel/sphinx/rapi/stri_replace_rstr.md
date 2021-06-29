# stri\_replace\_rstr: Convert gsub-Style Replacement Strings

## Description

Converts a [`gsub`](https://stat.ethz.ch/R-manual/R-devel/library/base/help/gsub.html)-style replacement strings to those which can be used in [`stri_replace`](stri_replace.md). In particular, `$` becomes `\$` and `\1` becomes `$1`.

## Usage

```r
stri_replace_rstr(x)
```

## Arguments

|     |                  |
|-----|------------------|
| `x` | character vector |

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other search\_replace: [`about_search`](about_search.md), [`stri_replace_all()`](stri_replace.md), [`stri_trim_both()`](stri_trim.md)
