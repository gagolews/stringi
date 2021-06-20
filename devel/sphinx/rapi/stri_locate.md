# stri\_locate: Locate Occurrences of a Pattern

## Description

These functions find the indexes (positions) where there is a match to some pattern. The functions `stri_locate_all_*` locate all the matches. `stri_locate_first_*` and `stri_locate_last_*` give the first and the last matches, respectively.

## Usage

```r
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

stri_locate_all_charclass(str, pattern, merge = TRUE, omit_no_match = FALSE)

stri_locate_first_charclass(str, pattern)

stri_locate_last_charclass(str, pattern)

stri_locate_all_coll(
  str,
  pattern,
  omit_no_match = FALSE,
  ...,
  opts_collator = NULL
)

stri_locate_first_coll(str, pattern, ..., opts_collator = NULL)

stri_locate_last_coll(str, pattern, ..., opts_collator = NULL)

stri_locate_all_regex(
  str,
  pattern,
  omit_no_match = FALSE,
  capture_groups = FALSE,
  ...,
  opts_regex = NULL
)

stri_locate_first_regex(
  str,
  pattern,
  capture_groups = FALSE,
  ...,
  opts_regex = NULL
)

stri_locate_last_regex(
  str,
  pattern,
  capture_groups = FALSE,
  ...,
  opts_regex = NULL
)

stri_locate_all_fixed(
  str,
  pattern,
  omit_no_match = FALSE,
  ...,
  opts_fixed = NULL
)

stri_locate_first_fixed(str, pattern, ..., opts_fixed = NULL)

stri_locate_last_fixed(str, pattern, ..., opts_fixed = NULL)
```

## Arguments

|                                          |                                                                                                                                                                                                                                            |
|------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`                                    | character vector; strings to search in                                                                                                                                                                                                     |
| `...`                                    | supplementary arguments passed to the underlying functions, including additional settings for `opts_collator`, `opts_regex`, `opts_fixed`, and so on                                                                                       |
| `mode`                                   | single string; one of: `'first'` (the default), `'all'`, `'last'`                                                                                                                                                                          |
| `pattern, regex, fixed, coll, charclass` | character vector; search patterns; for more details refer to [stringi-search](about_search.md)                                                                                                                                             |
| `merge`                                  | single logical value; indicates whether consecutive sequences of indexes in the resulting matrix should be merged; `stri_locate_all_charclass` only                                                                                        |
| `omit_no_match`                          | single logical value; if `FALSE`, then two missing values will indicate that there was no match; `stri_locate_all_*` only                                                                                                                  |
| `opts_collator, opts_fixed, opts_regex`  | a named list used to tune up the search engine\'s settings; see [`stri_opts_collator`](stri_opts_collator.md), [`stri_opts_fixed`](stri_opts_fixed.md), and [`stri_opts_regex`](stri_opts_regex.md), respectively; `NULL` for the defaults |
| `capture_groups`                         | single logical value; whether positions of matches to parenthesized subexpressions should be returned to (as `capture_groups` attribute); `stri_locate_*_regex` only                                                                       |

## Details

Vectorized over `str` and `pattern` (with recycling of the elements in the shorter vector if necessary). This allows to, for instance, search for one pattern in each string, search for each pattern in one string, and search for the i-th pattern within the i-th string.

The matches may be extracted by calling [`stri_sub`](stri_sub.md) or [`stri_sub_all`](stri_sub_all.md). Alternatively, you may call [`stri_extract`](stri_extract.md) directly.

`stri_locate`, `stri_locate_all`, `stri_locate_first`, and `stri_locate_last` are convenience functions. They just call `stri_locate_*_*`, depending on the arguments used.

## Value

For `stri_locate_all_*`, a list of integer matrices is returned. Each list element represents the results of a separate search scenario. The first column gives the start positions of the matches, and the second column gives the end positions. Moreover, you may get two `NA`s in one row for no match (if `omit_no_match` is `FALSE`) or `NA` arguments.

`stri_locate_first_*` and `stri_locate_last_*` return an integer matrix with two columns, giving the start and end positions of the first or the last matches, respectively, and two `NA`s if and only if they are not found.

For `stri_locate_*_regex`, if the match is of zero length, `end` will be one character less than `start`. Note that `stri_locate_last_regex` searches from start to end, but skips overlapping matches, see the example below.

If `capture_groups=TRUE`, then the outputs are equipped with `capture_groups` attribute, which is a list of matrices giving the start-end positions of matches to parenthesized subexpressions. Similarly to `stri_match_regex`, capture group names are extracted unless looking for first/last occurrences of many different patterns.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other search\_locate: [`about_search`](about_search.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md)

Other indexing: [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_sub_all()`](stri_sub_all.md), [`stri_sub()`](stri_sub.md)

## Examples




