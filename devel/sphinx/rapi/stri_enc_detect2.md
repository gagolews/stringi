# stri\_enc\_detect2: \[DEPRECATED\] Detect Locale-Sensitive Character Encoding

## Description

This function tries to detect character encoding in case the language of text is known.

## Usage

```r
stri_enc_detect2(str, locale = NULL)
```

## Arguments

|          |                                                                                                                         |
|----------|-------------------------------------------------------------------------------------------------------------------------|
| `str`    | character vector, a raw vector, or a list of `raw` vectors                                                              |
| `locale` | `NULL` or `''` for default locale, `NA` for just checking the UTF-\* family, or a single string with locale identifier. |

## Details

Vectorized over `str`.

First, the text is checked whether it is valid UTF-32BE, UTF-32LE, UTF-16BE, UTF-16LE, UTF-8 (as in [`stri_enc_detect`](https://stringi.gagolewski.com/rapi/stri_enc_detect.html), this is roughly inspired by <span class="pkg">ICU</span>\'s `i18n/csrucode.cpp`) or ASCII.

If `locale` is not `NA` and the above fails, the text is checked for the number of occurrences of language-specific code points (data provided by the <span class="pkg">ICU</span> library) converted to all possible 8-bit encodings that fully cover the indicated language. The encoding is selected based on the greatest number of total byte hits.

The guess is of course imprecise, as it is obtained using statistics and heuristics. Because of this, detection works best if you supply at least a few hundred bytes of character data that is in a single language.

If you have no initial guess on the language and encoding, try with [`stri_enc_detect`](https://stringi.gagolewski.com/rapi/stri_enc_detect.html) (uses <span class="pkg">ICU</span> facilities).

## Value

Just like [`stri_enc_detect`](https://stringi.gagolewski.com/rapi/stri_enc_detect.html), this function returns a list of length equal to the length of `str`. Each list element is a data frame with the following three named components:

-   `Encoding` -- string; guessed encodings; `NA` on failure (if and only if `encodings` is empty),

-   `Language` -- always `NA`,

-   `Confidence` -- numeric in \[0,1\]; the higher the value, the more confidence there is in the match; `NA` on failure.

The guesses are ordered by decreasing confidence.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other locale\_sensitive: [`%s<%`](https://stringi.gagolewski.com/rapi/%25s%3C%25.html)(), [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

Other encoding\_detection: [`about_encoding`](https://stringi.gagolewski.com/rapi/about_encoding.html), [`stri_enc_detect`](https://stringi.gagolewski.com/rapi/stri_enc_detect.html)(), [`stri_enc_isascii`](https://stringi.gagolewski.com/rapi/stri_enc_isascii.html)(), [`stri_enc_isutf16be`](https://stringi.gagolewski.com/rapi/stri_enc_isutf16be.html)(), [`stri_enc_isutf8`](https://stringi.gagolewski.com/rapi/stri_enc_isutf8.html)()
