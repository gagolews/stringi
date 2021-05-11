stri_duplicated: Determine Duplicated Elements
==============================================

Description
~~~~~~~~~~~

``stri_duplicated()`` determines which strings in a character vector are duplicates of other elements.

``stri_duplicated_any()`` determines if there are any duplicated strings in a character vector.

Usage
~~~~~

.. code-block:: r

   stri_duplicated(
     str,
     from_last = FALSE,
     fromLast = from_last,
     ...,
     opts_collator = NULL
   )

   stri_duplicated_any(
     str,
     from_last = FALSE,
     fromLast = from_last,
     ...,
     opts_collator = NULL
   )

Arguments
~~~~~~~~~

+-------------------+-------------------------------------------------------------------------------------------------------------+
| ``str``           | a character vector                                                                                          |
+-------------------+-------------------------------------------------------------------------------------------------------------+
| ``from_last``     | a single logical value; indicates whether search should be performed from the last to the first string      |
+-------------------+-------------------------------------------------------------------------------------------------------------+
| ``fromLast``      | [DEPRECATED] alias of ``from_last``                                                                         |
+-------------------+-------------------------------------------------------------------------------------------------------------+
| ``...``           | additional settings for ``opts_collator``                                                                   |
+-------------------+-------------------------------------------------------------------------------------------------------------+
| ``opts_collator`` | a named list with ICU Collator's options, see `stri_opts_collator`_, ``NULL`` for default collation options |
+-------------------+-------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Missing values are regarded as equal.

Unlike `duplicated`_ and `anyDuplicated`_, these functions test for canonical equivalence of strings (and not whether the strings are just bytewise equal) Such operations are locale-dependent. Hence, ``stri_duplicated`` and ``stri_duplicated_any`` are significantly slower (but much better suited for natural language processing) than their base R counterparts.

See also `stri_unique`_ for extracting unique elements.

Value
~~~~~

``stri_duplicated()`` returns a logical vector of the same length as ``str``. Each of its elements indicates whether a canonically equivalent string was already found in ``str``.

``stri_duplicated_any()`` returns a single non-negative integer. Value of 0 indicates that all the elements in ``str`` are unique. Otherwise, it gives the index of the first non-unique element.

References
~~~~~~~~~~

*Collation* - ICU User Guide, http://userguide.icu-project.org/collation

See Also
~~~~~~~~

Other locale_sensitive: `%s<%()`_, `about_locale`_, `about_search_boundaries`_, `about_search_coll`_, `stri_compare()`_, `stri_count_boundaries()`_, `stri_enc_detect2()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_collator()`_, `stri_order()`_, `stri_rank()`_, `stri_sort_key()`_, `stri_sort()`_, `stri_split_boundaries()`_, `stri_trans_tolower()`_, `stri_unique()`_, `stri_wrap()`_

Examples
~~~~~~~~

.. code-block:: r

   # In the following examples, we have 3 duplicated values,
   # 'a' - 2 times, NA - 1 time
   stri_duplicated(c('a', 'b', 'a', NA, 'a', NA))
   stri_duplicated(c('a', 'b', 'a', NA, 'a', NA), from_last=TRUE)
   stri_duplicated_any(c('a', 'b', 'a', NA, 'a', NA))

   # compare the results:
   stri_duplicated(c('\u0105', stri_trans_nfkd('\u0105')))
   duplicated(c('\u0105', stri_trans_nfkd('\u0105')))

   stri_duplicated(c('gro\u00df', 'GROSS', 'Gro\u00df', 'Gross'), strength=1)
   duplicated(c('gro\u00df', 'GROSS', 'Gro\u00df', 'Gross'))

.. _stri_opts_collator: stri_opts_collator.html
.. _duplicated: https://stat.ethz.ch/R-manual/R-patched/library/base/html/duplicated.html
.. _anyDuplicated: https://stat.ethz.ch/R-manual/R-patched/library/base/html/duplicated.html
.. _stri_unique: stri_unique.html
.. _%s<%(): operator_compare.html
.. _about_locale: about_locale.html
.. _about_search_boundaries: about_search_boundaries.html
.. _about_search_coll: about_search_coll.html
.. _stri_compare(): stri_compare.html
.. _stri_count_boundaries(): stri_count_boundaries.html
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
.. _stri_unique(): stri_unique.html
.. _stri_wrap(): stri_wrap.html
