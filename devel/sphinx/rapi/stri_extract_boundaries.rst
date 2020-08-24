stri_extract_boundaries: Extract Data Between Text Boundaries
=============================================================

Description
~~~~~~~~~~~

These functions extract data between text boundaries.

Usage
~~~~~

.. code-block:: r

   stri_extract_all_boundaries(
     str,
     simplify = FALSE,
     omit_no_match = FALSE,
     ...,
     opts_brkiter = NULL
   )

   stri_extract_last_boundaries(str, ..., opts_brkiter = NULL)

   stri_extract_first_boundaries(str, ..., opts_brkiter = NULL)

   stri_extract_all_words(
     str,
     simplify = FALSE,
     omit_no_match = FALSE,
     locale = NULL
   )

   stri_extract_first_words(str, locale = NULL)

   stri_extract_last_words(str, locale = NULL)

Arguments
~~~~~~~~~

+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``           | character vector or an object coercible to                                                                                                                                             |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``simplify``      | single logical value; if ``TRUE`` or ``NA``, then a character matrix is returned; otherwise (the default), a list of character vectors is given, see Value                             |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``omit_no_match`` | single logical value; if ``FALSE``, then a missing value will indicate that there are no words                                                                                         |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``           | additional settings for ``opts_brkiter``                                                                                                                                               |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_brkiter``  | a named list with ICU BreakIterator's settings, see `stri_opts_brkiter <stri_opts_brkiter.html>`__; ``NULL`` for the default break iterator, i.e., ``line_break``                      |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale``        | ``NULL`` or ``''`` for text boundary analysis following the conventions of the default locale, or a single string with locale identifier, see `stringi-locale <stringi-locale.html>`__ |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str``.

For more information on text boundary analysis performed by ICU's ``BreakIterator``, see `stringi-search-boundaries <stringi-search-boundaries.html>`__.

In case of ``stri_extract_*_words``, just like in `stri_count_words <stri_count_boundaries.html>`__, ICU's word ``BreakIterator`` iterator is used to locate the word boundaries, and all non-word characters (``UBRK_WORD_NONE`` rule status) are ignored.

Value
~~~~~

For ``stri_extract_all_*``, if ``simplify=FALSE`` (the default), then a list of character vectors is returned. Each string consists of a separate word. In case of ``omit_no_match=FALSE`` and if there are no words or if a string is missing, a single ``NA`` is provided on output.

Otherwise, `stri_list2matrix <stri_list2matrix.html>`__ with ``byrow=TRUE`` argument is called on the resulting object. In such a case, a character matrix with ``length(str)`` rows is returned. Note that `stri_list2matrix <stri_list2matrix.html>`__'s ``fill`` argument is set to an empty string and ``NA``, for ``simplify`` ``TRUE`` and ``NA``, respectively.

For ``stri_extract_first_*`` and ``stri_extract_last_*``, a character vector is returned. A ``NA`` element indicates a no-match.

See Also
~~~~~~~~

Other search_extract: `stri_extract_all() <stri_extract.html>`__, `stri_match_all() <stri_match.html>`__, `stringi-search <stringi-search.html>`__

Other locale_sensitive: `%s<%() <oper_comparison.html>`__, `stri_compare() <stri_compare.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_duplicated() <stri_duplicated.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_order() <stri_order.html>`__, `stri_sort_key() <stri_sort_key.html>`__, `stri_sort() <stri_sort.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_unique() <stri_unique.html>`__, `stri_wrap() <stri_wrap.html>`__, `stringi-locale <stringi-locale.html>`__, `stringi-search-boundaries <stringi-search-boundaries.html>`__, `stringi-search-coll <stringi-search-coll.html>`__

Other text_boundaries: `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_brkiter() <stri_opts_brkiter.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_split_lines() <stri_split_lines.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_wrap() <stri_wrap.html>`__, `stringi-search-boundaries <stringi-search-boundaries.html>`__, `stringi-search <stringi-search.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_extract_all_words('stringi: THE string processing package 123.48...')

