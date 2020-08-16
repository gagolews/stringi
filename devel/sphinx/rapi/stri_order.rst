stri_order: Ordering Permutation
================================

Description
~~~~~~~~~~~

This functions finds a permutation which rearranges the strings in a given character vector into the ascending or descending locale-dependent lexicographic order.

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
| ``opts_collator`` | a named list with ICU Collator's options, see `stri_opts_collator <stri_opts_collator.html>`__, ``NULL`` for default collation options                                                                                                |
+-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

For more information on ICU's Collator and how to tune it up in stringi, refer to `stri_opts_collator <stri_opts_collator.html>`__.

As usual in stringi, non-character inputs are coerced to strings, see an example below for a perhaps non-intitive behavior of lexicographic sorting on numeric inputs.

This function uses a stable sort algorithm (STL's ``stable_sort``), which performs up to *N*log^2(N)* element comparisons, where *N* is the length of ``str``.

Value
~~~~~

The function yields an integer vector that gives the sort order.

References
~~~~~~~~~~

*Collation* - ICU User Guide, http://userguide.icu-project.org/collation

See Also
~~~~~~~~

Other locale_sensitive: `%s<%() <oper_comparison.html>`__, `stri_compare() <stri_compare.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_duplicated() <stri_duplicated.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_sort_key() <stri_sort_key.html>`__, `stri_sort() <stri_sort.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_unique() <stri_unique.html>`__, `stri_wrap() <stri_wrap.html>`__, `stringi-locale <stringi-locale.html>`__, `stringi-search-boundaries <stringi-search-boundaries.html>`__, `stringi-search-coll <stringi-search-coll.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_order(c("hladny", "chladny"), locale="pl_PL")
   stri_order(c("hladny", "chladny"), locale="sk_SK")

   stri_order(c(1, 100, 2, 101, 11, 10))
   stri_order(c(1, 100, 2, 101, 11, 10), numeric=TRUE)
