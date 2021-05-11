# stri\_enc\_list: List Known Character Encodings

## Description

Gives the list of encodings that are supported by <span class="pkg">ICU</span>.

## Usage

```r
stri_enc_list(simplify = FALSE)
```

## Arguments

|            |                                                                                 |
|------------|---------------------------------------------------------------------------------|
| `simplify` | single logical value; return a character vector or a list of character vectors? |

## Details

Apart from given encoding identifiers and their aliases, some other specifiers might be additionally available. This is due to the fact that <span class="pkg">ICU</span> tries to normalize converter names. For instance, `'UTF8'` is also valid, see [stringi-encoding](about_encoding.md) for more information.

## Value

If `simplify` is `FALSE` (the default), a list of character vectors is returned. Each list element represents a unique character encoding. The `name` attribute gives the <span class="pkg">ICU</span> Canonical Name of an encoding family. The elements (character vectors) are its aliases.

If `simplify` is `TRUE`, then the resulting list is coerced to a character vector and sorted, and returned with removed duplicated entries.

## See Also

Other encoding\_management: [`about_encoding`](about_encoding.md), [`stri_enc_info()`,](stri_enc_info.md) [`stri_enc_mark()`,](stri_enc_mark.md) `stri_enc_set()`
