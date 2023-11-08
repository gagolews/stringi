# stri_subset: Select Elements that Match a Given Pattern

## Description

These functions return or modify a sub-vector where there is a match to a given pattern. In other words, they are roughly equivalent (but faster and easier to use) to a call to `str[stri_detect(str, ...)]` or `str[stri_detect(str, ...)] <- value`.

## Usage

``` r
stri_subset(str, ..., regex, fixed, coll, charclass)

stri_subset(str, ..., regex, fixed, coll, charclass) <- value

stri_subset_fixed(
  str,
  pattern,
  omit_na = FALSE,
  negate = FALSE,
  ...,
  opts_fixed = NULL
)

stri_subset_fixed(str, pattern, negate=FALSE, ..., opts_fixed=NULL) <- value

stri_subset_charclass(str, pattern, omit_na = FALSE, negate = FALSE)

stri_subset_charclass(str, pattern, negate=FALSE) <- value

stri_subset_coll(
  str,
  pattern,
  omit_na = FALSE,
  negate = FALSE,
  ...,
  opts_collator = NULL
)

stri_subset_coll(str, pattern, negate=FALSE, ..., opts_collator=NULL) <- value

stri_subset_regex(
  str,
  pattern,
  omit_na = FALSE,
  negate = FALSE,
  ...,
  opts_regex = NULL
)

stri_subset_regex(str, pattern, negate=FALSE, ..., opts_regex=NULL) <- value
```

## Arguments

|                                                  |                                                                                                                                                                                                                                            |
|--------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`                                            | character vector; strings to search within                                                                                                                                                                                                 |
| `...`                                            | supplementary arguments passed to the underlying functions, including additional settings for `opts_collator`, `opts_regex`, `opts_fixed`, and so on                                                                                       |
| `value`                                          | non-empty character vector of replacement strings; replacement function only                                                                                                                                                               |
| `pattern`, `regex`, `fixed`, `coll`, `charclass` | character vector; search patterns (no more than the length of `str`); for more details refer to [stringi-search](about_search.md)                                                                                                          |
| `omit_na`                                        | single logical value; should missing values be excluded from the result?                                                                                                                                                                   |
| `negate`                                         | single logical value; whether a no-match is rather of interest                                                                                                                                                                             |
| `opts_collator`, `opts_fixed`, `opts_regex`      | a named list used to tune up the search engine\'s settings; see [`stri_opts_collator`](stri_opts_collator.md), [`stri_opts_fixed`](stri_opts_fixed.md), and [`stri_opts_regex`](stri_opts_regex.md), respectively; `NULL` for the defaults |

## Details

Vectorized over `str` as well as partially over `pattern` and `value`, with recycling of the elements in the shorter vector if necessary. As the aim here is to subset `str`, `pattern` cannot be longer than the former. Moreover, if the number of items to replace is not a multiple of length of `value`, a warning is emitted and the unused elements are ignored. Hence, the length of the output will be the same as length of `str`.

`stri_subset` and `stri_subset<-` are convenience functions. They call either `stri_subset_regex`, `stri_subset_fixed`, `stri_subset_coll`, or `stri_subset_charclass`, depending on the argument used.

## Value

The `stri_subset_*` functions return a character vector. As usual, the output encoding is UTF-8.

The `stri_subset_*<-` functions modifies `str` \'in-place\'.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other search_subset: [`about_search`](about_search.md)

## Examples




```r
stri_subset_regex(c('stringi R', '123', 'ID456', ''), '^[0-9]+$')
```

```
## [1] "123"
```

```r
x <- c('stringi R', '123', 'ID456', '')
`stri_subset_regex<-`(x, '[0-9]+$', negate=TRUE, value=NA)  # returns a copy
```

```
## [1] NA      "123"   "ID456" NA
```

```r
stri_subset_regex(x, '[0-9]+$') <- NA  # modifies `x` in-place
print(x)
```

```
## [1] "stringi R" NA          NA          ""
```
