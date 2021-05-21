# stri\_wrap: Word Wrap Text to Format Paragraphs

## Description

This function breaks text paragraphs into lines, of total width (if it is possible) at most given `width`.

## Usage

```r
stri_wrap(
  str,
  width = floor(0.9 * getOption("width")),
  cost_exponent = 2,
  simplify = TRUE,
  normalize = TRUE,
  normalise = normalize,
  indent = 0,
  exdent = 0,
  prefix = "",
  initial = prefix,
  whitespace_only = FALSE,
  use_length = FALSE,
  locale = NULL
)
```

## Arguments

|                   |                                                                                                                                                                                                                                                                |
|-------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`             | character vector of strings to reformat                                                                                                                                                                                                                        |
| `width`           | single integer giving the suggested maximal number of code points per line                                                                                                                                                                                     |
| `cost_exponent`   | single numeric value, values not greater than zero will select a greedy word-wrapping algorithm; otherwise this value denotes the exponent in the cost function of a (more aesthetic) dynamic programming-based algorithm (values in \[2, 3\] are recommended) |
| `simplify`        | single logical value, see Value                                                                                                                                                                                                                                |
| `normalize`       | single logical value, see Details                                                                                                                                                                                                                              |
| `normalise`       | alias of `normalize`                                                                                                                                                                                                                                           |
| `indent`          | single non-negative integer; gives the indentation of the first line in each paragraph                                                                                                                                                                         |
| `exdent`          | single non-negative integer; specifies the indentation of subsequent lines in paragraphs                                                                                                                                                                       |
| `prefix, initial` | single strings; `prefix` is used as prefix for each line except the first, for which `initial` is utilized                                                                                                                                                     |
| `whitespace_only` | single logical value; allow breaks only at white-spaces? if `FALSE`, <span class="pkg">ICU</span>\'s line break iterator is used to split text into words, which is suitable for natural language processing                                                   |
| `use_length`      | single logical value; should the number of code points be used instead of the total code point width (see [`stri_width`](https://stringi.gagolewski.com/rapi/stri_width.html))?                                                                                |
| `locale`          | `NULL` or `''` for text boundary analysis following the conventions of the default locale, or a single string with locale identifier, see [stringi-locale](https://stringi.gagolewski.com/rapi/stringi-locale.html)                                            |

## Details

Vectorized over `str`.

If `whitespace_only` is `FALSE`, then <span class="pkg">ICU</span>\'s line-`BreakIterator` is used to determine text boundaries where a line break is possible. This is a locale-dependent operation. Otherwise, the breaks are only at white-spaces.

Note that Unicode code points may have various widths when printed on the console and that the function takes that by default into account. By changing the state of the `use_length` argument, this function starts to act like each code point was of width 1. This feature should rather be used with text in Latin script.

If `normalize` is `FALSE`, then multiple white spaces between the word boundaries are preserved within each wrapped line. In such a case, none of the strings can contain `\r`, `\n`, or other new line characters, otherwise you will get an error. You should split the input text into lines or, for example, substitute line breaks with spaces before applying this function.

If `normalize` is `TRUE`, then all consecutive white space (ASCII space, horizontal TAB, CR, LF) sequences are replaced with single ASCII spaces before actual string wrapping. Moreover, [`stri_split_lines`](https://stringi.gagolewski.com/rapi/stri_split_lines.html) and [`stri_trans_nfc`](https://stringi.gagolewski.com/rapi/stri_trans_nfc.html) is called on the input character vector. This is for compatibility with [`strwrap`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/strwrap.html).

The greedy algorithm (for `cost_exponent` being non-positive) provides a very simple way for word wrapping. It always puts as many words in each line as possible. This method -- contrary to the dynamic algorithm -- does not minimize the number of space left at the end of every line. The dynamic algorithm (a.k.a. Knuth\'s word wrapping algorithm) is more complex, but it returns text wrapped in a more aesthetic way. This method minimizes the squared (by default, see `cost_exponent`) number of spaces (raggedness) at the end of each line, so the text is mode arranged evenly. Note that the cost of printing the last line is always zero.

## Value

If `simplify` is `TRUE`, then a character vector is returned. Otherwise, you will get a list of `length(str)` character vectors.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

D.E. Knuth, M.F. Plass, Breaking paragraphs into lines, *Software: Practice and Experience* 11(11), 1981, pp. 1119--1184

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other locale\_sensitive: [`%s<%`](https://stringi.gagolewski.com/rapi/%25s%3C%25.html)(), [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)()

Other text\_boundaries: [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_brkiter`](https://stringi.gagolewski.com/rapi/stri_opts_brkiter.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_split_lines`](https://stringi.gagolewski.com/rapi/stri_split_lines.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)()

## Examples




```r
s <- stri_paste(
   'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin ',
   'nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel ',
   'lorem. Etiam pellentesque aliquet tellus.')
cat(stri_wrap(s, 20, 0.0), sep='\n') # greedy
## Lorem ipsum dolor
## sit amet,
## consectetur
## adipisicing elit.
## Proin nibh augue,
## suscipit a,
## scelerisque sed,
## lacinia in, mi. Cras
## vel lorem. Etiam
## pellentesque aliquet
## tellus.
cat(stri_wrap(s, 20, 2.0), sep='\n') # dynamic
## Lorem ipsum
## dolor sit amet,
## consectetur
## adipisicing elit.
## Proin nibh augue,
## suscipit a,
## scelerisque sed,
## lacinia in, mi. Cras
## vel lorem. Etiam
## pellentesque aliquet
## tellus.
cat(stri_pad(stri_wrap(s), side='both'), sep='\n')
##   Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin nibh  
##   augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel lorem.   
##                    Etiam pellentesque aliquet tellus.
```
