stri_order: Ordering Permutation
================================

Description
~~~~~~~~~~~

This function finds a permutation which rearranges the strings in a given character vector into the ascending or descending locale-dependent lexicographic order.

Usage
~~~~~

.. code-block:: r

   stri_order(str, decreasing = FALSE, na_last = TRUE, ..., opts_collator = NULL)

Arguments
~~~~~~~~~

+-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``           | a character vector                                                                                                                                                                                                                    |
+-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``decreasing``    | a single logical value; should the sort order be nondecreasing (``FALSE``, default) or nonincreasing (``TRUE``)?                                                                                                                      |
+-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``na_last``       | a single logical value; controls the treatment of ``NA``\ s in ``str``. If ``TRUE``, then missing values in ``str`` are put at the end; if ``FALSE``, they are put at the beginning; if ``NA``, then they are removed from the output |
+-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``           | additional settings for ``opts_collator``                                                                                                                                                                                             |
+-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_collator`` | a named list with ICU Collator's options, see `stri_opts_collator`_, ``NULL`` for default collation options                                                                                                                           |
+-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

For more information on ICU's Collator and how to tune it up in stringi, refer to `stri_opts_collator`_.

As usual in stringi, non-character inputs are coerced to strings, see an example below for a somewhat non-intuitive behavior of lexicographic sorting on numeric inputs.

This function uses a stable sort algorithm (STL's ``stable_sort``), which performs up to *N*log^2(N)* element comparisons, where *N* is the length of ``str``.

For ordering with regards to multiple criteria (such as sorting data frames by more than 1 column), see `stri_rank`_.

Value
~~~~~

The function yields an integer vector that gives the sort order.

References
~~~~~~~~~~

*Collation* - ICU User Guide, http://userguide.icu-project.org/collation

See Also
~~~~~~~~

Other locale_sensitive: `%s<%()`_, `about_locale`_, `about_search_boundaries`_, `about_search_coll`_, `stri_compare()`_, `stri_count_boundaries()`_, `stri_duplicated()`_, `stri_enc_detect2()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_collator()`_, `stri_rank()`_, `stri_sort_key()`_, `stri_sort()`_, `stri_split_boundaries()`_, `stri_trans_tolower()`_, `stri_unique()`_, `stri_wrap()`_

Examples
~~~~~~~~

.. code-block:: r

   stri_order(c('hladny', 'chladny'), locale='pl_PL')
   stri_order(c('hladny', 'chladny'), locale='sk_SK')

   stri_order(c(1, 100, 2, 101, 11, 10))
   stri_order(c(1, 100, 2, 101, 11, 10), numeric=TRUE)

.. _stri_opts_collator: stri_opts_collator.html
.. _stri_rank: stri_rank.html
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
.. _stri_rank(): stri_rank.html
.. _stri_sort_key(): stri_sort_key.html
.. _stri_sort(): stri_sort.html
.. _stri_split_boundaries(): stri_split_boundaries.html
.. _stri_trans_tolower(): stri_trans_casemap.html
.. _stri_unique(): stri_unique.html
.. _stri_wrap(): stri_wrap.html
