# stri\_locate\_boundaries: Locate Text Boundaries

## Description

These functions locate text boundaries (like character, word, line, or sentence boundaries). Use `stri_locate_all_*` to locate all the matches. `stri_locate_first_*` and `stri_locate_last_*` give the first or the last matches, respectively.

## Usage

```r
stri_locate_all_boundaries(
  str,
  omit_no_match = FALSE,
  ...,
  opts_brkiter = NULL
)

stri_locate_last_boundaries(str, ..., opts_brkiter = NULL)

stri_locate_first_boundaries(str, ..., opts_brkiter = NULL)

stri_locate_all_words(str, omit_no_match = FALSE, locale = NULL)

stri_locate_last_words(str, locale = NULL)

stri_locate_first_words(str, locale = NULL)
```

## Arguments

|                 |                                                                                                                                                                                                                        |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`           | character vector or an object coercible to                                                                                                                                                                             |
| `omit_no_match` | single logical value; if `FALSE`, then two missing values will indicate that there are no text boundaries                                                                                                              |
| `...`           | additional settings for `opts_brkiter`                                                                                                                                                                                 |
| `opts_brkiter`  | a named list with <span class="pkg">ICU</span> BreakIterator\'s settings, see [`stri_opts_brkiter`](https://stringi.gagolewski.com/rapi/stri_opts_brkiter.html); `NULL` for default break iterator, i.e., `line_break` |
| `locale`        | `NULL` or `''` for text boundary analysis following the conventions of the default locale, or a single string with locale identifier, see [stringi-locale](../../stringi/help/stringi-locale.html)                     |

## Details

Vectorized over `str`.

For more information on text boundary analysis performed by <span class="pkg">ICU</span>\'s `BreakIterator`, see [stringi-search-boundaries](../../stringi/help/stringi-search-boundaries.html).

In case of `stri_locate_*_words`, just like in [`stri_extract_all_words`](https://stringi.gagolewski.com/rapi/stri_extract_all_words.html) and [`stri_count_words`](https://stringi.gagolewski.com/rapi/stri_count_words.html), <span class="pkg">ICU</span>\'s word `BreakIterator` iterator is used to locate the word boundaries, and all non-word characters (`UBRK_WORD_NONE` rule status) are ignored. This is function is equivalent to a call to `stri_locate_*_boundaries(str, type='word', skip_word_none=TRUE, locale=locale)`

## Value

For `stri_locate_all_*`, a list of `length(str)` integer matrices is returned. The first column gives the start positions of substrings between located boundaries, and the second column gives the end positions. The indexes are code point-based, thus they may be passed, e.g., to [`stri_sub`](https://stringi.gagolewski.com/rapi/stri_sub.html) or [`stri_sub_all`](https://stringi.gagolewski.com/rapi/stri_sub_all.html). Note that you get two `NA`s in one row if there is no match (and `omit_no_match` is `FALSE`) or there are missing data in the input vector.

`stri_locate_first_*` and `stri_locate_last_*`, return an integer matrix with two columns, giving the start and end positions of the first or the last matches, respectively, and two `NA`s if there is no match.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other search\_locate: [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`stri_locate_all`](https://stringi.gagolewski.com/rapi/stri_locate_all.html)()

Other indexing: [`stri_locate_all`](https://stringi.gagolewski.com/rapi/stri_locate_all.html)(), [`stri_sub_all`](https://stringi.gagolewski.com/rapi/stri_sub_all.html)(), [`stri_sub`](https://stringi.gagolewski.com/rapi/stri_sub.html)()

Other locale\_sensitive: `%s<%()`, [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

Other text\_boundaries: [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_opts_brkiter`](https://stringi.gagolewski.com/rapi/stri_opts_brkiter.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_split_lines`](https://stringi.gagolewski.com/rapi/stri_split_lines.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

## Examples




```r
test <- 'The\u00a0above-mentioned    features are very useful. Spam, spam, eggs, bacon, and spam.'
stri_locate_all_boundaries(test, type='line')
## [[1]]
##       start end
##  [1,]     1  10
##  [2,]    11  23
##  [3,]    24  32
##  [4,]    33  36
##  [5,]    37  41
##  [6,]    42  49
##  [7,]    50  55
##  [8,]    56  61
##  [9,]    62  67
## [10,]    68  74
## [11,]    75  78
## [12,]    79  83
stri_locate_all_boundaries(test, type='word')
## [[1]]
##       start end
##  [1,]     1   3
##  [2,]     4   4
##  [3,]     5   9
##  [4,]    10  10
##  [5,]    11  19
##  [6,]    20  23
##  [7,]    24  31
##  [8,]    32  32
##  [9,]    33  35
## [10,]    36  36
## [11,]    37  40
## [12,]    41  41
## [13,]    42  47
## [14,]    48  48
## [15,]    49  49
## [16,]    50  53
## [17,]    54  54
## [18,]    55  55
## [19,]    56  59
## [20,]    60  60
## [21,]    61  61
## [22,]    62  65
## [23,]    66  66
## [24,]    67  67
## [25,]    68  72
## [26,]    73  73
## [27,]    74  74
## [28,]    75  77
## [29,]    78  78
## [30,]    79  82
## [31,]    83  83
stri_locate_all_boundaries(test, type='sentence')
## [[1]]
##      start end
## [1,]     1  49
## [2,]    50  83
stri_locate_all_boundaries(test, type='character')
## [[1]]
##       start end
##  [1,]     1   1
##  [2,]     2   2
##  [3,]     3   3
##  [4,]     4   4
##  [5,]     5   5
##  [6,]     6   6
##  [7,]     7   7
##  [8,]     8   8
##  [9,]     9   9
## [10,]    10  10
## [11,]    11  11
## [12,]    12  12
## [13,]    13  13
## [14,]    14  14
## [15,]    15  15
## [16,]    16  16
## [17,]    17  17
## [18,]    18  18
## [19,]    19  19
## [20,]    20  20
## [21,]    21  21
## [22,]    22  22
## [23,]    23  23
## [24,]    24  24
## [25,]    25  25
## [26,]    26  26
## [27,]    27  27
## [28,]    28  28
## [29,]    29  29
## [30,]    30  30
## [31,]    31  31
## [32,]    32  32
## [33,]    33  33
## [34,]    34  34
## [35,]    35  35
## [36,]    36  36
## [37,]    37  37
## [38,]    38  38
## [39,]    39  39
## [40,]    40  40
## [41,]    41  41
## [42,]    42  42
## [43,]    43  43
## [44,]    44  44
## [45,]    45  45
## [46,]    46  46
## [47,]    47  47
## [48,]    48  48
## [49,]    49  49
## [50,]    50  50
## [51,]    51  51
## [52,]    52  52
## [53,]    53  53
## [54,]    54  54
## [55,]    55  55
## [56,]    56  56
## [57,]    57  57
## [58,]    58  58
## [59,]    59  59
## [60,]    60  60
## [61,]    61  61
## [62,]    62  62
## [63,]    63  63
## [64,]    64  64
## [65,]    65  65
## [66,]    66  66
## [67,]    67  67
## [68,]    68  68
## [69,]    69  69
## [70,]    70  70
## [71,]    71  71
## [72,]    72  72
## [73,]    73  73
## [74,]    74  74
## [75,]    75  75
## [76,]    76  76
## [77,]    77  77
## [78,]    78  78
## [79,]    79  79
## [80,]    80  80
## [81,]    81  81
## [82,]    82  82
## [83,]    83  83
stri_locate_all_words(test)
## [[1]]
##       start end
##  [1,]     1   3
##  [2,]     5   9
##  [3,]    11  19
##  [4,]    24  31
##  [5,]    33  35
##  [6,]    37  40
##  [7,]    42  47
##  [8,]    50  53
##  [9,]    56  59
## [10,]    62  65
## [11,]    68  72
## [12,]    75  77
## [13,]    79  82
stri_extract_all_boundaries('Mr. Jones and Mrs. Brown are very happy.
So am I, Prof. Smith.', type='sentence', locale='en_US@ss=standard') # ICU >= 56 only
## [[1]]
## [1] "Mr. Jones and Mrs. Brown are very happy.\n"
## [2] "So am I, Prof. Smith."
```
