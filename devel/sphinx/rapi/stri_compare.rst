stri_compare: Compare Strings with or without Collation
=======================================================

Description
~~~~~~~~~~~

These functions may be used to determine if two strings are equal, canonically equivalent (this is performed in a much more clever fashion than when testing for equality), or to check whether they are in a specific lexicographic order.

Usage
~~~~~

.. code-block:: r

   stri_compare(e1, e2, ..., opts_collator = NULL)

   stri_cmp(e1, e2, ..., opts_collator = NULL)

   stri_cmp_eq(e1, e2)

   stri_cmp_neq(e1, e2)

   stri_cmp_equiv(e1, e2, ..., opts_collator = NULL)

   stri_cmp_nequiv(e1, e2, ..., opts_collator = NULL)

   stri_cmp_lt(e1, e2, ..., opts_collator = NULL)

   stri_cmp_gt(e1, e2, ..., opts_collator = NULL)

   stri_cmp_le(e1, e2, ..., opts_collator = NULL)

   stri_cmp_ge(e1, e2, ..., opts_collator = NULL)

Arguments
~~~~~~~~~

+-------------------+---------------------------------------------------------------------------------------------------------------------------------------------+
| ``e1, e2``        | character vectors or objects coercible to character vectors                                                                                 |
+-------------------+---------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``           | additional settings for ``opts_collator``                                                                                                   |
+-------------------+---------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_collator`` | a named list with ICU Collator's options, see `stri_opts_collator <stri_opts_collator.html>`__, ``NULL`` for the default collation options. |
+-------------------+---------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

All the functions listed here are vectorized over ``e1`` and ``e2``.

``stri_cmp_eq`` tests whether two corresponding strings consist of exactly the same code points, while ``stri_cmp_neq`` allows to check whether there is any difference between them. These are locale-independent operations: for natural language processing, where the notion of canonical equivalence is more valid, this might not be exactly what you are looking for, see Examples. Please note that stringi always silently removes UTF-8 BOMs from input strings, therefore, e.g., ``stri_cmp_eq`` does not take BOMs into account while comparing strings.

``stri_cmp_equiv`` tests for canonical equivalence of two strings and is locale-dependent. Additionally, the ICU's Collator may be tuned up so that, e.g., the comparison is case-insensitive. To test whether two strings are not canonically equivalent, call ``stri_cmp_nequiv``.

``stri_cmp_le`` tests whether the elements in the first vector are less than or equal to the corresponding elements in the second vector, ``stri_cmp_ge`` tests whether they are greater or equal, ``stri_cmp_lt`` if less, and ``stri_cmp_gt`` if greater, see also, e.g., `%s<% <operator_compare.html>`__.

``stri_compare`` is an alias to ``stri_cmp``. They both perform exactly the same locale-dependent operation. Both functions provide a C library's ``strcmp()`` look-and-feel, see Value for details.

For more information on ICU's Collator and how to tune its settings refer to `stri_opts_collator <stri_opts_collator.html>`__. Note that different locale settings may lead to different results (see the examples below).

Value
~~~~~

The ``stri_cmp`` and ``stri_compare`` functions return an integer vector representing the comparison results: ``-1`` if ``e1[...] < e2[...]``, ``0`` if they are canonically equivalent, and ``1`` if greater.

All the other functions return a logical vector that indicates whether a given relation holds between two corresponding elements in ``e1`` and ``e2``.

References
~~~~~~~~~~

*Collation* - ICU User Guide, http://userguide.icu-project.org/collation

See Also
~~~~~~~~

Other locale_sensitive: `%s<%() <operator_compare.html>`__, `about_locale <about_locale.html>`__, `about_search_boundaries <about_search_boundaries.html>`__, `about_search_coll <about_search_coll.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_duplicated() <stri_duplicated.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_order() <stri_order.html>`__, `stri_rank() <stri_rank.html>`__, `stri_sort_key() <stri_sort_key.html>`__, `stri_sort() <stri_sort.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_unique() <stri_unique.html>`__, `stri_wrap() <stri_wrap.html>`__

Examples
~~~~~~~~

.. code-block:: r

   # in Polish, ch < h:
   stri_cmp_lt('hladny', 'chladny', locale='pl_PL')

   # in Slovak, ch > h:
   stri_cmp_lt('hladny', 'chladny', locale='sk_SK')

   # < or > (depends on locale):
   stri_cmp('hladny', 'chladny')

   # ignore case differences:
   stri_cmp_equiv('hladny', 'HLADNY', strength=2)

   # also ignore diacritical differences:
   stri_cmp_equiv('hladn\u00FD', 'hladny', strength=1, locale='sk_SK')

   marios <- c('Mario', 'mario', 'M\\u00e1rio', 'm\\u00e1rio')
   stri_cmp_equiv(marios, 'mario', case_level=TRUE, strength=2L)
   stri_cmp_equiv(marios, 'mario', case_level=TRUE, strength=1L)
   stri_cmp_equiv(marios, 'mario', strength=1L)
   stri_cmp_equiv(marios, 'mario', strength=2L)

   # non-Unicode-normalized vs normalized string:
   stri_cmp_equiv(stri_trans_nfkd('\u0105'), '\u105')

   # note the difference:
   stri_cmp_eq(stri_trans_nfkd('\u0105'), '\u105')

   # ligatures:
   stri_cmp_equiv('\ufb00', 'ff', strength=2)

   # phonebook collation
   stri_cmp_equiv('G\u00e4rtner', 'Gaertner', locale='de_DE@collation=phonebook', strength=1L)
   stri_cmp_equiv('G\u00e4rtner', 'Gaertner', locale='de_DE', strength=1L)
