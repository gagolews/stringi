# stri\_width: Determine the Width of Code Points

## Description

Approximates the number of text columns the \'cat()\' function might use to print a string using a mono-spaced font.

## Usage

```r
stri_width(str)
```

## Arguments

|       |                                            |
|-------|--------------------------------------------|
| `str` | character vector or an object coercible to |

## Details

The Unicode standard does not formalize the notion of a character width. Roughly based on <https://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c>, <https://github.com/nodejs/node/blob/master/src/node_i18n.cc>, and UAX \#11 we proceed as follows. The following code points are of width 0:

-   code points with general category (see [stringi-search-charclass](https://stringi.gagolewski.com/rapi/stringi-search-charclass.html)) `Me`, `Mn`, and `Cf`),

-   `C0` and `C1` control codes (general category `Cc`) - for compatibility with the [`nchar`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/nchar.html) function,

-   Hangul Jamo medial vowels and final consonants (code points with enumerable property `UCHAR_HANGUL_SYLLABLE_TYPE` equal to `U_HST_VOWEL_JAMO` or `U_HST_TRAILING_JAMO`; note that applying the NFC normalization with [`stri_trans_nfc`](https://stringi.gagolewski.com/rapi/stri_trans_nfc.html) is encouraged),

-   ZERO WIDTH SPACE (U+200B),

Characters with the `UCHAR_EAST_ASIAN_WIDTH` enumerable property equal to `U_EA_FULLWIDTH` or `U_EA_WIDE` are of width 2.

Most emojis and characters with general category So (other symbols) are of width 2.

SOFT HYPHEN (U+00AD) (for compatibility with [`nchar`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/nchar.html)) as well as any other characters have width 1.

## Value

Returns an integer vector of the same length as `str`.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*East Asian Width* -- Unicode Standard Annex \#11, <https://www.unicode.org/reports/tr11/>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other length: [`%s$%`](https://stringi.gagolewski.com/rapi/%25s$%25.html)(), [`stri_isempty`](https://stringi.gagolewski.com/rapi/stri_isempty.html)(), [`stri_length`](https://stringi.gagolewski.com/rapi/stri_length.html)(), [`stri_numbytes`](https://stringi.gagolewski.com/rapi/stri_numbytes.html)(), [`stri_pad_both`](https://stringi.gagolewski.com/rapi/stri_pad_both.html)(), [`stri_sprintf`](https://stringi.gagolewski.com/rapi/stri_sprintf.html)()

## Examples




```r
stri_width(LETTERS[1:5])
## [1] 1 1 1 1 1
stri_width(stri_trans_nfkd('\u0105'))
## [1] 1
stri_width(stri_trans_nfkd('\U0001F606'))
## [1] 2
stri_width( # Full-width equivalents of ASCII characters:
   stri_enc_fromutf32(as.list(c(0x3000, 0xFF01:0xFF5E)))
)
##  [1] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
## [39] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
## [77] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
stri_width(stri_trans_nfkd('\ubc1f')) # includes Hangul Jamo medial vowels and final consonants
## [1] 2
```
