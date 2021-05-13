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

First, the text is checked whether it is valid UTF-32BE, UTF-32LE, UTF-16BE, UTF-16LE, UTF-8 (as in [`stri_enc_detect`](stri_enc_detect.md), this is roughly inspired by <span class="pkg">ICU</span>\'s `i18n/csrucode.cpp`) or ASCII.

If `locale` is not `NA` and the above fails, the text is checked for the number of occurrences of language-specific code points (data provided by the <span class="pkg">ICU</span> library) converted to all possible 8-bit encodings that fully cover the indicated language. The encoding is selected based on the greatest number of total byte hits.

The guess is of course imprecise, as it is obtained using statistics and heuristics. Because of this, detection works best if you supply at least a few hundred bytes of character data that is in a single language.

If you have no initial guess on the language and encoding, try with [`stri_enc_detect`](stri_enc_detect.md) (uses <span class="pkg">ICU</span> facilities).

## Value

Just like [`stri_enc_detect`](stri_enc_detect.md), this function returns a list of length equal to the length of `str`. Each list element is a data frame with the following three named components:

-   `Encoding` -- string; guessed encodings; `NA` on failure (if and only if `encodings` is empty),

-   `Language` -- always `NA`,

-   `Confidence` -- numeric in \[0,1\]; the higher the value, the more confidence there is in the match; `NA` on failure.

The guesses are ordered by decreasing confidence.

## See Also

Other locale\_sensitive: [`%s<%()`,](operator_compare.md) [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_coll`](about_search_coll.md), [`stri_compare()`,](stri_compare.md) [`stri_count_boundaries()`,](stri_count_boundaries.md) [`stri_duplicated()`,](stri_duplicated.md) [`stri_extract_all_boundaries()`,](stri_extract_boundaries.md) [`stri_locate_all_boundaries()`,](stri_locate_boundaries.md) [`stri_opts_collator()`,](stri_opts_collator.md) [`stri_order()`,](stri_order.md) [`stri_rank()`,](stri_rank.md) [`stri_sort_key()`,](stri_sort_key.md) [`stri_sort()`,](stri_sort.md) [`stri_split_boundaries()`,](stri_split_boundaries.md) [`stri_trans_tolower()`,](stri_trans_casemap.md) [`stri_unique()`,](stri_unique.md) `stri_wrap()`

Other encoding\_detection: [`about_encoding`](about_encoding.md), [`stri_enc_detect()`,](stri_enc_detect.md) [`stri_enc_isascii()`,](stri_enc_isascii.md) [`stri_enc_isutf16be()`,](stri_enc_isutf16.md) `stri_enc_isutf8()`
