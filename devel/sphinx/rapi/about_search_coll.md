# about_search_coll: Locale-Sensitive Text Searching in <span class="pkg">stringi</span>

## Description

String searching facilities described here provide a way to locate a specific piece of text. Interestingly, locale-sensitive searching, especially on a non-English text, is a much more complex process than it seems at the first glance.

## Locale-Aware String Search Engine

All `stri_*_coll` functions in <span class="pkg">stringi</span> use <span class="pkg">ICU</span>\'s `StringSearch` engine, which implements a locale-sensitive string search algorithm. The matches are defined by using the notion of "canonical equivalence" between strings.

Tuning the Collator\'s parameters allows you to perform correct matching that properly takes into account accented letters, conjoined letters, ignorable punctuation and letter case.

For more information on <span class="pkg">ICU</span>\'s Collator and the search engine and how to tune it up in <span class="pkg">stringi</span>, refer to [`stri_opts_collator`](stri_opts_collator.md).

Please note that <span class="pkg">ICU</span>\'s `StringSearch`-based functions are often much slower that those to perform fixed pattern searches.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*ICU String Search Service* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/collation/string-search.html>

L. Werner, *Efficient Text Searching in Java*, 1999, <https://icu-project.org/docs/papers/efficient_text_searching_in_java.html>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other search_coll: [`about_search`](about_search.md), [`stri_opts_collator()`](stri_opts_collator.md)

Other locale_sensitive: [`%s<%()`](+25s+3C+25.md), [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`stri_compare()`](stri_compare.md), [`stri_count_boundaries()`](stri_count_boundaries.md), [`stri_duplicated()`](stri_duplicated.md), [`stri_enc_detect2()`](stri_enc_detect2.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_opts_collator()`](stri_opts_collator.md), [`stri_order()`](stri_order.md), [`stri_rank()`](stri_rank.md), [`stri_sort_key()`](stri_sort_key.md), [`stri_sort()`](stri_sort.md), [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_trans_tolower()`](stri_trans_casemap.md), [`stri_unique()`](stri_unique.md), [`stri_wrap()`](stri_wrap.md)

Other stringi_general_topics: [`about_arguments`](about_arguments.md), [`about_encoding`](about_encoding.md), [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_charclass`](about_search_charclass.md), [`about_search_fixed`](about_search_fixed.md), [`about_search_regex`](about_search_regex.md), [`about_search`](about_search.md), [`about_stringi`](about_stringi.md)
