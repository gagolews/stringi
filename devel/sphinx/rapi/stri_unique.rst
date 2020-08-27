stri_unique: Extract Unique Elements
====================================

Description
~~~~~~~~~~~

This function returns a character vector like ``str``, but with duplicate elements removed.

Usage
~~~~~

.. code-block:: r

   stri_unique(str, ..., opts_collator = NULL)

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

As usual in stringi, no attributes are copied. Unlike ``unique``, this function tests for canonical equivalence of strings (and not whether the strings are just bytewise equal). Such an operation is locale-dependent. Hence, ``stri_unique`` is significantly slower (but much better suited for natural language processing) than its base R counterpart.

See also `stri_duplicated <stri_duplicated.html>`__ for indicating non-unique elements.

Value
~~~~~

Returns a character vector.

References
~~~~~~~~~~

*Collation* - ICU User Guide, http://userguide.icu-project.org/collation

See Also
~~~~~~~~

Other locale_sensitive: `%s<%() <operator_compare.html>`__, `about_locale <about_locale.html>`__, `about_search_boundaries <about_search_boundaries.html>`__, `about_search_coll <about_search_coll.html>`__, `stri_compare() <stri_compare.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_duplicated() <stri_duplicated.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_order() <stri_order.html>`__, `stri_sort_key() <stri_sort_key.html>`__, `stri_sort() <stri_sort.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_wrap() <stri_wrap.html>`__

Examples
~~~~~~~~

.. code-block:: r

   # normalized and non-Unicode-normalized version of the same code point:
   stri_unique(c('\u0105', stri_trans_nfkd('\u0105')))
   unique(c('\u0105', stri_trans_nfkd('\u0105')))

   stri_unique(c('gro\u00df', 'GROSS', 'Gro\u00df', 'Gross'), strength=1)

