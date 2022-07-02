# stri_trans_nf: Perform or Check For Unicode Normalization

## Description

These functions convert strings to NFC, NFKC, NFD, NFKD, or NFKC_Casefold Unicode Normalization Form or check whether strings are normalized.

## Usage

``` r
stri_trans_nfc(str)

stri_trans_nfd(str)

stri_trans_nfkd(str)

stri_trans_nfkc(str)

stri_trans_nfkc_casefold(str)

stri_trans_isnfc(str)

stri_trans_isnfd(str)

stri_trans_isnfkd(str)

stri_trans_isnfkc(str)

stri_trans_isnfkc_casefold(str)
```

## Arguments

|       |                                |
|-------|--------------------------------|
| `str` | character vector to be encoded |

## Details

Unicode Normalization Forms are formally defined normalizations of Unicode strings which, e.g., make possible to determine whether any two strings are equivalent. Essentially, the Unicode Normalization Algorithm puts all combining marks in a specified order, and uses rules for decomposition and composition to transform each string into one of the Unicode Normalization Forms.

The following Normalization Forms (NFs) are supported:

-   NFC (Canonical Decomposition, followed by Canonical Composition),

-   NFD (Canonical Decomposition),

-   NFKC (Compatibility Decomposition, followed by Canonical Composition),

-   NFKD (Compatibility Decomposition),

-   NFKC_Casefold (combination of NFKC, case folding, and removing ignorable characters which was introduced with Unicode 5.2).

Note that many W3C Specifications recommend using NFC for all content, because this form avoids potential interoperability problems arising from the use of canonically equivalent, yet different, character sequences in document formats on the Web. Thus, you will rather not use these functions in typical string processing activities. Most often you may assume that a string is in NFC, see RFC5198.

As usual in <span class="pkg">stringi</span>, if the input character vector is in the native encoding, it will be automatically converted to UTF-8.

For more general text transforms refer to [`stri_trans_general`](stri_trans_general.md).

## Value

The `stri_trans_nf*` functions return a character vector of the same length as input (the output is always in UTF-8).

`stri_trans_isnf*` return a logical vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Unicode Normalization Forms* -- Unicode Standard Annex #15, <https://unicode.org/reports/tr15/>

*Unicode Format for Network Interchange* -- RFC5198, <https://tools.ietf.org/rfc/rfc5198.txt>

*Character Model for the World Wide Web 1.0: Normalization* -- W3C Working Draft, <https://www.w3.org/TR/charmod-norm/>

*Normalization* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/transforms/normalization/> (technical details)

*Unicode Equivalence* -- Wikipedia, <https://en.wikipedia.org/wiki/Unicode_equivalence>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi:<https://dx.doi.org/10.18637/jss.v103.i02>

Other transform: [`stri_trans_char()`](stri_trans_char.md), [`stri_trans_general()`](stri_trans_general.md), [`stri_trans_list()`](stri_trans_list.md), [`stri_trans_tolower()`](stri_trans_casemap.md)

## Examples




```r
stri_trans_nfd('\u0105') # a with ogonek -> a, ogonek
## [1] "ą"
stri_trans_nfkc('\ufdfa') # 1 codepoint -> 18 codepoints
## [1] "صلى الله عليه وسلم"
```
