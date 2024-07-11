# stri_flatten: Flatten a String

## Description

Joins the elements of a character vector into one string.

## Usage

``` r
stri_flatten(str, collapse = "", na_empty = FALSE, omit_empty = FALSE)
```

## Arguments

|  |  |
|----|----|
| `str` | a vector of strings to be coerced to character |
| `collapse` | a single string denoting the separator |
| `na_empty` | single logical value; should missing values in `str` be treated as empty strings (`TRUE`) or be omitted whatsoever (`NA`)? |
| `omit_empty` | single logical value; should empty strings in `str` be omitted? |

## Details

The `stri_flatten(str, collapse='XXX')` call is equivalent to [`paste(str, collapse='XXX', sep='')`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/paste.html).

If you wish to use some more fancy (e.g., differing) separators between flattened strings, call [`stri_join(str, separators, collapse='')`](stri_join.md).

If `str` is not empty, then a single string is returned. If `collapse` has length \> 1, then only the first string will be used.

## Value

Returns a single string, i.e., a character vector of length 1.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other join: [`%s+%()`](+25s+2B+25.md), [`stri_dup()`](stri_dup.md), [`stri_join()`](stri_join.md), [`stri_join_list()`](stri_join_list.md)

## Examples




``` r
stri_flatten(LETTERS)
```

```
## [1] "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
```

``` r
stri_flatten(LETTERS, collapse=',')
```

```
## [1] "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
```

``` r
stri_flatten(stri_dup(letters[1:6], 1:3))
```

```
## [1] "abbcccdeefff"
```

``` r
stri_flatten(c(NA, '', 'A', '', 'B', NA, 'C'), collapse=',', na_empty=TRUE, omit_empty=TRUE)
```

```
## [1] "A,B,C"
```

``` r
stri_flatten(c(NA, '', 'A', '', 'B', NA, 'C'), collapse=',', na_empty=NA)
```

```
## [1] ",A,,B,C"
```
