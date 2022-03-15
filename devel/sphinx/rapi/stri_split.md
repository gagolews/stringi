# stri_split: Split a String By Pattern Matches

## Description

These functions split each element in `str` into substrings. `pattern` defines the delimiters that separate the inputs into tokens. The input data between the matches become the fields themselves.

## Usage

``` r
stri_split(str, ..., regex, fixed, coll, charclass)

stri_split_fixed(
  str,
  pattern,
  n = -1L,
  omit_empty = FALSE,
  tokens_only = FALSE,
  simplify = FALSE,
  ...,
  opts_fixed = NULL
)

stri_split_regex(
  str,
  pattern,
  n = -1L,
  omit_empty = FALSE,
  tokens_only = FALSE,
  simplify = FALSE,
  ...,
  opts_regex = NULL
)

stri_split_coll(
  str,
  pattern,
  n = -1L,
  omit_empty = FALSE,
  tokens_only = FALSE,
  simplify = FALSE,
  ...,
  opts_collator = NULL
)

stri_split_charclass(
  str,
  pattern,
  n = -1L,
  omit_empty = FALSE,
  tokens_only = FALSE,
  simplify = FALSE
)
```

## Arguments

|                                          |                                                                                                                                                                                                                                            |
|------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`                                    | character vector; strings to search in                                                                                                                                                                                                     |
| `...`                                    | supplementary arguments passed to the underlying functions, including additional settings for `opts_collator`, `opts_regex`, `opts_fixed`, and so on                                                                                       |
| `pattern, regex, fixed, coll, charclass` | character vector; search patterns; for more details refer to [stringi-search](about_search.md)                                                                                                                                             |
| `n`                                      | integer vector, maximal number of strings to return, and, at the same time, maximal number of text boundaries to look for                                                                                                                  |
| `omit_empty`                             | logical vector; determines whether empty tokens should be removed from the result (`TRUE` or `FALSE`) or replaced with `NA`s (`NA`)                                                                                                        |
| `tokens_only`                            | single logical value; may affect the result if `n` is positive, see Details                                                                                                                                                                |
| `simplify`                               | single logical value; if `TRUE` or `NA`, then a character matrix is returned; otherwise (the default), a list of character vectors is given, see Value                                                                                     |
| `opts_collator, opts_fixed, opts_regex`  | a named list used to tune up the search engine\'s settings; see [`stri_opts_collator`](stri_opts_collator.md), [`stri_opts_fixed`](stri_opts_fixed.md), and [`stri_opts_regex`](stri_opts_regex.md), respectively; `NULL` for the defaults |

## Details

Vectorized over `str`, `pattern`, `n`, and `omit_empty` (with recycling of the elements in the shorter vector if necessary).

If `n` is negative, then all pieces are extracted. Otherwise, if `tokens_only` is `FALSE` (which is the default), then `n-1` tokens are extracted (if possible) and the `n`-th string gives the remainder (see Examples). On the other hand, if `tokens_only` is `TRUE`, then only full tokens (up to `n` pieces) are extracted.

`omit_empty` is applied during the split process: if it is set to `TRUE`, then tokens of zero length are ignored. Thus, empty strings will never appear in the resulting vector. On the other hand, if `omit_empty` is `NA`, then empty tokens are substituted with missing strings.

Empty search patterns are not supported. If you wish to split a string into individual characters, use, e.g., [`stri_split_boundaries(str, type='character')`](stri_split_boundaries.md) for THE Unicode way.

`stri_split` is a convenience function. It calls either `stri_split_regex`, `stri_split_fixed`, `stri_split_coll`, or `stri_split_charclass`, depending on the argument used.

## Value

If `simplify=FALSE` (the default), then the functions return a list of character vectors.

Otherwise, [`stri_list2matrix`](stri_list2matrix.md) with `byrow=TRUE` and `n_min=n` arguments is called on the resulting object. In such a case, a character matrix with an appropriate number of rows (according to the length of `str`, `pattern`, etc.) is returned. Note that [`stri_list2matrix`](stri_list2matrix.md)\'s `fill` argument is set to an empty string and `NA`, for `simplify` equal to `TRUE` and `NA`, respectively.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other search_split: [`about_search`](about_search.md), [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_split_lines()`](stri_split_lines.md)

## Examples




