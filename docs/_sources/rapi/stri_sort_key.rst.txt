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

+-------------------+-------------------------------------------------------------------------------------------------------------+
| ``str``           | a character vector                                                                                          |
+-------------------+-------------------------------------------------------------------------------------------------------------+
| ``...``           | additional settings for ``opts_collator``                                                                   |
+-------------------+-------------------------------------------------------------------------------------------------------------+
| ``opts_collator`` | a named list with ICU Collator's options, see `stri_opts_collator`_, ``NULL`` for default collation options |
+-------------------+-------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

For more information on ICU's Collator and how to tune it up in stringi, refer to `stri_opts_collator`_.

See also `stri_rank`_ for ranking strings with a single character vector, i.e., generating relative sort keys.

Value
~~~~~

The result is a character vector with the same length as ``str`` that contains the sort keys. The output is marked as ``bytes``-encoded.

References
~~~~~~~~~~

*Collation* - ICU User Guide, http://userguide.icu-project.org/collation

See Also
~~~~~~~~

Other locale_sensitive: `%s<%()`_, `about_locale`_, `about_search_boundaries`_, `about_search_coll`_, `stri_compare()`_, `stri_count_boundaries()`_, `stri_duplicated()`_, `stri_enc_detect2()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_collator()`_, `stri_order()`_, `stri_rank()`_, `stri_sort()`_, `stri_split_boundaries()`_, `stri_trans_tolower()`_, `stri_unique()`_, `stri_wrap()`_

Examples
~~~~~~~~

.. code-block:: r

   stri_sort_key(c('hladny', 'chladny'), locale='pl_PL')
   stri_sort_key(c('hladny', 'chladny'), locale='sk_SK')

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
.. _stri_order(): stri_order.html
.. _stri_rank(): stri_rank.html
.. _stri_sort(): stri_sort.html
.. _stri_split_boundaries(): stri_split_boundaries.html
.. _stri_trans_tolower(): stri_trans_casemap.html
.. _stri_unique(): stri_unique.html
.. _stri_wrap(): stri_wrap.html
