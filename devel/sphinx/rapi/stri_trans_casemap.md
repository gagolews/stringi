# stri_trans_casemap: Transform Strings with Case Mapping or Folding

## Description

These functions transform strings either to lower case, UPPER CASE, or Title Case or perform case folding.

## Usage

``` r
stri_trans_tolower(str, locale = NULL)

stri_trans_toupper(str, locale = NULL)

stri_trans_casefold(str)

stri_trans_totitle(str, ..., opts_brkiter = NULL)
```

## Arguments

|                |                                                                                                                                                                                                       |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`          | character vector                                                                                                                                                                                      |
| `locale`       | `NULL` or `''` for case mapping following the conventions of the default locale, or a single string with locale identifier, see [stringi-locale](about_locale.md).                                    |
| `...`          | additional settings for `opts_brkiter`                                                                                                                                                                |
| `opts_brkiter` | a named list with <span class="pkg">ICU</span> BreakIterator\'s settings, see [`stri_opts_brkiter`](stri_opts_brkiter.md); `NULL` for default break iterator, i.e., `word`; `stri_trans_totitle` only |

## Details

Vectorized over `str`.

<span class="pkg">ICU</span> implements full Unicode string case mappings. It is worth noting that, generally, case mapping:

-   can change the number of code points and/or code units of a string,

-   is language-sensitive (results may differ depending on the locale), and

-   is context-sensitive (a character in the input string may map differently depending on surrounding characters).

With `stri_trans_totitle`, if `word` `BreakIterator` is used (the default), then the first letter of each word will be capitalized and the rest will be transformed to lower case. With the break iterator of type `sentence`, the first letter of each sentence will be capitalized only. Note that according the <span class="pkg">ICU</span> User Guide, the string `'one. two. three.'` consists of one sentence.

Case folding, on the other hand, is locale-independent. Its purpose is to make two pieces of text that differ only in case identical. This may come in handy when comparing strings.

For more general (but not locale dependent) text transforms refer to [`stri_trans_general`](stri_trans_general.md).

## Value

Each function returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Case Mappings* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/transforms/casemappings.html>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi: [10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other locale_sensitive: [`%s<%()`](+25s+3C+25.md), [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_coll`](about_search_coll.md), [`stri_compare()`](stri_compare.md), [`stri_count_boundaries()`](stri_count_boundaries.md), [`stri_duplicated()`](stri_duplicated.md), [`stri_enc_detect2()`](stri_enc_detect2.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_opts_collator()`](stri_opts_collator.md), [`stri_order()`](stri_order.md), [`stri_rank()`](stri_rank.md), [`stri_sort_key()`](stri_sort_key.md), [`stri_sort()`](stri_sort.md), [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_unique()`](stri_unique.md), [`stri_wrap()`](stri_wrap.md)

Other transform: [`stri_trans_char()`](stri_trans_char.md), [`stri_trans_general()`](stri_trans_general.md), [`stri_trans_list()`](stri_trans_list.md), [`stri_trans_nfc()`](stri_trans_nf.md)

Other text_boundaries: [`about_search_boundaries`](about_search_boundaries.md), [`about_search`](about_search.md), [`stri_count_boundaries()`](stri_count_boundaries.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_opts_brkiter()`](stri_opts_brkiter.md), [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_split_lines()`](stri_split_lines.md), [`stri_wrap()`](stri_wrap.md)

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
stri_trans_totitle('stringi is a FREE R pAcKaGe. WItH NO StrinGS attached.') # word boundary
## [1] "Stringi Is A Free R Package. With No Strings Attached."
stri_trans_totitle('stringi is a FREE R pAcKaGe. WItH NO StrinGS attached.', type='sentence')
## [1] "Stringi is a free r package. With no strings attached."
```
