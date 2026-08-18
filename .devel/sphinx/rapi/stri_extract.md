# stri_extract: Extract Pattern Occurrences

## Description

These functions extract all substrings matching a given pattern.

`stri_extract_all_*` extracts all the matches. `stri_extract_first_*` and `stri_extract_last_*` yield the first or the last matches, respectively.

## Usage

``` r
stri_extract_all(str, ..., regex, fixed, coll, charclass)

stri_extract_first(str, ..., regex, fixed, coll, charclass)

stri_extract_last(str, ..., regex, fixed, coll, charclass)

stri_extract(
  str,
  ...,
  regex,
  fixed,
  coll,
  charclass,
  mode = c("first", "all", "last")
)

stri_extract_all_charclass(
  str,
  pattern,
  merge = TRUE,
  simplify = FALSE,
  omit_no_match = FALSE
)

stri_extract_first_charclass(str, pattern)

stri_extract_last_charclass(str, pattern)

stri_extract_all_coll(
  str,
  pattern,
  simplify = FALSE,
  omit_no_match = FALSE,
  ...,
  opts_collator = NULL
)

stri_extract_first_coll(str, pattern, ..., opts_collator = NULL)

stri_extract_last_coll(str, pattern, ..., opts_collator = NULL)

stri_extract_all_regex(
  str,
  pattern,
  simplify = FALSE,
  omit_no_match = FALSE,
  ...,
  opts_regex = NULL
)

stri_extract_first_regex(str, pattern, ..., opts_regex = NULL)

stri_extract_last_regex(str, pattern, ..., opts_regex = NULL)

stri_extract_all_fixed(
  str,
  pattern,
  simplify = FALSE,
  omit_no_match = FALSE,
  ...,
  opts_fixed = NULL
)

stri_extract_first_fixed(str, pattern, ..., opts_fixed = NULL)

stri_extract_last_fixed(str, pattern, ..., opts_fixed = NULL)
```

## Arguments

|  |  |
|----|----|
| `str` | character vector; strings to search in |
| `...` | supplementary arguments passed to the underlying functions, including additional settings for `opts_collator`, `opts_regex`, and so on |
| `mode` | single string; one of: `'first'` (the default), `'all'`, `'last'` |
| `pattern`, `regex`, `fixed`, `coll`, `charclass` | character vector; search patterns; for more details refer to [stringi-search](about_search.md) |
| `merge` | single logical value; indicates whether consecutive pattern matches will be merged into one string; `stri_extract_all_charclass` only |
| `simplify` | single logical value; if `TRUE` or `NA`, then a character matrix is returned; otherwise (the default), a list of character vectors is given, see Value; `stri_extract_all_*` only |
| `omit_no_match` | single logical value; if `FALSE`, then a missing value will indicate that there was no match; `stri_extract_all_*` only |
| `opts_collator`, `opts_fixed`, `opts_regex` | a named list to tune up the search engine\'s settings; see [`stri_opts_collator`](stri_opts_collator.md), [`stri_opts_fixed`](stri_opts_fixed.md), and [`stri_opts_regex`](stri_opts_regex.md), respectively; `NULL` for the defaults |

## Details

Vectorized over `str` and `pattern` (with recycling of the elements in the shorter vector if necessary). This allows to, for instance, search for one pattern in each given string, search for each pattern in one given string, and search for the i-th pattern within the i-th string.

Check out [`stri_match`](stri_match.md) for the extraction of matches to individual regex capture groups.

`stri_extract`, `stri_extract_all`, `stri_extract_first`, and `stri_extract_last` are convenience functions. They merely call `stri_extract_*_*`, depending on the arguments used.

## Value

For `stri_extract_all*`, if `simplify=FALSE` (the default), then a list of character vectors is returned. Each list element represents the results of a different search scenario. If a pattern is not found and `omit_no_match=FALSE`, then a character vector of length 1 with single `NA` value will be generated.

Otherwise, i.e., if `simplify` is not `FALSE`, then [`stri_list2matrix`](stri_list2matrix.md) with `byrow=TRUE` argument is called on the resulting object. In such a case, the function yields a character matrix with an appropriate number of rows (according to the length of `str`, `pattern`, etc.). Note that [`stri_list2matrix`](stri_list2matrix.md)\'s `fill` argument is set either to an empty string or `NA`, depending on whether `simplify` is `TRUE` or `NA`, respectively.

`stri_extract_first*` and `stri_extract_last*` return a character vector. A `NA` element indicates a no-match.

