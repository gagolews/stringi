# stri\_trim: Trim Characters from the Left and/or Right Side of a String

## Description

These functions may be used, e.g., to remove unnecessary white-spaces from strings. Trimming ends at the first or starts at the last `pattern` match.

## Usage

```r
stri_trim_both(str, pattern = "\\P{Wspace}")

stri_trim_left(str, pattern = "\\P{Wspace}")

stri_trim_right(str, pattern = "\\P{Wspace}")

stri_trim(str, side = c("both", "left", "right"), pattern = "\\P{Wspace}")
```

## Arguments

|           |                                                                                                                                                                  |
|-----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`     | a character vector of strings to be trimmed                                                                                                                      |
| `pattern` | a single pattern, specifying character classes that should be preserved (see [stringi-search-charclass](about_search_charclass.md)). Defaults to \'`\P{Wspace}`. |
| `side`    | character \[`stri_trim` only\]; defaults to `'both'`                                                                                                             |

## Details

Vectorized over `str` and `pattern`.

`stri_trim` is a convenience wrapper over `stri_trim_left` and `stri_trim_right`.

Contrary to many other string processing libraries, our trimming functions are universal. A character class, given by `pattern`, may be adjusted to suit your needs (yet, most often you stick to the default value).

For replacing pattern matches with arbitrary replacement string, see [`stri_replace`](stri_replace.md).

Trimming can also be used where you would normally rely on regular expressions. For instance, you may get `'23.5'` out of `'total of 23.5 bitcoins'`.

For trimming white-spaces, please note the difference between Unicode binary property \'`\p{Wspace}`\' (more universal) and general character category \'`\p{Z}`\', see [stringi-search-charclass](about_search_charclass.md).

## Value

All these functions return a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other search\_replace: [`about_search`](about_search.md), `stri_replace_all()`

Other search\_charclass: [`about_search_charclass`](about_search_charclass.md), [`about_search`](about_search.md)

## Examples




```r
stri_trim_left('               aaa')
## [1] "aaa"
stri_trim_right('r-project.org/', '\\p{P}')
## [1] "r-project.org/"
stri_trim_both(' Total of 23.5 bitcoins. ', '\\p{N}')
## [1] "23.5"
stri_trim_both(' Total of 23.5 bitcoins. ', '\\p{L}')
## [1] "Total of 23.5 bitcoins"
```
