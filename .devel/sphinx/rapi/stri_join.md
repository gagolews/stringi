# stri_join: Concatenate Character Vectors

## Description

These are the <span class="pkg">stringi</span>\'s equivalents of the built-in [`paste`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/paste.html) function. `stri_c` and `stri_paste` are aliases for `stri_join`.

## Usage

``` r
stri_join(..., sep = "", collapse = NULL, ignore_null = FALSE)

stri_c(..., sep = "", collapse = NULL, ignore_null = FALSE)

stri_paste(..., sep = "", collapse = NULL, ignore_null = FALSE)
```

## Arguments

|               |                                                                                                                   |
|---------------|-------------------------------------------------------------------------------------------------------------------|
| `...`         | character vectors (or objects coercible to character vectors) whose corresponding elements are to be concatenated |
| `sep`         | a single string; separates terms                                                                                  |
| `collapse`    | a single string or `NULL`; an optional results separator                                                          |
| `ignore_null` | a single logical value; if `TRUE`, then empty vectors provided via `...` are silently ignored                     |

## Details

Vectorized over each atomic vector in \'`...`\'.

Unless `collapse` is `NULL`, the result will be a single string. Otherwise, you get a character vector of length equal to the length of the longest argument.

If any of the arguments in \'`...`\' is a vector of length 0 (not to be confused with vectors of empty strings) and `ignore_null` is `FALSE`, then you will get a 0-length character vector in result.

If `collapse` or `sep` has length greater than 1, then only the first string will be used.

In case where there are missing values in any of the input vectors, `NA` is set to the corresponding element. Note that this behavior is different from [`paste`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/paste.html), which treats missing values as ordinary strings like `'NA'`. Moreover, as usual in <span class="pkg">stringi</span>, the resulting strings are always in UTF-8.

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other join: [`%s+%()`](+25s+2B+25.md), [`stri_dup()`](stri_dup.md), [`stri_flatten()`](stri_flatten.md), [`stri_join_list()`](stri_join_list.md)

## Examples




```r
stri_join(1:13, letters)
```

```
##  [1] "1a"  "2b"  "3c"  "4d"  "5e"  "6f"  "7g"  "8h"  "9i"  "10j" "11k" "12l"
## [13] "13m" "1n"  "2o"  "3p"  "4q"  "5r"  "6s"  "7t"  "8u"  "9v"  "10w" "11x"
## [25] "12y" "13z"
```

```r
stri_join(1:13, letters, sep=',')
```

```
##  [1] "1,a"  "2,b"  "3,c"  "4,d"  "5,e"  "6,f"  "7,g"  "8,h"  "9,i"  "10,j"
## [11] "11,k" "12,l" "13,m" "1,n"  "2,o"  "3,p"  "4,q"  "5,r"  "6,s"  "7,t" 
## [21] "8,u"  "9,v"  "10,w" "11,x" "12,y" "13,z"
```

```r
stri_join(1:13, letters, collapse='; ')
```

```
## [1] "1a; 2b; 3c; 4d; 5e; 6f; 7g; 8h; 9i; 10j; 11k; 12l; 13m; 1n; 2o; 3p; 4q; 5r; 6s; 7t; 8u; 9v; 10w; 11x; 12y; 13z"
```

```r
stri_join(1:13, letters, sep=',', collapse='; ')
```

```
## [1] "1,a; 2,b; 3,c; 4,d; 5,e; 6,f; 7,g; 8,h; 9,i; 10,j; 11,k; 12,l; 13,m; 1,n; 2,o; 3,p; 4,q; 5,r; 6,s; 7,t; 8,u; 9,v; 10,w; 11,x; 12,y; 13,z"
```

```r
stri_join(c('abc', '123', 'xyz'),'###', 1:6, sep=',')
```

```
## [1] "abc,###,1" "123,###,2" "xyz,###,3" "abc,###,4" "123,###,5" "xyz,###,6"
```

```r
stri_join(c('abc', '123', 'xyz'),'###', 1:6, sep=',', collapse='; ')
```

```
## [1] "abc,###,1; 123,###,2; xyz,###,3; abc,###,4; 123,###,5; xyz,###,6"
```
