# stri\_split\_boundaries: Split a String at Text Boundaries

## Description

This function locates text boundaries (like character, word, line, or sentence boundaries) and splits strings at the indicated positions.

## Usage

```r
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

|                |                                                                                                                                                                                                                            |
|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`          | character vector or an object coercible to                                                                                                                                                                                 |
| `n`            | integer vector, maximal number of strings to return                                                                                                                                                                        |
| `tokens_only`  | single logical value; may affect the result if `n` is positive, see Details                                                                                                                                                |
| `simplify`     | single logical value; if `TRUE` or `NA`, then a character matrix is returned; otherwise (the default), a list of character vectors is given, see Value                                                                     |
| `...`          | additional settings for `opts_brkiter`                                                                                                                                                                                     |
| `opts_brkiter` | a named list with <span class="pkg">ICU</span> BreakIterator\'s settings, see [`stri_opts_brkiter`](https://stringi.gagolewski.com/rapi/stri_opts_brkiter.html); `NULL` for the default break iterator, i.e., `line_break` |

## Details

Vectorized over `str` and `n`.

If `n` is negative (the default), then all text pieces are extracted.

Otherwise, if `tokens_only` is `FALSE` (which is the default), then `n-1` tokens are extracted (if possible) and the `n`-th string gives the (non-split) remainder (see Examples). On the other hand, if `tokens_only` is `TRUE`, then only full tokens (up to `n` pieces) are extracted.

For more information on text boundary analysis performed by <span class="pkg">ICU</span>\'s `BreakIterator`, see [stringi-search-boundaries](https://stringi.gagolewski.com/rapi/stringi-search-boundaries.html).

## Value

If `simplify=FALSE` (the default), then the functions return a list of character vectors.

Otherwise, [`stri_list2matrix`](https://stringi.gagolewski.com/rapi/stri_list2matrix.html) with `byrow=TRUE` and `n_min=n` arguments is called on the resulting object. In such a case, a character matrix with `length(str)` rows is returned. Note that [`stri_list2matrix`](https://stringi.gagolewski.com/rapi/stri_list2matrix.html)\'s `fill` argument is set to an empty string and `NA`, for `simplify` equal to `TRUE` and `NA`, respectively.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other search\_split: [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`stri_split_lines`](https://stringi.gagolewski.com/rapi/stri_split_lines.html)(), [`stri_split`](https://stringi.gagolewski.com/rapi/stri_split.html)()

Other locale\_sensitive: [`%s<%`](https://stringi.gagolewski.com/rapi/%25s%3C%25.html)(), [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

Other text\_boundaries: [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_brkiter`](https://stringi.gagolewski.com/rapi/stri_opts_brkiter.html)(), [`stri_split_lines`](https://stringi.gagolewski.com/rapi/stri_split_lines.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

## Examples




```r
test <- 'The\u00a0above-mentioned    features are very useful. ' %s+%
   'Spam, spam, eggs, bacon, and spam. 123 456 789'
stri_split_boundaries(test, type='line')
## [[1]]
##  [1] "The above-"    "mentioned    " "features "     "are "         
##  [5] "very "         "useful. "      "Spam, "        "spam, "       
##  [9] "eggs, "        "bacon, "       "and "          "spam. "       
## [13] "123 "          "456 "          "789"
stri_split_boundaries(test, type='word')
## [[1]]
##  [1] "The"       " "         "above"     "-"         "mentioned" "    "     
##  [7] "features"  " "         "are"       " "         "very"      " "        
## [13] "useful"    "."         " "         "Spam"      ","         " "        
## [19] "spam"      ","         " "         "eggs"      ","         " "        
## [25] "bacon"     ","         " "         "and"       " "         "spam"     
## [31] "."         " "         "123"       " "         "456"       " "        
## [37] "789"
stri_split_boundaries(test, type='word', skip_word_none=TRUE)
## [[1]]
##  [1] "The"       "above"     "mentioned" "features"  "are"       "very"     
##  [7] "useful"    "Spam"      "spam"      "eggs"      "bacon"     "and"      
## [13] "spam"      "123"       "456"       "789"
stri_split_boundaries(test, type='word', skip_word_none=TRUE, skip_word_letter=TRUE)
## [[1]]
## [1] "123" "456" "789"
stri_split_boundaries(test, type='word', skip_word_none=TRUE, skip_word_number=TRUE)
## [[1]]
##  [1] "The"       "above"     "mentioned" "features"  "are"       "very"     
##  [7] "useful"    "Spam"      "spam"      "eggs"      "bacon"     "and"      
## [13] "spam"
stri_split_boundaries(test, type='sentence')
## [[1]]
## [1] "The above-mentioned    features are very useful. "
## [2] "Spam, spam, eggs, bacon, and spam. "              
## [3] "123 456 789"
stri_split_boundaries(test, type='sentence', skip_sentence_sep=TRUE)
## [[1]]
## [1] "The above-mentioned    features are very useful. "
## [2] "Spam, spam, eggs, bacon, and spam. "
stri_split_boundaries(test, type='character')
## [[1]]
##  [1] "T" "h" "e" " " "a" "b" "o" "v" "e" "-" "m" "e" "n" "t" "i" "o" "n" "e" "d"
## [20] " " " " " " " " "f" "e" "a" "t" "u" "r" "e" "s" " " "a" "r" "e" " " "v" "e"
## [39] "r" "y" " " "u" "s" "e" "f" "u" "l" "." " " "S" "p" "a" "m" "," " " "s" "p"
## [58] "a" "m" "," " " "e" "g" "g" "s" "," " " "b" "a" "c" "o" "n" "," " " "a" "n"
## [77] "d" " " "s" "p" "a" "m" "." " " "1" "2" "3" " " "4" "5" "6" " " "7" "8" "9"
# a filtered break iterator with the new ICU:
stri_split_boundaries('Mr. Jones and Mrs. Brown are very happy.
So am I, Prof. Smith.', type='sentence', locale='en_US@ss=standard') # ICU >= 56 only
## [[1]]
## [1] "Mr. Jones and Mrs. Brown are very happy.\n"
## [2] "So am I, Prof. Smith."
```
