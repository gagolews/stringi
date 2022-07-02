# stri_count: Count the Number of Pattern Occurrences

## Description

These functions count the number of occurrences of a pattern in a string.

## Usage

``` r
stri_count(str, ..., regex, fixed, coll, charclass)

stri_count_charclass(str, pattern)

stri_count_coll(str, pattern, ..., opts_collator = NULL)

stri_count_fixed(str, pattern, ..., opts_fixed = NULL)

stri_count_regex(str, pattern, ..., opts_regex = NULL)
```

## Arguments

|                                          |                                                                                                                                                                                                                                            |
|------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`                                    | character vector; strings to search in                                                                                                                                                                                                     |
| `...`                                    | supplementary arguments passed to the underlying functions, including additional settings for `opts_collator`, `opts_regex`, `opts_fixed`, and so on                                                                                       |
| `pattern, regex, fixed, coll, charclass` | character vector; search patterns; for more details refer to [stringi-search](about_search.md)                                                                                                                                             |
| `opts_collator, opts_fixed, opts_regex`  | a named list used to tune up the search engine\'s settings; see [`stri_opts_collator`](stri_opts_collator.md), [`stri_opts_fixed`](stri_opts_fixed.md), and [`stri_opts_regex`](stri_opts_regex.md), respectively; `NULL` for the defaults |

## Details

Vectorized over `str` and `pattern` (with recycling of the elements in the shorter vector if necessary). This allows to, for instance, search for one pattern in each given string, search for each pattern in one given string, and search for the i-th pattern within the i-th string.

If `pattern` is empty, then the result is `NA` and a warning is generated.

`stri_count` is a convenience function. It calls either `stri_count_regex`, `stri_count_fixed`, `stri_count_coll`, or `stri_count_charclass`, depending on the argument used.

## Value

All the functions return an integer vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi:<https://dx.doi.org/10.18637/jss.v103.i02>

Other search_count: [`about_search`](about_search.md), [`stri_count_boundaries()`](stri_count_boundaries.md)

## Examples




```r
s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
stri_count(s, fixed='dolor')
## [1] 1
stri_count(s, regex='\\p{L}+')
## [1] 8
stri_count_fixed(s, ' ')
## [1] 7
stri_count_fixed(s, 'o')
## [1] 4
stri_count_fixed(s, 'it')
## [1] 2
stri_count_fixed(s, letters)
##  [1] 2 0 3 2 5 0 1 0 7 0 0 2 3 2 4 2 0 3 4 5 2 0 0 0 0 0
stri_count_fixed('babab', 'b')
## [1] 3
stri_count_fixed(c('stringi', '123'), 'string')
## [1] 1 0
stri_count_charclass(c('stRRRingi', 'STrrrINGI', '123'),
   c('\\p{Ll}', '\\p{Lu}', '\\p{Zs}'))
## [1] 6 6 0
stri_count_charclass(' \t\n', '\\p{WHITE_SPACE}') # white space - binary property
## [1] 3
stri_count_charclass(' \t\n', '\\p{Z}') # white-space - general category (note the difference)
## [1] 1
stri_count_regex(s, '(s|el)it')
## [1] 2
stri_count_regex(s, 'i.i')
## [1] 2
stri_count_regex(s, '.it')
## [1] 2
stri_count_regex('bab baab baaab', c('b.*?b', 'b.b'))
## [1] 3 2
stri_count_regex(c('stringi', '123'), '^(s|1)')
## [1] 1 1
```