Note that `stri_extract_last_regex` searches from start to end, but skips overlapping matches, see the example below.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other search_extract: [`about_search`](about_search.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_match_all()`](stri_match.md)

## Examples




``` r
stri_extract_all('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
```

```
## [[1]]
## [1] "a" "a" "a" "a"
## 
## [[2]]
## [1] "aaaa"
## 
## [[3]]
## [1] "aaa"
## 
## [[4]]
## [1] "aa" "aa"
```

``` r
stri_extract_all('Bartolini', coll='i')
```

```
## [[1]]
## [1] "i" "i"
```

``` r
stri_extract_all('stringi is so good!', charclass='\\p{Zs}') # all white-spaces
```

```
## [[1]]
## [1] " " " " " "
```

``` r
stri_extract_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}')
```

```
## [[1]]
## [1] "bcde" "g"    "ij"  
## 
## [[2]]
## [1] "abc"
## 
## [[3]]
## [1] NA
```

``` r
stri_extract_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}', merge=FALSE)
```

```
## [[1]]
## [1] "b" "c" "d" "e" "g" "i" "j"
## 
## [[2]]
## [1] "a" "b" "c"
## 
## [[3]]
## [1] NA
```

``` r
stri_extract_first_charclass('AaBbCc', '\\p{Ll}')
```

```
## [1] "a"
```

``` r
stri_extract_last_charclass('AaBbCc', '\\p{Ll}')
```

```
## [1] "c"
```

``` r
## Not run: 
# emoji support available since ICU 57
stri_extract_all_charclass(stri_enc_fromutf32(32:55200), '\\p{EMOJI}')
```

```
## [[1]]
##  [1] "#"                        "*"                       
##  [3] "0123456789"               "©"                       
##  [5] "®"                        "‼"                       
##  [7] "⁉"                        "™"                       
##  [9] "ℹ"                        "↔↕↖↗↘↙"                  
## [11] "↩↪"                       "⌚⌛"                    
## [13] "⌨"                        "⏏"                       
## [15] "⏩⏪⏫⏬⏭⏮⏯⏰⏱⏲⏳"        "⏸⏹⏺"                     
## [17] "Ⓜ"                        "▪▫"                      
## [19] "▶"                        "◀"                       
## [21] "◻◼◽◾"                   "☀☁☂☃☄"                   
## [23] "☎"                        "☑"                       
## [25] "☔☕"                     "☘"                       
## [27] "☝"                        "☠"                       
## [29] "☢☣"                       "☦"                       
## [31] "☪"                        "☮☯"                      
## [33] "☸☹☺"                      "♀"                       
## [35] "♂"                        "♈♉♊♋♌♍♎♏♐♑♒♓"
## [37] "♟♠"                       "♣"                       
## [39] "♥♦"                       "♨"                       
## [41] "♻"                        "♾♿"                     
## [43] "⚒⚓⚔⚕⚖⚗"                  "⚙"                       
## [45] "⚛⚜"                       "⚠⚡"                     
## [47] "⚧"                        "⚪⚫"                    
## [49] "⚰⚱"                       "⚽⚾"                    
## [51] "⛄⛅"                     "⛈"                       
## [53] "⛎⛏"                      "⛑"                       
## [55] "⛓⛔"                      "⛩⛪"                     
## [57] "⛰⛱⛲⛳⛴⛵"                "⛷⛸⛹⛺"                   
## [59] "⛽"                       "✂"                       
## [61] "✅"                       "✈✉✊✋✌✍"                
## [63] "✏"                        "✒"                       
## [65] "✔"                        "✖"                       
## [67] "✝"                        "✡"                       
## [69] "✨"                       "✳✴"                      
## [71] "❄"                        "❇"                       
## [73] "❌"                       "❎"                      
## [75] "❓❔❕"                   "❗"                      
## [77] "❣❤"                       "➕➖➗"                  
## [79] "➡"                        "➰"                      
## [81] "➿"                       "⤴⤵"                      
## [83] "⬅⬆⬇"                      "⬛⬜"                    
## [85] "⭐"                       "⭕"                      
## [87] "〰"                       "〽"                      
## [89] "㊗"                       "㊙"
```

``` r
## End(Not run)

stri_extract_all_coll(c('AaaaaaaA', 'AAAA'), 'a')
```

```
## [[1]]
## [1] "a" "a" "a" "a" "a" "a"
## 
## [[2]]
## [1] NA
```

``` r
stri_extract_first_coll(c('Yy\u00FD', 'AAA'), 'y', strength=2, locale='sk_SK')
```

```
## [1] "Y" NA
```

``` r
stri_extract_last_coll(c('Yy\u00FD', 'AAA'), 'y',  strength=1, locale='sk_SK')
```

```
## [1] "ý" NA
```

``` r
stri_extract_all_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
```

```
## [[1]]
## [1] "a" "a" "a" "a"
## 
## [[2]]
## [1] "aaaa"
## 
## [[3]]
## [1] "aaa"
## 
## [[4]]
## [1] "aa" "aa"
```

``` r
stri_extract_first_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
```

```
## [1] "a"    "aaaa" "aaa"  "aa"
```

``` r
stri_extract_last_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
```

```
## [1] "a"    "aaaa" "aaa"  "aa"
```

``` r
stri_list2matrix(stri_extract_all_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+')))
```

```
##      [,1] [,2]  
## [1,] "a"  "aaaa"
## [2,] "a"  NA    
## [3,] "a"  NA    
## [4,] "a"  NA
```

``` r
stri_extract_all_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+'), simplify=TRUE)
```

```
##      [,1]   [,2] [,3] [,4]
## [1,] "a"    "a"  "a"  "a" 
## [2,] "aaaa" ""   ""   ""
```

``` r
stri_extract_all_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+'), simplify=NA)
```

```
##      [,1]   [,2] [,3] [,4]
## [1,] "a"    "a"  "a"  "a" 
## [2,] "aaaa" NA   NA   NA
```

``` r
stri_extract_all_fixed('abaBAba', 'Aba', case_insensitive=TRUE)
```

```
## [[1]]
## [1] "aba" "Aba"
```

``` r
stri_extract_all_fixed('abaBAba', 'Aba', case_insensitive=TRUE, overlap=TRUE)
```

```
## [[1]]
## [1] "aba" "aBA" "Aba"
```

``` r
# Searching for the last occurrence:
# Note the difference - regex searches left to right, with no overlaps.
stri_extract_last_fixed("agAGA", "aga", case_insensitive=TRUE)
```

```
## [1] "AGA"
```

``` r
stri_extract_last_regex("agAGA", "aga", case_insensitive=TRUE)
```

```
## [1] "agA"
```
