about_search_coll: Locale-Sensitive Text Searching in stringi
=============================================================

Description
~~~~~~~~~~~

String searching facilities described here provide a way to locate a specific piece of text. Interestingly, locale-sensitive searching, especially on a non-English text, is a much more complex process than it seems at the first glance.

Locale-Aware String Search Engine
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

All ``stri_*_coll`` functions in stringi use ICU's ``StringSearch`` engine, which implements a locale-sensitive string search algorithm. The matches are defined by using the notion of “canonical equivalence” between strings.

Tuning the Collator's parameters allows you to perform correct matching that properly takes into account accented letters, conjoined letters, ignorable punctuation and letter case.

For more information on ICU's Collator and the search engine and how to tune it up in stringi, refer to `stri_opts_collator`_.

Please note that ICU's ``StringSearch``-based functions are often much slower that those to perform fixed pattern searches.

References
~~~~~~~~~~

*ICU String Search Service* – ICU User Guide, http://userguide.icu-project.org/collation/icu-string-search-service

L. Werner, *Efficient Text Searching in Java*, 1999, https://icu-project.org/docs/papers/efficient_text_searching_in_java.html

See Also
~~~~~~~~

Other search_coll: `about_search`_, `stri_opts_collator()`_

Other locale_sensitive: `%s<%()`_, `about_locale`_, `about_search_boundaries`_, `stri_compare()`_, `stri_count_boundaries()`_, `stri_duplicated()`_, `stri_enc_detect2()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_collator()`_, `stri_order()`_, `stri_rank()`_, `stri_sort_key()`_, `stri_sort()`_, `stri_split_boundaries()`_, `stri_trans_tolower()`_, `stri_unique()`_, `stri_wrap()`_

Other stringi_general_topics: `about_arguments`_, `about_encoding`_, `about_locale`_, `about_search_boundaries`_, `about_search_charclass`_, `about_search_fixed`_, `about_search_regex`_, `about_search`_, `about_stringi`_

.. _stri_opts_collator: stri_opts_collator.html
.. _about_search: about_search.html
.. _stri_opts_collator(): stri_opts_collator.html
.. _%s<%(): operator_compare.html
.. _about_locale: about_locale.html
.. _about_search_boundaries: about_search_boundaries.html
.. _stri_compare(): stri_compare.html
.. _stri_count_boundaries(): stri_count_boundaries.html
.. _stri_duplicated(): stri_duplicated.html
.. _stri_enc_detect2(): stri_enc_detect2.html
.. _stri_extract_all_boundaries(): stri_extract_boundaries.html
.. _stri_locate_all_boundaries(): stri_locate_boundaries.html
.. _stri_order(): stri_order.html
.. _stri_rank(): stri_rank.html
.. _stri_sort_key(): stri_sort_key.html
.. _stri_sort(): stri_sort.html
.. _stri_split_boundaries(): stri_split_boundaries.html
.. _stri_trans_tolower(): stri_trans_casemap.html
.. _stri_unique(): stri_unique.html
.. _stri_wrap(): stri_wrap.html
.. _about_arguments: about_arguments.html
.. _about_encoding: about_encoding.html
.. _about_search_charclass: about_search_charclass.html
.. _about_search_fixed: about_search_fixed.html
.. _about_search_regex: about_search_regex.html
.. _about_stringi: about_stringi.html
