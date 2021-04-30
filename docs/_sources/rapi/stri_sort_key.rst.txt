stri_sort_key: Sort Keys
========================

Description
~~~~~~~~~~~

This function computes a locale-dependent sort key, which is an alternative character representation of the string that, when ordered in the C locale (which orders using the underlying bytes directly), will give an equivalent ordering to the original string. It is useful for enhancing algorithms that sort only in the C locale (e.g., the ``strcmp`` function in libc) with the ability to be locale-aware.

Usage
~~~~~

.. code-block:: r

   stri_sort_key(str, ..., opts_collator = NULL)

Arguments
~~~~~~~~~

+-------------------+----------------------------------------------------------------------------------------------------------------------------------------+
| ``str``           | a character vector                                                                                                                     |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------+
| ``...``           | additional settings for ``opts_collator``                                                                                              |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_collator`` | a named list with ICU Collator's options, see `stri_opts_collator <stri_opts_collator.html>`__, ``NULL`` for default collation options |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

For more information on ICU's Collator and how to tune it up in stringi, refer to `stri_opts_collator <stri_opts_collator.html>`__.

See also `stri_rank <stri_rank.html>`__ for ranking strings with a single character vector, i.e., generating relative sort keys.

Value
~~~~~

The result is a character vector with the same length as ``str`` that contains the sort keys. The output is marked as ``bytes``-encoded.

References
~~~~~~~~~~

*Collation* - ICU User Guide, http://userguide.icu-project.org/collation

See Also
~~~~~~~~

Other locale_sensitive: `%s<%() <operator_compare.html>`__, `about_locale <about_locale.html>`__, `about_search_boundaries <about_search_boundaries.html>`__, `about_search_coll <about_search_coll.html>`__, `stri_compare() <stri_compare.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_duplicated() <stri_duplicated.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_order() <stri_order.html>`__, `stri_rank() <stri_rank.html>`__, `stri_sort() <stri_sort.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_unique() <stri_unique.html>`__, `stri_wrap() <stri_wrap.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_sort_key(c('hladny', 'chladny'), locale='pl_PL')
   stri_sort_key(c('hladny', 'chladny'), locale='sk_SK')
