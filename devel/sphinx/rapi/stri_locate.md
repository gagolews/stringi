# stri_locate: Locate Pattern Occurrences

## Description

These functions find the indexes (positions) where there is a match to some pattern. The functions `stri_locate_all_*` locate all the matches. `stri_locate_first_*` and `stri_locate_last_*` give the first and the last matches, respectively.

## Usage

``` r
stri_locate_all(str, ..., regex, fixed, coll, charclass)

stri_locate_first(str, ..., regex, fixed, coll, charclass)

stri_locate_last(str, ..., regex, fixed, coll, charclass)

stri_locate(
  str,
  ...,
  regex,
  fixed,
  coll,
  charclass,
  mode = c("first", "all", "last")
)

stri_locate_all_charclass(
  str,
  pattern,
  merge = TRUE,
  omit_no_match = FALSE,
  get_length = FALSE
)

stri_locate_first_charclass(str, pattern, get_length = FALSE)

stri_locate_last_charclass(str, pattern, get_length = FALSE)

stri_locate_all_coll(
  str,
  pattern,
  omit_no_match = FALSE,
  get_length = FALSE,
  ...,
  opts_collator = NULL
)

stri_locate_first_coll(
  str,
  pattern,
  get_length = FALSE,
  ...,
  opts_collator = NULL
)

stri_locate_last_coll(
  str,
  pattern,
  get_length = FALSE,
  ...,
  opts_collator = NULL
)

stri_locate_all_regex(
  str,
  pattern,
  omit_no_match = FALSE,
  capture_groups = FALSE,
  get_length = FALSE,
  ...,
  opts_regex = NULL
)

stri_locate_first_regex(
  str,
  pattern,
  capture_groups = FALSE,
  get_length = FALSE,
  ...,
  opts_regex = NULL
)

stri_locate_last_regex(
  str,
  pattern,
  capture_groups = FALSE,
  get_length = FALSE,
  ...,
  opts_regex = NULL
)

stri_locate_all_fixed(
  str,
  pattern,
  omit_no_match = FALSE,
  get_length = FALSE,
  ...,
  opts_fixed = NULL
)

stri_locate_first_fixed(
  str,
  pattern,
  get_length = FALSE,
  ...,
  opts_fixed = NULL
)

stri_locate_last_fixed(
  str,
  pattern,
  get_length = FALSE,
  ...,
  opts_fixed = NULL
)
```

## Arguments

|                                          |                                                                                                                                                                                                                                                   |
|------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`                                    | character vector; strings to search in                                                                                                                                                                                                            |
| `...`                                    | supplementary arguments passed to the underlying functions, including additional settings for `opts_collator`, `opts_regex`, `opts_fixed`, and so on                                                                                              |
| `mode`                                   | single string; one of: `'first'` (the default), `'all'`, `'last'`                                                                                                                                                                                 |
| `pattern, regex, fixed, coll, charclass` | character vector; search patterns; for more details refer to [stringi-search](about_search.md)                                                                                                                                                    |
| `merge`                                  | single logical value; indicates whether consecutive sequences of indexes in the resulting matrix should be merged; `stri_locate_all_charclass` only                                                                                               |
| `omit_no_match`                          | single logical value; if `TRUE`, a no-match will be indicated by a matrix with 0 rows `stri_locate_all_*` only                                                                                                                                    |
| `get_length`                             | single logical value; if `FALSE` (default), generate *from-to* matrices; otherwise, output *from-length* ones                                                                                                                                     |
| `opts_collator, opts_fixed, opts_regex`  | named list used to tune up the selected search engine\'s settings; see [`stri_opts_collator`](stri_opts_collator.md), [`stri_opts_fixed`](stri_opts_fixed.md), and [`stri_opts_regex`](stri_opts_regex.md), respectively; `NULL` for the defaults |
| `capture_groups`                         | single logical value; whether positions of matches to parenthesized subexpressions should be returned too (as `capture_groups` attribute); `stri_locate_*_regex` only                                                                             |

## Details

Vectorized over `str` and `pattern` (with recycling of the elements in the shorter vector if necessary). This allows to, for instance, search for one pattern in each string, search for each pattern in one string, and search for the i-th pattern within the i-th string.

The matches may be extracted by calling [`stri_sub`](stri_sub.md) or [`stri_sub_all`](stri_sub_all.md). Alternatively, you may call [`stri_extract`](stri_extract.md) directly.

`stri_locate`, `stri_locate_all`, `stri_locate_first`, and `stri_locate_last` are convenience functions. They just call `stri_locate_*_*`, depending on the arguments used.

## Value

For `stri_locate_all_*`, a list of integer matrices is returned. Each list element represents the results of a separate search scenario. The first column gives the start positions of the matches, and the second column gives the end positions. Moreover, two `NA`s in a row denote `NA` arguments or a no-match (the latter only if `omit_no_match` is `FALSE`).

`stri_locate_first_*` and `stri_locate_last_*` return an integer matrix with two columns, giving the start and end positions of the first or the last matches, respectively, and two `NA`s if and only if they are not found.

For `stri_locate_*_regex`, if the match is of zero length, `end` will be one character less than `start`. Note that `stri_locate_last_regex` searches from start to end, but skips overlapping matches, see the example below.

Setting `get_length=TRUE` results in the 2nd column representing the length of the match instead of the end position. In this case, negative length denotes a no-match.

If `capture_groups=TRUE`, then the outputs are equipped with the `capture_groups` attribute, which is a list of matrices giving the start-end positions of matches to parenthesized subexpressions. Similarly to `stri_match_regex`, capture group names are extracted unless looking for first/last occurrences of many different patterns.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi:<https://dx.doi.org/10.18637/jss.v103.i02>

Other search_locate: [`about_search`](about_search.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md)

Other indexing: [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_sub_all()`](stri_sub_all.md), [`stri_sub()`](stri_sub.md)

