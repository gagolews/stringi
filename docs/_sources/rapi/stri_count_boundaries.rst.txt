stri_count_boundaries: Count the Number of Text Boundaries
==========================================================

Description
~~~~~~~~~~~

These functions determine the number of text boundaries (like character, word, line, or sentence boundaries) in a string.

Usage
~~~~~

.. code-block:: r

   stri_count_boundaries(str, ..., opts_brkiter = NULL)

   stri_count_words(str, locale = NULL)

Arguments
~~~~~~~~~

+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``          | character vector or an object coercible to                                                                                                                                           |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``          | additional settings for ``opts_brkiter``                                                                                                                                             |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_brkiter`` | a named list with ICU BreakIterator's settings, see `stri_opts_brkiter <stri_opts_brkiter.html>`__; ``NULL`` for the default break iterator, i.e., ``line_break``                    |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale``       | ``NULL`` or ``''`` for text boundary analysis following the conventions of the default locale, or a single string with locale identifier, see `stringi-locale <about_locale.html>`__ |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str``.

For more information on text boundary analysis performed by ICU's ``BreakIterator``, see `stringi-search-boundaries <about_search_boundaries.html>`__.

In case of ``stri_count_words``, just like in `stri_extract_all_words <stri_extract_boundaries.html>`__ and `stri_locate_all_words <stri_locate_boundaries.html>`__, ICU's word ``BreakIterator`` iterator is used to locate the word boundaries, and all non-word characters (``UBRK_WORD_NONE`` rule status) are ignored. This function is equivalent to a call to `stri_count_boundaries(str, type='word', skip_word_none=TRUE, locale=locale) <stri_count_boundaries.html>`__.

Note that a ``BreakIterator`` of type ``character`` may be used to count the number of *Unicode characters* in a string. The `stri_length <stri_length.html>`__ function, which aims to count the number of *Unicode code points*, might report different results.

Moreover, a ``BreakIterator`` of type ``sentence`` may be used to count the number of sentences in a text piece.

Value
~~~~~

Both functions return an integer vector.

See Also
~~~~~~~~

Other search_count: `about_search <about_search.html>`__, `stri_count() <stri_count.html>`__

Other locale_sensitive: `%s<%() <operator_compare.html>`__, `about_locale <about_locale.html>`__, `about_search_boundaries <about_search_boundaries.html>`__, `about_search_coll <about_search_coll.html>`__, `stri_compare() <stri_compare.html>`__, `stri_duplicated() <stri_duplicated.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_order() <stri_order.html>`__, `stri_rank() <stri_rank.html>`__, `stri_sort_key() <stri_sort_key.html>`__, `stri_sort() <stri_sort.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_unique() <stri_unique.html>`__, `stri_wrap() <stri_wrap.html>`__

Other text_boundaries: `about_search_boundaries <about_search_boundaries.html>`__, `about_search <about_search.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_brkiter() <stri_opts_brkiter.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_split_lines() <stri_split_lines.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_wrap() <stri_wrap.html>`__

Examples
~~~~~~~~

.. code-block:: r

   test <- 'The\u00a0above-mentioned    features are very useful. Spam, spam, eggs, bacon, and spam.'
   stri_count_boundaries(test, type='word')
   stri_count_boundaries(test, type='sentence')
   stri_count_boundaries(test, type='character')
   stri_count_words(test)

   test2 <- stri_trans_nfkd('\u03c0\u0153\u0119\u00a9\u00df\u2190\u2193\u2192')
   stri_count_boundaries(test2, type='character')
   stri_length(test2)
   stri_numbytes(test2)
