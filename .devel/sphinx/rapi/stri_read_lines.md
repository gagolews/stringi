# stri_read_lines: Read Text Lines from a Text File

## Description

Reads a text file in ins entirety, re-encodes it, and splits it into text lines.

## Usage

``` r
stri_read_lines(con, encoding = NULL, fname = con, fallback_encoding = NULL)
```

## Arguments

|                     |                                                                                 |
|---------------------|---------------------------------------------------------------------------------|
| `con`               | name of the output file or a connection object (opened in the binary mode)      |
| `encoding`          | single string; input encoding; `NULL` or `''` for the current default encoding. |
| `fname`             | deprecated alias of `con`                                                       |
| `fallback_encoding` | deprecated argument, no longer used                                             |

## Details

This aims to be a substitute for the [`readLines`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/readLines.html) function, with the ability to re-encode the input file in a much more robust way, and split the text into lines with [`stri_split_lines1`](stri_split_lines.md) (which conforms with the Unicode guidelines for newline markers).

The function calls [`stri_read_raw`](stri_read_raw.md), [`stri_encode`](stri_encode.md), and [`stri_split_lines1`](stri_split_lines.md), in this order.

Because of the way this function is currently implemented, maximal file size cannot exceed \~0.67 GB.

## Value

Returns a character vector, each text line is a separate string. The output is always marked as UTF-8.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other files: [`stri_read_raw()`](stri_read_raw.md), [`stri_write_lines()`](stri_write_lines.md)