```r
stri_locate_all('XaaaaX',
   regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
## [[1]]
##      start end
## [1,]     2   2
## [2,]     3   3
## [3,]     4   4
## [4,]     5   5
## 
## [[2]]
##      start end
## [1,]     2   5
## 
## [[3]]
##      start end
## [1,]     2   4
## 
## [[4]]
##      start end
## [1,]     2   3
## [2,]     4   5
stri_locate_all('stringi', fixed='i')
## [[1]]
##      start end
## [1,]     4   4
## [2,]     7   7
stri_locate_all_regex(
    c('breakfast=eggs;lunch=pizza',
   'breakfast=spam', 'no food here'),
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
stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}')
## [[1]]
##      start end
## [1,]     2   5
## [2,]     7   7
## [3,]     9  10
## 
## [[2]]
##      start end
## [1,]     1   3
## 
## [[3]]
##      start end
## [1,]    NA  NA
stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}', merge=FALSE)
## [[1]]
##      start end
## [1,]     2   2
## [2,]     3   3
## [3,]     4   4
## [4,]     5   5
## [5,]     7   7
## [6,]     9   9
## [7,]    10  10
## 
## [[2]]
##      start end
## [1,]     1   1
## [2,]     2   2
## [3,]     3   3
## 
## [[3]]
##      start end
## [1,]    NA  NA
stri_locate_first_charclass('AaBbCc', '\\p{Ll}')
##      start end
## [1,]     2   2
stri_locate_last_charclass('AaBbCc', '\\p{Ll}')
##      start end
## [1,]     6   6
stri_locate_all_coll(c('AaaaaaaA', 'AAAA'), 'a')
## [[1]]
##      start end
## [1,]     2   2
## [2,]     3   3
## [3,]     4   4
## [4,]     5   5
## [5,]     6   6
## [6,]     7   7
## 
## [[2]]
##      start end
## [1,]    NA  NA
stri_locate_first_coll(c('Yy\u00FD', 'AAA'), 'y', strength=2, locale='sk_SK')
##      start end
## [1,]     1   1
## [2,]    NA  NA
stri_locate_last_coll(c('Yy\u00FD', 'AAA'), 'y', strength=1, locale='sk_SK')
##      start end
## [1,]     3   3
## [2,]    NA  NA
pat <- stri_paste('\u0635\u0644\u0649 \u0627\u0644\u0644\u0647 ',
                  '\u0639\u0644\u064a\u0647 \u0648\u0633\u0644\u0645XYZ')
stri_locate_last_coll('\ufdfa\ufdfa\ufdfaXYZ', pat, strength=1)
##      start end
## [1,]     3   6
stri_locate_all_fixed(c('AaaaaaaA', 'AAAA'), 'a')
## [[1]]
##      start end
## [1,]     2   2
## [2,]     3   3
## [3,]     4   4
## [4,]     5   5
## [5,]     6   6
## [6,]     7   7
## 
## [[2]]
##      start end
## [1,]    NA  NA
stri_locate_all_fixed(c('AaaaaaaA', 'AAAA'), 'a', case_insensitive=TRUE, overlap=TRUE)
## [[1]]
##      start end
## [1,]     1   1
## [2,]     2   2
## [3,]     3   3
## [4,]     4   4
## [5,]     5   5
## [6,]     6   6
## [7,]     7   7
## [8,]     8   8
## 
## [[2]]
##      start end
## [1,]     1   1
## [2,]     2   2
## [3,]     3   3
## [4,]     4   4
stri_locate_first_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
##      start end
## [1,]     2   2
## [2,]     1   1
## [3,]    NA  NA
stri_locate_last_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
##      start end
## [1,]     7   7
## [2,]     3   3
## [3,]    NA  NA
#first row is 1-2 like in locate_first
stri_locate_all_fixed('bbbbb', 'bb')
## [[1]]
##      start end
## [1,]     1   2
## [2,]     3   4
stri_locate_first_fixed('bbbbb', 'bb')
##      start end
## [1,]     1   2
# but last row is 3-4, unlike in locate_last,
# keep this in mind [overlapping pattern match OK]!
stri_locate_last_fixed('bbbbb', 'bb')
##      start end
## [1,]     4   5
stri_locate_all_regex('XaaaaX',
   c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
## [[1]]
##      start end
## [1,]     2   2
## [2,]     3   3
## [3,]     4   4
## [4,]     5   5
## 
## [[2]]
##      start end
## [1,]     2   5
## 
## [[3]]
##      start end
## [1,]     2   4
## 
## [[4]]
##      start end
## [1,]     2   3
## [2,]     4   5
stri_locate_first_regex('XaaaaX',
   c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
##      start end
## [1,]     2   2
## [2,]     2   5
## [3,]     2   4
## [4,]     2   3
stri_locate_last_regex('XaaaaX',
   c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
##      start end
## [1,]     5   5
## [2,]     2   5
## [3,]     2   4
## [4,]     4   5
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
# note that start > end here (match of 0 length)

# Searching for the last occurrence:
stri_locate_last_fixed("agaga", "aga")
##      start end
## [1,]     3   5
stri_locate_last_coll("agaga", "aga")
##      start end
## [1,]     3   5
# note the difference - regex searches left to right, with no overlaps:
stri_locate_last_regex("agaga", "aga")
##      start end
## [1,]     1   3
```
