# stri_sub_all: Extract or Replace Multiple Substrings

## Description

`stri_sub_all` extracts multiple substrings from each string. Its replacement version substitutes (in-place) multiple substrings with the corresponding replacement strings. `stri_sub_replace_all` (alias `stri_sub_all_replace`) is its forward pipe operator-friendly variant, returning a copy of the input vector.

For extracting/replacing single substrings from/within each string, see [`stri_sub`](stri_sub.md).

## Usage

``` r
stri_sub_all(
  str,
  from = list(1L),
  to = list(-1L),
  length,
  use_matrix = TRUE,
  ignore_negative_length = TRUE
)

stri_sub_all(
  str,
  from = list(1L),
  to = list(-1L),
  length,
  omit_na = FALSE,
  use_matrix = TRUE
) <- value

stri_sub_replace_all(..., replacement, value = replacement)

stri_sub_all_replace(..., replacement, value = replacement)
```

## Arguments

|                          |                                                                                                                                                                                                                                                                         |
|--------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`                    | character vector                                                                                                                                                                                                                                                        |
| `from`                   | list of integer vector giving the start indexes; alternatively, if `use_matrix=TRUE`, a list of two-column matrices of type `cbind(from, to)` (unnamed columns or the 2nd column named other than `length`) or `cbind(from, length=length)` (2nd column named `length`) |
| `to`                     | list of integer vectors giving the end indexes                                                                                                                                                                                                                          |
| `length`                 | list of integer vectors giving the substring lengths                                                                                                                                                                                                                    |
| `use_matrix`             | single logical value; see `from`                                                                                                                                                                                                                                        |
| `ignore_negative_length` | single logical value; whether negative lengths should be ignored or result in missing values                                                                                                                                                                            |
| `omit_na`                | single logical value; indicates whether missing values in any of the indexes or in `value` leave the part of the corresponding input string unchanged \[replacement function only\]                                                                                     |
| `value`                  | a list of character vectors defining the replacement strings \[replacement function only\]                                                                                                                                                                              |
| `...`                    | arguments to be passed to `stri_sub_all<-`                                                                                                                                                                                                                              |
| `replacement`            | alias of `value` \[wherever applicable\]                                                                                                                                                                                                                                |

## Details

Vectorized over `str`, \[`value`\], `from` and (`to` or `length`). Just like in [`stri_sub`](stri_sub.md), parameters `to` and `length` are mutually exclusive.

In one of the simplest scenarios, `stri_sub_all(str, from, to)`, the i-th element of the resulting list generated like `stri_sub(str[i], from[[i]], to[[i]])`. As usual, if one of the inputs is shorter than the others, recycling rule is applied.

If any of `from`, `to`, `length`, or `value` is not a list, it is wrapped into a list.

If `from` consists of a two-column matrix, then these two columns are used as `from` and `to`, respectively, unless the second column is named `length`. Such types of index matrices are generated by [`stri_locate_all`](stri_locate.md). If extraction or replacement based on [`stri_locate_first`](stri_locate.md) or [`stri_locate_last`](stri_locate.md) is needed, see [`stri_sub`](stri_sub.md).

In the replacement function, the index ranges must be sorted with respect to `from` and must be mutually disjoint. Negative `length` does not result in any altering of the corresponding input string. On the other hand, in `stri_sub_all`, this make the corresponding chunk be ignored, see `ignore_negative_length`, though.

## Value

`stri_sub_all` returns a list of character vectors. Its replacement versions modify the input \'in-place\'.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi: [10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other indexing: [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_locate_all()`](stri_locate.md), [`stri_sub()`](stri_sub.md)

## Examples




```r
x <- c('12 3456 789', 'abc', '', NA, '667')
stri_sub_all(x, stri_locate_all_regex(x, '[0-9]+')) # see stri_extract_all
## [[1]]
## [1] "12"   "3456" "789" 
## 
## [[2]]
## [1] NA
## 
## [[3]]
## [1] NA
## 
## [[4]]
## [1] NA
## 
## [[5]]
## [1] "667"
stri_sub_all(x, stri_locate_all_regex(x, '[0-9]+', omit_no_match=TRUE))
## [[1]]
## [1] "12"   "3456" "789" 
## 
## [[2]]
## character(0)
## 
## [[3]]
## character(0)
## 
## [[4]]
## [1] NA
## 
## [[5]]
## [1] "667"
stri_sub_all(x, stri_locate_all_regex(x, '[0-9]+', omit_no_match=TRUE)) <- '***'
print(x)
## [1] "*** *** ***" "abc"         ""            NA            "***"
stri_sub_replace_all('a b c', c(1, 3, 5), c(1, 3, 5), replacement=c('A', 'B', 'C'))
## [1] "A B C"
```
