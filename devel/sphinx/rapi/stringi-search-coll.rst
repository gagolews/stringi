stringi-search-coll: Locale-Sensitive Text Searching in stringi
===============================================================

Description
~~~~~~~~~~~

String searching facilities described here provide a way to locate a specific piece of text. Interestingly, locale-sensitive searching, especially on a non-English text, is a much more complex process than it seems at the first glance.

Locale-Aware String Search Engine
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

All ``stri_*_coll`` functions in stringi use ICU's ``StringSearch`` engine, which implements a locale-sensitive string search algorithm. The matches are defined by using the notion of “canonical equivalence” between strings.

Tuning the Collator's parameters allows you to perform correct matching that properly takes into account accented letters, conjoined letters, ignorable punctuation and letter case.

For more information on ICU's Collator and the search engine and how to tune it up in stringi, refer to `stri_opts_collator <stri_opts_collator.html>`__.

Please note that ICU's ``StringSearch``-based functions are often much slower that those to perform fixed pattern searches.

References
~~~~~~~~~~

*ICU String Search Service* – ICU User Guide, http://userguide.icu-project.org/collation/icu-string-search-service

L. Werner, *Efficient Text Searching in Java*, 1999, http://icu-project.org/docs/papers/efficient_text_searching_in_java.html

See Also
~~~~~~~~

Other search_coll: `stri_opts_collator() <stri_opts_collator.html>`__, `stringi-search <stringi-search.html>`__

Other locale_sensitive: `%s<%() <oper_comparison.html>`__, `stri_compare() <stri_compare.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_duplicated() <stri_duplicated.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_order() <stri_order.html>`__, `stri_sort_key() <stri_sort_key.html>`__, `stri_sort() <stri_sort.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_unique() <stri_unique.html>`__, `stri_wrap() <stri_wrap.html>`__, `stringi-locale <stringi-locale.html>`__, `stringi-search-boundaries <stringi-search-boundaries.html>`__

Other stringi_general_topics: `stringi-arguments <stringi-arguments.html>`__, `stringi-encoding <stringi-encoding.html>`__, `stringi-locale <stringi-locale.html>`__, `stringi-package <stringi-package.html>`__, `stringi-search-boundaries <stringi-search-boundaries.html>`__, `stringi-search-charclass <stringi-search-charclass.html>`__, `stringi-search-fixed <stringi-search-fixed.html>`__, `stringi-search-regex <stringi-search-regex.html>`__, `stringi-search <stringi-search.html>`__