```r
stri_split_fixed('a_b_c_d', '_')
## [[1]]
## [1] "a" "b" "c" "d"
stri_split_fixed('a_b_c__d', '_')
## [[1]]
## [1] "a" "b" "c" ""  "d"
stri_split_fixed('a_b_c__d', '_', omit_empty=TRUE)
## [[1]]
## [1] "a" "b" "c" "d"
stri_split_fixed('a_b_c__d', '_', n=2, tokens_only=FALSE) # 'a' & remainder
## [[1]]
## [1] "a"      "b_c__d"
stri_split_fixed('a_b_c__d', '_', n=2, tokens_only=TRUE) # 'a' & 'b' only
## [[1]]
## [1] "a" "b"
stri_split_fixed('a_b_c__d', '_', n=4, omit_empty=TRUE, tokens_only=TRUE)
## [[1]]
## [1] "a" "b" "c" "d"
stri_split_fixed('a_b_c__d', '_', n=4, omit_empty=FALSE, tokens_only=TRUE)
## [[1]]
## [1] "a" "b" "c" ""
stri_split_fixed('a_b_c__d', '_', omit_empty=NA)
## [[1]]
## [1] "a" "b" "c" NA  "d"
stri_split_fixed(c('ab_c', 'd_ef_g', 'h', ''), '_', n=1, tokens_only=TRUE, omit_empty=TRUE)
## [[1]]
## [1] "ab"
## 
## [[2]]
## [1] "d"
## 
## [[3]]
## [1] "h"
## 
## [[4]]
## character(0)
stri_split_fixed(c('ab_c', 'd_ef_g', 'h', ''), '_', n=2, tokens_only=TRUE, omit_empty=TRUE)
## [[1]]
## [1] "ab" "c" 
## 
## [[2]]
## [1] "d"  "ef"
## 
## [[3]]
## [1] "h"
## 
## [[4]]
## character(0)
stri_split_fixed(c('ab_c', 'd_ef_g', 'h', ''), '_', n=3, tokens_only=TRUE, omit_empty=TRUE)
## [[1]]
## [1] "ab" "c" 
## 
## [[2]]
## [1] "d"  "ef" "g" 
## 
## [[3]]
## [1] "h"
## 
## [[4]]
## character(0)
stri_list2matrix(stri_split_fixed(c('ab,c', 'd,ef,g', ',h', ''), ',', omit_empty=TRUE))
##      [,1] [,2] [,3] [,4]
## [1,] "ab" "d"  "h"  NA  
## [2,] "c"  "ef" NA   NA  
## [3,] NA   "g"  NA   NA
stri_split_fixed(c('ab,c', 'd,ef,g', ',h', ''), ',', omit_empty=FALSE, simplify=TRUE)
##      [,1] [,2] [,3]
## [1,] "ab" "c"  ""  
## [2,] "d"  "ef" "g" 
## [3,] ""   "h"  ""  
## [4,] ""   ""   ""
stri_split_fixed(c('ab,c', 'd,ef,g', ',h', ''), ',', omit_empty=NA, simplify=TRUE)
##      [,1] [,2] [,3]
## [1,] "ab" "c"  ""  
## [2,] "d"  "ef" "g" 
## [3,] NA   "h"  ""  
## [4,] NA   ""   ""
stri_split_fixed(c('ab,c', 'd,ef,g', ',h', ''), ',', omit_empty=TRUE, simplify=TRUE)
##      [,1] [,2] [,3]
## [1,] "ab" "c"  ""  
## [2,] "d"  "ef" "g" 
## [3,] "h"  ""   ""  
## [4,] ""   ""   ""
stri_split_fixed(c('ab,c', 'd,ef,g', ',h', ''), ',', omit_empty=NA, simplify=NA)
##      [,1] [,2] [,3]
## [1,] "ab" "c"  NA  
## [2,] "d"  "ef" "g" 
## [3,] NA   "h"  NA  
## [4,] NA   NA   NA
stri_split_regex(c('ab,c', 'd,ef  ,  g', ',  h', ''),
   '\\p{WHITE_SPACE}*,\\p{WHITE_SPACE}*', omit_empty=NA, simplify=TRUE)
##      [,1] [,2] [,3]
## [1,] "ab" "c"  ""  
## [2,] "d"  "ef" "g" 
## [3,] NA   "h"  ""  
## [4,] NA   ""   ""
stri_split_charclass('Lorem ipsum dolor sit amet', '\\p{WHITE_SPACE}')
## [[1]]
## [1] "Lorem" "ipsum" "dolor" "sit"   "amet"
stri_split_charclass(' Lorem  ipsum dolor', '\\p{WHITE_SPACE}', n=3,
   omit_empty=c(FALSE, TRUE))
## [[1]]
## [1] ""             "Lorem"        " ipsum dolor"
## 
## [[2]]
## [1] "Lorem" "ipsum" "dolor"
stri_split_regex('Lorem ipsum dolor sit amet',
   '\\p{Z}+') # see also stri_split_charclass
## [[1]]
## [1] "Lorem" "ipsum" "dolor" "sit"   "amet"
```
