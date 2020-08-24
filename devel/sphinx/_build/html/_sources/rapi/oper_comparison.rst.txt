oper_comparison: Compare Strings with or without Collation
==========================================================

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

+------------+-------------------------------------------------------------+
| ``e1, e2`` | character vectors or objects coercible to character vectors |
+------------+-------------------------------------------------------------+

Details
~~~~~~~

These functions call `stri_cmp_le <stri_compare.html>`__ or its friends, using the default collator options. As a consequence, they are vectorized over ``e1`` and ``e2``.

``%stri==%`` tests for canonical equivalence of strings (see `stri_cmp_equiv <stri_compare.html>`__) and is a locale-dependent operation.

``%stri===%`` performs a locale-independent, code point-based comparison.

Value
~~~~~

All the functions return a logical vector indicating the result of a pairwise comparison. As usual, the elements of shorter vectors are recycled if necessary.

See Also
~~~~~~~~

Other locale_sensitive: `stri_compare() <stri_compare.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_duplicated() <stri_duplicated.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_order() <stri_order.html>`__, `stri_sort_key() <stri_sort_key.html>`__, `stri_sort() <stri_sort.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_unique() <stri_unique.html>`__, `stri_wrap() <stri_wrap.html>`__, `stringi-locale <stringi-locale.html>`__, `stringi-search-boundaries <stringi-search-boundaries.html>`__, `stringi-search-coll <stringi-search-coll.html>`__

Examples
~~~~~~~~

.. code-block:: r

   'a' %stri<% 'b'
   c('a', 'b', 'c') %stri>=% 'b'

