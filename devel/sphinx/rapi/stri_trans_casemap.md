# stri\_trans\_casemap: Transform Strings with Case Mapping or Folding

## Description

These functions transform strings either to lower case, UPPER CASE, or Title Case or perform case folding.

## Usage

```r
stri_trans_tolower(str, locale = NULL)

stri_trans_toupper(str, locale = NULL)

stri_trans_casefold(str)

stri_trans_totitle(str, ..., opts_brkiter = NULL)
```

## Arguments

|                |                                                                                                                                                                                                                                             |
|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`          | character vector                                                                                                                                                                                                                            |
| `locale`       | `NULL` or `''` for case mapping following the conventions of the default locale, or a single string with locale identifier, see [stringi-locale](https://stringi.gagolewski.com/rapi/stringi-locale.html).                                  |
| `...`          | additional settings for `opts_brkiter`                                                                                                                                                                                                      |
| `opts_brkiter` | a named list with <span class="pkg">ICU</span> BreakIterator\'s settings, see [`stri_opts_brkiter`](https://stringi.gagolewski.com/rapi/stri_opts_brkiter.html); `NULL` for default break iterator, i.e., `word`; `stri_trans_totitle` only |

## Details

Vectorized over `str`.

<span class="pkg">ICU</span> implements full Unicode string case mappings. It is worth noting that, generally, case mapping:

-   can change the number of code points and/or code units of a string,

-   is language-sensitive (results may differ depending on the locale), and

-   is context-sensitive (a character in the input string may map differently depending on surrounding characters).

With `stri_trans_totitle`, if `word` `BreakIterator` is used (the default), then the first letter of each word will be capitalized and the rest will be transformed to lower case. With the break iterator of type `sentence`, the first letter of each sentence will be capitalized only. Note that according the <span class="pkg">ICU</span> User Guide, the string `'one. two. three.'` consists of one sentence.

Case folding, on the other hand, is locale-independent. Its purpose is to make two pieces of text that differ only in case identical. This may come in handy when comparing strings.

For more general (but not locale dependent) text transforms refer to [`stri_trans_general`](https://stringi.gagolewski.com/rapi/stri_trans_general.html).

## Value

Each function returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Case Mappings* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/transforms/casemappings.html>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other locale\_sensitive: [`%s<%`](https://stringi.gagolewski.com/rapi/%25s%3C%25.html)(), [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

Other transform: [`stri_trans_char`](https://stringi.gagolewski.com/rapi/stri_trans_char.html)(), [`stri_trans_general`](https://stringi.gagolewski.com/rapi/stri_trans_general.html)(), [`stri_trans_list`](https://stringi.gagolewski.com/rapi/stri_trans_list.html)(), [`stri_trans_nfc`](https://stringi.gagolewski.com/rapi/stri_trans_nfc.html)()

Other text\_boundaries: [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_brkiter`](https://stringi.gagolewski.com/rapi/stri_opts_brkiter.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_split_lines`](https://stringi.gagolewski.com/rapi/stri_split_lines.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

## Examples




```r
stri_trans_toupper('\u00DF', 'de_DE') # small German Eszett / scharfes S
## [1] "SS"
stri_cmp_eq(stri_trans_toupper('i', 'en_US'), stri_trans_toupper('i', 'tr_TR'))
## [1] FALSE
stri_trans_toupper(c('abc', '123', '\u0105\u0104'))
## [1] "ABC" "123" "ĄĄ"
stri_trans_tolower(c('AbC', '123', '\u0105\u0104'))
## [1] "abc" "123" "ąą"
stri_trans_totitle(c('AbC', '123', '\u0105\u0104'))
## [1] "Abc" "123" "Ąą"
stri_trans_casefold(c('AbC', '123', '\u0105\u0104'))
## [1] "abc" "123" "ąą"
stri_trans_totitle('cOOkiE mOnSTeR likes COOKIES. Here HE comes!') # word boundary
## [1] "Cookie Monster Likes Cookies. Here He Comes!"
stri_trans_totitle('cOOkiE mOnSTeR likes COOKIES. Here HE comes!', type='sentence')
## [1] "Cookie monster likes cookies. Here he comes!"
```
