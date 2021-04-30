stri_rank: Ranking
==================

Description
~~~~~~~~~~~

This function ranks each string in a character vector according to a locale-dependent lexicographic order. It is a portable replacement for the base ``xtfrm`` function.

Usage
~~~~~

.. code-block:: r

   stri_rank(str, ..., opts_collator = NULL)

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

Missing values result in missing ranks and tied observations receive the same ranks (based on min).

For more information on ICU's Collator and how to tune it up in stringi, refer to `stri_opts_collator <stri_opts_collator.html>`__.

Value
~~~~~

The result is a vector of ranks corresponding to each string in ``str``.

References
~~~~~~~~~~

*Collation* - ICU User Guide, http://userguide.icu-project.org/collation

See Also
~~~~~~~~

Other locale_sensitive: `%s<%() <operator_compare.html>`__, `about_locale <about_locale.html>`__, `about_search_boundaries <about_search_boundaries.html>`__, `about_search_coll <about_search_coll.html>`__, `stri_compare() <stri_compare.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_duplicated() <stri_duplicated.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_order() <stri_order.html>`__, `stri_sort_key() <stri_sort_key.html>`__, `stri_sort() <stri_sort.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_unique() <stri_unique.html>`__, `stri_wrap() <stri_wrap.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_rank(c('hladny', 'chladny'), locale='pl_PL')
   stri_rank(c('hladny', 'chladny'), locale='sk_SK')

   stri_rank("a" %s+% c(1, 100, 2, 101, 11, 10))  # lexicographic order
   stri_rank("a" %s+% c(1, 100, 2, 101, 11, 10), numeric=TRUE)

   # Ordering a data frame with respect to two criteria:
   X <- data.frame(a=c("b", NA, "b", "b", NA, "a", "a", "c"), b=runif(8))
   X[order(stri_rank(X$a), X$b), ]
