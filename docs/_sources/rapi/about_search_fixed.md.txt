# about\_search\_fixed: Locale-Insensitive Fixed Pattern Matching in <span class="pkg">stringi</span>

## Description

String searching facilities described here provide a way to locate a specific sequence of bytes in a string. The search engine\'s settings may be tuned up (for example to perform case-insensitive search) via a call to the [`stri_opts_fixed`](https://stringi.gagolewski.com/rapi/stri_opts_fixed.html) function.

## Byte Compare

The fast Knuth-Morris-Pratt search algorithm, with worst time complexity of O(n+p) (`n == length(str)`, `p == length(pattern)`) is implemented (with some tweaks for very short search patterns).

Be aware that, for natural language processing, fixed pattern searching might not be what you actually require. It is because a bitwise match will not give correct results in cases of:

1.  accented letters;

2.  conjoined letters;

3.  ignorable punctuation;

4.  ignorable case,

see also [about\_search\_coll](https://stringi.gagolewski.com/rapi/about_search_coll.html).

Note that the conversion of input data to Unicode is done as usual.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other search\_fixed: [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`stri_opts_fixed`](https://stringi.gagolewski.com/rapi/stri_opts_fixed.html)()

Other stringi\_general\_topics: [`about_arguments`](https://stringi.gagolewski.com/rapi/about_arguments.html), [`about_encoding`](https://stringi.gagolewski.com/rapi/about_encoding.html), [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_charclass`](https://stringi.gagolewski.com/rapi/about_search_charclass.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`about_search_regex`](https://stringi.gagolewski.com/rapi/about_search_regex.html), [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`about_stringi`](https://stringi.gagolewski.com/rapi/about_stringi.html)
