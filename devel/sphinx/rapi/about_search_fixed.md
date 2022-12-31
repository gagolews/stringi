# about_search_fixed: Locale-Insensitive Fixed Pattern Matching in <span class="pkg">stringi</span>

## Description

String searching facilities described here provide a way to locate a specific sequence of bytes in a string. The search engine\'s settings may be tuned up (for example to perform case-insensitive search) via a call to the [`stri_opts_fixed`](stri_opts_fixed.md) function.

## Byte Compare

The fast Knuth-Morris-Pratt search algorithm, with worst time complexity of O(n+p) (`n == length(str)`, `p == length(pattern)`) is implemented (with some tweaks for very short search patterns).

Be aware that, for natural language processing, fixed pattern searching might not be what you actually require. It is because a bitwise match will not give correct results in cases of:

1.  accented letters;

2.  conjoined letters;

3.  ignorable punctuation;

4.  ignorable case,

see also [about_search_coll](about_search_coll.md).

Note that the conversion of input data to Unicode is done as usual.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other search_fixed: [`about_search`](about_search.md), [`stri_opts_fixed()`](stri_opts_fixed.md)

Other stringi_general_topics: [`about_arguments`](about_arguments.md), [`about_encoding`](about_encoding.md), [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_charclass`](about_search_charclass.md), [`about_search_coll`](about_search_coll.md), [`about_search_regex`](about_search_regex.md), [`about_search`](about_search.md), [`about_stringi`](about_stringi.md)
