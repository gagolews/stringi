# stri_split_boundaries: Split a String at Text Boundaries

## Description

This function locates text boundaries (like character, word, line, or sentence boundaries) and splits strings at the indicated positions.

## Usage

``` r
stri_split_boundaries(
  str,
  n = -1L,
  tokens_only = FALSE,
  simplify = FALSE,
  ...,
  opts_brkiter = NULL
)
```

## Arguments

|  |  |
|----|----|
| `str` | character vector or an object coercible to |
| `n` | integer vector, maximal number of strings to return |
| `tokens_only` | single logical value; may affect the result if `n` is positive, see Details |
| `simplify` | single logical value; if `TRUE` or `NA`, then a character matrix is returned; otherwise (the default), a list of character vectors is given, see Value |
| `...` | additional settings for `opts_brkiter` |
| `opts_brkiter` | a named list with <span class="pkg">ICU</span> BreakIterator\'s settings, see [`stri_opts_brkiter`](stri_opts_brkiter.md); `NULL` for the default break iterator, i.e., `line_break` |

## Details

Vectorized over `str` and `n`.

If `n` is negative (the default), then all text pieces are extracted.

Otherwise, if `tokens_only` is `FALSE` (which is the default), then `n-1` tokens are extracted (if possible) and the `n`-th string gives the (non-split) remainder (see Examples). On the other hand, if `tokens_only` is `TRUE`, then only full tokens (up to `n` pieces) are extracted.

For more information on text boundary analysis performed by <span class="pkg">ICU</span>\'s `BreakIterator`, see [stringi-search-boundaries](about_search_boundaries.md).

## Value

If `simplify=FALSE` (the default), then the functions return a list of character vectors.

Otherwise, [`stri_list2matrix`](stri_list2matrix.md) with `byrow=TRUE` and `n_min=n` arguments is called on the resulting object. In such a case, a character matrix with `length(str)` rows is returned. Note that [`stri_list2matrix`](stri_list2matrix.md)\'s `fill` argument is set to an empty string and `NA`, for `simplify` equal to `TRUE` and `NA`, respectively.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other search_split: [`about_search`](about_search.md), [`stri_split()`](stri_split.md), [`stri_split_lines()`](stri_split_lines.md)

Other locale_sensitive: [`%s<%()`](+25s+3C+25.md), [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_coll`](about_search_coll.md), [`stri_compare()`](stri_compare.md), [`stri_count_boundaries()`](stri_count_boundaries.md), [`stri_duplicated()`](stri_duplicated.md), [`stri_enc_detect2()`](stri_enc_detect2.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_opts_collator()`](stri_opts_collator.md), [`stri_order()`](stri_order.md), [`stri_rank()`](stri_rank.md), [`stri_sort()`](stri_sort.md), [`stri_sort_key()`](stri_sort_key.md), [`stri_trans_tolower()`](stri_trans_casemap.md), [`stri_unique()`](stri_unique.md), [`stri_wrap()`](stri_wrap.md)

Other text_boundaries: [`about_search`](about_search.md), [`about_search_boundaries`](about_search_boundaries.md), [`stri_count_boundaries()`](stri_count_boundaries.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_opts_brkiter()`](stri_opts_brkiter.md), [`stri_split_lines()`](stri_split_lines.md), [`stri_trans_tolower()`](stri_trans_casemap.md), [`stri_wrap()`](stri_wrap.md)

## Examples




``` r
test <- 'The\u00a0above-mentioned    features are very useful. ' %s+%
   'Spam, spam, eggs, bacon, and spam. 123 456 789'
stri_split_boundaries(test, type='line')
```

```
## [[1]]
##  [1] "The above-"    "mentioned    " "features "     "are "         
##  [5] "very "         "useful. "      "Spam, "        "spam, "       
##  [9] "eggs, "        "bacon, "       "and "          "spam. "       
## [13] "123 "          "456 "          "789"
```

``` r
stri_split_boundaries(test, type='word')
```

```
## [[1]]
##  [1] "The"       " "         "above"     "-"         "mentioned" "    "     
##  [7] "features"  " "         "are"       " "         "very"      " "        
## [13] "useful"    "."         " "         "Spam"      ","         " "        
## [19] "spam"      ","         " "         "eggs"      ","         " "        
## [25] "bacon"     ","         " "         "and"       " "         "spam"     
## [31] "."         " "         "123"       " "         "456"       " "        
## [37] "789"
```

``` r
stri_split_boundaries(test, type='word', skip_word_none=TRUE)
```

```
## [[1]]
##  [1] "The"       "above"     "mentioned" "features"  "are"       "very"     
##  [7] "useful"    "Spam"      "spam"      "eggs"      "bacon"     "and"      
## [13] "spam"      "123"       "456"       "789"
```

``` r
stri_split_boundaries(test, type='word', skip_word_none=TRUE, skip_word_letter=TRUE)
```

```
## [[1]]
## [1] "123" "456" "789"
```

``` r
stri_split_boundaries(test, type='word', skip_word_none=TRUE, skip_word_number=TRUE)
```

```
## [[1]]
##  [1] "The"       "above"     "mentioned" "features"  "are"       "very"     
##  [7] "useful"    "Spam"      "spam"      "eggs"      "bacon"     "and"      
## [13] "spam"
```

``` r
stri_split_boundaries(test, type='sentence')
```

```
## [[1]]
## [1] "The above-mentioned    features are very useful. "
## [2] "Spam, spam, eggs, bacon, and spam. "              
## [3] "123 456 789"
```

``` r
stri_split_boundaries(test, type='sentence', skip_sentence_sep=TRUE)
```

```
## [[1]]
## [1] "The above-mentioned    features are very useful. "
## [2] "Spam, spam, eggs, bacon, and spam. "
```

``` r
stri_split_boundaries(test, type='character')
```

```
## [[1]]
##  [1] "T" "h" "e" " " "a" "b" "o" "v" "e" "-" "m" "e" "n" "t" "i" "o" "n" "e" "d"
## [20] " " " " " " " " "f" "e" "a" "t" "u" "r" "e" "s" " " "a" "r" "e" " " "v" "e"
## [39] "r" "y" " " "u" "s" "e" "f" "u" "l" "." " " "S" "p" "a" "m" "," " " "s" "p"
## [58] "a" "m" "," " " "e" "g" "g" "s" "," " " "b" "a" "c" "o" "n" "," " " "a" "n"
## [77] "d" " " "s" "p" "a" "m" "." " " "1" "2" "3" " " "4" "5" "6" " " "7" "8" "9"
```

``` r
# a filtered break iterator with the new ICU:
stri_split_boundaries('Mr. Jones and Mrs. Brown are very happy.
So am I, Prof. Smith.', type='sentence', locale='en_US@ss=standard') # ICU >= 56 only
```

```
## [[1]]
## [1] "Mr. Jones and Mrs. Brown are very happy.\n"
## [2] "So am I, Prof. Smith."
```
