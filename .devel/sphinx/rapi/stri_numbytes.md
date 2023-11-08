# stri_numbytes: Count the Number of Bytes

## Description

Counts the number of bytes needed to store each string in the computer\'s memory.

## Usage

``` r
stri_numbytes(str)
```

## Arguments

|       |                                            |
|-------|--------------------------------------------|
| `str` | character vector or an object coercible to |

## Details

Often, this is not the function you would normally use in your string processing activities. See [`stri_length`](stri_length.md) instead.

For 8-bit encoded strings, this is the same as [`stri_length`](stri_length.md). For UTF-8 strings, the returned values may be greater than the number of code points, as UTF-8 is not a fixed-byte encoding: one code point may be encoded by 1-4 bytes (according to the current Unicode standard).

Missing values are handled properly.

The strings do not need to be re-encoded to perform this operation.

The returned values do not include the trailing NUL bytes, which are used internally to mark the end of string data (in C).

## Value

Returns an integer vector of the same length as `str`.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other length: [`%s$%()`](+25s+24+25.md), [`stri_isempty()`](stri_isempty.md), [`stri_length()`](stri_length.md), [`stri_pad_both()`](stri_pad.md), [`stri_sprintf()`](stri_sprintf.md), [`stri_width()`](stri_width.md)

## Examples




```r
stri_numbytes(letters)
```

```
##  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
```

```r
stri_numbytes(c('abc', '123', '\u0105\u0104'))
```

```
## [1] 3 3 4
```

```r
## Not run: 
# this used to fail on Windows, where there were no native support
# for 4-bytes Unicode characters; see, however, stri_unescape_unicode():
stri_numbytes('\U001F600') # compare stri_length('\U001F600')
```

```
## [1] 4
```

```r
## End(Not run)
```