## Examples




```r
stri_locate_all('stringi', fixed='i')
## [[1]]
##      start end
## [1,]     4   4
## [2,]     7   7
stri_locate_first_coll('hladn\u00FD', 'HLADNY', strength=1, locale='sk_SK')
##      start end
## [1,]     1   6
stri_locate_all_regex(
    c('breakfast=eggs;lunch=pizza', 'breakfast=spam', 'no food here'),
   '(?<when>\\w+)=(?<what>\\w+)',
   capture_groups=TRUE
)  # named capture groups
## [[1]]
##      start end
## [1,]     1  14
## [2,]    16  26
## attr(,"capture_groups")
## attr(,"capture_groups")$when
##      start end
## [1,]     1   9
## [2,]    16  20
## 
## attr(,"capture_groups")$what
##      start end
## [1,]    11  14
## [2,]    22  26
## 
## 
## [[2]]
##      start end
## [1,]     1  14
## attr(,"capture_groups")
## attr(,"capture_groups")$when
##      start end
## [1,]     1   9
## 
## attr(,"capture_groups")$what
##      start end
## [1,]    11  14
## 
## 
## [[3]]
##      start end
## [1,]    NA  NA
## attr(,"capture_groups")
## attr(,"capture_groups")$when
##      start end
## [1,]    NA  NA
## 
## attr(,"capture_groups")$what
##      start end
## [1,]    NA  NA
stri_locate_all_fixed("abababa", "ABA", case_insensitive=TRUE, overlap=TRUE)
## [[1]]
##      start end
## [1,]     1   3
## [2,]     3   5
## [3,]     5   7
stri_locate_first_fixed("ababa", "aba")
##      start end
## [1,]     1   3
stri_locate_last_fixed("ababa", "aba")  # starts from end
##      start end
## [1,]     3   5
stri_locate_last_regex("ababa", "aba")  # no overlaps, from left to right
##      start end
## [1,]     1   3
x <- c("yes yes", "no", NA)
stri_locate_all_fixed(x, "yes")
## [[1]]
##      start end
## [1,]     1   3
## [2,]     5   7
## 
## [[2]]
##      start end
## [1,]    NA  NA
## 
## [[3]]
##      start end
## [1,]    NA  NA
stri_locate_all_fixed(x, "yes", omit_no_match=TRUE)
## [[1]]
##      start end
## [1,]     1   3
## [2,]     5   7
## 
## [[2]]
##      start end
## 
## [[3]]
##      start end
## [1,]    NA  NA
stri_locate_all_fixed(x, "yes", get_length=TRUE)
## [[1]]
##      start length
## [1,]     1      3
## [2,]     5      3
## 
## [[2]]
##      start length
## [1,]    -1     -1
## 
## [[3]]
##      start length
## [1,]    NA     NA
stri_locate_all_fixed(x, "yes", get_length=TRUE, omit_no_match=TRUE)
## [[1]]
##      start length
## [1,]     1      3
## [2,]     5      3
## 
## [[2]]
##      start length
## 
## [[3]]
##      start length
## [1,]    NA     NA
stri_locate_first_fixed(x, "yes")
##      start end
## [1,]     1   3
## [2,]    NA  NA
## [3,]    NA  NA
stri_locate_first_fixed(x, "yes", get_length=TRUE)
##      start length
## [1,]     1      3
## [2,]    -1     -1
## [3,]    NA     NA
# Use regex positive-lookahead to locate overlapping pattern matches:
stri_locate_all_regex('ACAGAGACTTTAGATAGAGAAGA', '(?=AGA)')
## [[1]]
##      start end
## [1,]     3   2
## [2,]     5   4
## [3,]    12  11
## [4,]    16  15
## [5,]    18  17
## [6,]    21  20
# note that start > end here (match of length zero)
```
