# stri\_trans\_general: General Text Transforms, Including Transliteration

## Description

<span class="pkg">ICU</span> General transforms provide different ways for processing Unicode text. They are useful in handling a variety of different tasks, including:

-   Upper Case, Lower Case, Title Case, Full/Halfwidth conversions,

-   Normalization,

-   Hex and Character Name conversions,

-   Script to Script conversion/transliteration.

## Usage

```r
stri_trans_general(str, id, rules = FALSE, forward = TRUE)
```

## Arguments

|           |                                                                                                                                 |
|-----------|---------------------------------------------------------------------------------------------------------------------------------|
| `str`     | character vector                                                                                                                |
| `id`      | a single string with transform identifier, see [`stri_trans_list`](stri_trans_list.md), or custom transliteration rules         |
| `rules`   | if `TRUE`, treat `id` as a string with semicolon-separated transliteration rules (see the <span class="pkg">ICU</span> manual); |
| `forward` | transliteration direction (`TRUE` for forward, `FALSE` for reverse)                                                             |

## Details

<span class="pkg">ICU</span> Transforms were mainly designed to transliterate characters from one script to another (for example, from Greek to Latin, or Japanese Katakana to Latin). However, these services are also capable of handling a much broader range of tasks. In particular, the Transforms include pre-built transformations for case conversions, for normalization conversions, for the removal of given characters, and also for a variety of language and script transliterations. Transforms can be chained together to perform a series of operations and each step of the process can use a UnicodeSet to restrict the characters that are affected.

To get the list of available transforms, call [`stri_trans_list`](stri_trans_list.md).

Note that transliterators are often combined in sequence to achieve a desired transformation. This is analogous to the composition of mathematical functions. For example, given a script that converts lowercase ASCII characters from Latin script to Katakana script, it is convenient to first (1) separate input base characters and accents, and then (2) convert uppercase to lowercase. To achieve this, a compound transform can be specified as follows: `NFKD; Lower; Latin-Katakana;` (with the default `rules=FALSE`).

Custom rule-based transliteration is also supported, see the <span class="pkg">ICU</span> manual and below for some examples.

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*General Transforms* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/transforms/general/>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other transform: [`stri_trans_char()`](stri_trans_char.md), [`stri_trans_list()`](stri_trans_list.md), [`stri_trans_nfc()`](stri_trans_nf.md), [`stri_trans_tolower()`](stri_trans_casemap.md)

## Examples




```r
stri_trans_general('gro\u00df', 'latin-ascii')
## [1] "gross"
stri_trans_general('stringi', 'latin-greek')
## [1] "στριγγι"
stri_trans_general('stringi', 'latin-cyrillic')
## [1] "стринги"
stri_trans_general('stringi', 'upper') # see stri_trans_toupper
## [1] "STRINGI"
stri_trans_general('\u0104', 'nfd; lower') # compound id; see stri_trans_nfd
## [1] "ą"
stri_trans_general('Marek G\u0105golewski', 'pl-pl_FONIPA')
## [1] "marɛk ɡɔŋɡɔlɛfski"
stri_trans_general('\u2620', 'any-name') # character name
## [1] "\\N{SKULL AND CROSSBONES}"
stri_trans_general('\\N{latin small letter a}', 'name-any') # decode name
## [1] "a"
stri_trans_general('\u2620', 'hex/c') # to hex
## [1] "\\u2620"
x <- "\uC11C\uC6B8\uD2B9\uBCC4\uC2DC\u0020\uC885\uB85C\uAD6C\u0020\uC0AC\uC9C1\uB3D9"
stringi::stri_trans_general(x, "Hangul-Latin")
## [1] "seoulteugbyeolsi jonglogu sajigdong"
# Deviate from the ICU rules of Romanisation of Korean,
# see https://en.wikipedia.org/wiki/%E3%84%B1
id <- "
    :: NFD;
    \u11A8 > k;
    \u11AE > t;
    \u11B8 > p;
    \u1105 > r;
    :: Hangul-Latin;
"
stringi::stri_trans_general(x, id, rules=TRUE)
## [1] "seoulteukbyeolsi jongrogu sajikdong"
```
