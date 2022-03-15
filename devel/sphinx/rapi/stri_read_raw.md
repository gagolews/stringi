# stri_read_raw: Read Text File as Raw

## Description

Reads a text file as-is, with no conversion or text line splitting.

## Usage

``` r
stri_read_raw(con, fname = con)
```

## Arguments

|         |                                                                            |
|---------|----------------------------------------------------------------------------|
| `con`   | name of the output file or a connection object (opened in the binary mode) |
| `fname` | deprecated alias of `con`                                                  |

## Details

Once a text file is read into memory, encoding detection (see [`stri_enc_detect`](stri_enc_detect.md)), conversion (see [`stri_encode`](stri_encode.md)), and/or splitting of text into lines (see [`stri_split_lines1`](stri_split_lines.md)) can be performed.

## Value

Returns a vector of type `raw`.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other files: [`stri_read_lines()`](stri_read_lines.md), [`stri_write_lines()`](stri_write_lines.md)
