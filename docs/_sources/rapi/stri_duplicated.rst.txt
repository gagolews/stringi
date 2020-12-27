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

+-------------------+----------------------------------------------------------------------------------------------------------------------------------------+
| ``str``           | a character vector                                                                                                                     |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------+
| ``from_last``     | a single logical value; indicates whether search should be performed from the last to the first string                                 |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------+
| ``fromLast``      | [DEPRECATED] alias of ``from_last``                                                                                                    |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------+
| ``...``           | additional settings for ``opts_collator``                                                                                              |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_collator`` | a named list with ICU Collator's options, see `stri_opts_collator <stri_opts_collator.html>`__, ``NULL`` for default collation options |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Missing values are regarded as equal.

Unlike ``duplicated`` and ``anyDuplicated``, these functions test for canonical equivalence of strings (and not whether the strings are just bytewise equal) Such operations are locale-dependent. Hence, ``stri_duplicated`` and ``stri_duplicated_any`` are significantly slower (but much better suited for natural language processing) than their base R counterparts.

See also `stri_unique <stri_unique.html>`__ for extracting unique elements.

Value
~~~~~

``stri_duplicated()`` returns a logical vector of the same length as ``str``. Each of its elements indicates whether a canonically equivalent string was already found in ``str``.

``stri_duplicated_any()`` returns a single non-negative integer. Value of 0 indicates that all the elements in ``str`` are unique. Otherwise, it gives the index of the first non-unique element.

References
~~~~~~~~~~

*Collation* - ICU User Guide, http://userguide.icu-project.org/collation

See Also
~~~~~~~~

Other locale_sensitive: `%s<%() <operator_compare.html>`__, `about_locale <about_locale.html>`__, `about_search_boundaries <about_search_boundaries.html>`__, `about_search_coll <about_search_coll.html>`__, `stri_compare() <stri_compare.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_order() <stri_order.html>`__, `stri_sort_key() <stri_sort_key.html>`__, `stri_sort() <stri_sort.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_unique() <stri_unique.html>`__, `stri_wrap() <stri_wrap.html>`__

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
