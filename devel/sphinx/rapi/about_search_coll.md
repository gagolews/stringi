# about\_search\_coll: Locale-Sensitive Text Searching in <span class="pkg">stringi</span>

## Description

String searching facilities described here provide a way to locate a specific piece of text. Interestingly, locale-sensitive searching, especially on a non-English text, is a much more complex process than it seems at the first glance.

## Locale-Aware String Search Engine

All `stri_*_coll` functions in <span class="pkg">stringi</span> use <span class="pkg">ICU</span>\'s `StringSearch` engine, which implements a locale-sensitive string search algorithm. The matches are defined by using the notion of "canonical equivalence" between strings.

Tuning the Collator\'s parameters allows you to perform correct matching that properly takes into account accented letters, conjoined letters, ignorable punctuation and letter case.

For more information on <span class="pkg">ICU</span>\'s Collator and the search engine and how to tune it up in <span class="pkg">stringi</span>, refer to [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html).

Please note that <span class="pkg">ICU</span>\'s `StringSearch`-based functions are often much slower that those to perform fixed pattern searches.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*ICU String Search Service* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/collation/string-search.html>

L. Werner, *Efficient Text Searching in Java*, 1999, <https://icu-project.org/docs/papers/efficient_text_searching_in_java.html>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other search\_coll: [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)()

Other locale\_sensitive: `%s<%()`, [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

Other stringi\_general\_topics: [`about_arguments`](https://stringi.gagolewski.com/rapi/about_arguments.html), [`about_encoding`](https://stringi.gagolewski.com/rapi/about_encoding.html), [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_charclass`](https://stringi.gagolewski.com/rapi/about_search_charclass.html), [`about_search_fixed`](https://stringi.gagolewski.com/rapi/about_search_fixed.html), [`about_search_regex`](https://stringi.gagolewski.com/rapi/about_search_regex.html), [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`about_stringi`](https://stringi.gagolewski.com/rapi/about_stringi.html)
