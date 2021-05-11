operator_compare: Compare Strings with or without Collation
===========================================================

Description
~~~~~~~~~~~

Relational operators for comparing corresponding strings in two character vectors, with a typical R look-and-feel.

Usage
~~~~~

.. code-block:: r

   e1 %s<% e2

   e1 %s<=% e2

   e1 %s>% e2

   e1 %s>=% e2

   e1 %s==% e2

   e1 %s!=% e2

   e1 %s===% e2

   e1 %s!==% e2

   e1 %stri<% e2

   e1 %stri<=% e2

   e1 %stri>% e2

   e1 %stri>=% e2

   e1 %stri==% e2

   e1 %stri!=% e2

   e1 %stri===% e2

   e1 %stri!==% e2

Arguments
~~~~~~~~~

========== ===========================================================
``e1, e2`` character vectors or objects coercible to character vectors
========== ===========================================================

Details
~~~~~~~

These functions call `stri_cmp_le`_ or its friends, using the default collator options. As a consequence, they are vectorized over ``e1`` and ``e2``.

``%stri==%`` tests for canonical equivalence of strings (see `stri_cmp_equiv`_) and is a locale-dependent operation.

``%stri===%`` performs a locale-independent, code point-based comparison.

Value
~~~~~

All the functions return a logical vector indicating the result of a pairwise comparison. As usual, the elements of shorter vectors are recycled if necessary.

See Also
~~~~~~~~

Other locale_sensitive: `about_locale`_, `about_search_boundaries`_, `about_search_coll`_, `stri_compare()`_, `stri_count_boundaries()`_, `stri_duplicated()`_, `stri_enc_detect2()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_collator()`_, `stri_order()`_, `stri_rank()`_, `stri_sort_key()`_, `stri_sort()`_, `stri_split_boundaries()`_, `stri_trans_tolower()`_, `stri_unique()`_, `stri_wrap()`_

Examples
~~~~~~~~

.. code-block:: r

   'a' %stri<% 'b'
   c('a', 'b', 'c') %stri>=% 'b'

.. _stri_cmp_le: stri_compare.html
.. _stri_cmp_equiv: stri_compare.html
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
.. _stri_unique(): stri_unique.html
.. _stri_wrap(): stri_wrap.html
