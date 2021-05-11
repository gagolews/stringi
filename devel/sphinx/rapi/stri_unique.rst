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

+-------------------+-------------------------------------------------------------------------------------------------------------+
| ``str``           | a character vector                                                                                          |
+-------------------+-------------------------------------------------------------------------------------------------------------+
| ``...``           | additional settings for ``opts_collator``                                                                   |
+-------------------+-------------------------------------------------------------------------------------------------------------+
| ``opts_collator`` | a named list with ICU Collator's options, see `stri_opts_collator`_, ``NULL`` for default collation options |
+-------------------+-------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

As usual in stringi, no attributes are copied. Unlike `unique`_, this function tests for canonical equivalence of strings (and not whether the strings are just bytewise equal). Such an operation is locale-dependent. Hence, ``stri_unique`` is significantly slower (but much better suited for natural language processing) than its base R counterpart.

See also `stri_duplicated`_ for indicating non-unique elements.

Value
~~~~~

Returns a character vector.

References
~~~~~~~~~~

*Collation* - ICU User Guide, http://userguide.icu-project.org/collation

See Also
~~~~~~~~

Other locale_sensitive: `%s<%()`_, `about_locale`_, `about_search_boundaries`_, `about_search_coll`_, `stri_compare()`_, `stri_count_boundaries()`_, `stri_duplicated()`_, `stri_enc_detect2()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_collator()`_, `stri_order()`_, `stri_rank()`_, `stri_sort_key()`_, `stri_sort()`_, `stri_split_boundaries()`_, `stri_trans_tolower()`_, `stri_wrap()`_

Examples
~~~~~~~~

.. code-block:: r

   # normalized and non-Unicode-normalized version of the same code point:
   stri_unique(c('\u0105', stri_trans_nfkd('\u0105')))
   unique(c('\u0105', stri_trans_nfkd('\u0105')))

   stri_unique(c('gro\u00df', 'GROSS', 'Gro\u00df', 'Gross'), strength=1)

.. _stri_opts_collator: stri_opts_collator.html
.. _unique: https://stat.ethz.ch/R-manual/R-patched/library/base/html/unique.html
.. _stri_duplicated: stri_duplicated.html
.. _%s<%(): operator_compare.html
.. _about_locale: about_locale.html
.. _about_search_boundaries: about_search_boundaries.html
.. _about_search_coll: about_search_coll.html
.. _stri_compare(): stri_compare.html
.. _stri_count_boundaries(): stri_count_boundaries.html
.. _stri_duplicated(): stri_duplicated.html
.. _stri_enc_detect2(): stri_enc_detect2.html
.. _stri_extract_all_boundaries(): stri_extract_boundaries.html
.. _stri_locate_all_boundaries(): stri_locate_boundaries.html
.. _stri_opts_collator(): stri_opts_collator.html
.. _stri_order(): stri_order.html
.. _stri_rank(): stri_rank.html
.. _stri_sort_key(): stri_sort_key.html
.. _stri_sort(): stri_sort.html
.. _stri_split_boundaries(): stri_split_boundaries.html
.. _stri_trans_tolower(): stri_trans_casemap.html
.. _stri_wrap(): stri_wrap.html
