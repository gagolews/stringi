# stri\_numbytes: Count the Number of Bytes

## Description

Counts the number of bytes needed to store each string in the computer\'s memory.

## Usage

```r
stri_numbytes(str)
```

## Arguments

|       |                                            |
|-------|--------------------------------------------|
| `str` | character vector or an object coercible to |

## Details

Often, this is not the function you would normally use in your string processing activities. See [`stri_length`](https://stringi.gagolewski.com/rapi/stri_length.html) instead.

For 8-bit encoded strings, this is the same as [`stri_length`](https://stringi.gagolewski.com/rapi/stri_length.html). For UTF-8 strings, the returned values may be greater than the number of code points, as UTF-8 is not a fixed-byte encoding: one code point may be encoded by 1-4 bytes (according to the current Unicode standard).

Missing values are handled properly.

The strings do not need to be re-encoded to perform this operation.

The returned values do not include the trailing NUL bytes, which are used internally to mark the end of string data (in C).

## Value

Returns an integer vector of the same length as `str`.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other length: [`stri_isempty`](https://stringi.gagolewski.com/rapi/stri_isempty.html)(), [`stri_length`](https://stringi.gagolewski.com/rapi/stri_length.html)(), [`stri_width`](https://stringi.gagolewski.com/rapi/stri_width.html)()

## Examples




```r
stri_numbytes(letters)
##  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
stri_numbytes(c('abc', '123', '\u0105\u0104'))
## [1] 3 3 4
## Not run: 
# this used to fail on Windows, where there were no native support
# for 4-bytes Unicode characters; see, however, stri_unescape_unicode():
stri_numbytes('\U001F600') # compare stri_length('\U001F600')
## [1] 4
## End(Not run)
```
