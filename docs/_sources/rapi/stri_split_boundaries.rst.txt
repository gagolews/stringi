stri_split_boundaries: Split a String at Text Boundaries
========================================================

Description
~~~~~~~~~~~

This function locates text boundaries (like character, word, line, or sentence boundaries) and splits strings at the indicated positions.

Usage
~~~~~

.. code-block:: r

   stri_split_boundaries(
     str,
     n = -1L,
     tokens_only = FALSE,
     simplify = FALSE,
     ...,
     opts_brkiter = NULL
   )

Arguments
~~~~~~~~~

+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``          | character vector or an object coercible to                                                                                                                        |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``n``            | integer vector, maximal number of strings to return                                                                                                               |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``tokens_only``  | single logical value; may affect the result if ``n`` is positive, see Details                                                                                     |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``simplify``     | single logical value; if ``TRUE`` or ``NA``, then a character matrix is returned; otherwise (the default), a list of character vectors is given, see Value        |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``          | additional settings for ``opts_brkiter``                                                                                                                          |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_brkiter`` | a named list with ICU BreakIterator's settings, see `stri_opts_brkiter <stri_opts_brkiter.html>`__; ``NULL`` for the default break iterator, i.e., ``line_break`` |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str`` and ``n``.

If ``n`` is negative (the default), then all text pieces are extracted.

Otherwise, if ``tokens_only`` is ``FALSE`` (this is the default, for compatibility with the stringr package), then ``n-1`` tokens are extracted (if possible) and the ``n``-th string gives the (non-split) remainder (see Examples). On the other hand, if ``tokens_only`` is ``TRUE``, then only full tokens (up to ``n`` pieces) are extracted.

For more information on text boundary analysis performed by ICU's ``BreakIterator``, see `stringi-search-boundaries <about_search_boundaries.html>`__.

Value
~~~~~

If ``simplify=FALSE`` (the default), then the functions return a list of character vectors.

Otherwise, `stri_list2matrix <stri_list2matrix.html>`__ with ``byrow=TRUE`` and ``n_min=n`` arguments is called on the resulting object. In such a case, a character matrix with ``length(str)`` rows is returned. Note that `stri_list2matrix <stri_list2matrix.html>`__'s ``fill`` argument is set to an empty string and ``NA``, for ``simplify`` equal to ``TRUE`` and ``NA``, respectively.

See Also
~~~~~~~~

Other search_split: `about_search <about_search.html>`__, `stri_split_lines() <stri_split_lines.html>`__, `stri_split() <stri_split.html>`__

Other locale_sensitive: `%s<%() <operator_compare.html>`__, `about_locale <about_locale.html>`__, `about_search_boundaries <about_search_boundaries.html>`__, `about_search_coll <about_search_coll.html>`__, `stri_compare() <stri_compare.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_duplicated() <stri_duplicated.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_order() <stri_order.html>`__, `stri_sort_key() <stri_sort_key.html>`__, `stri_sort() <stri_sort.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_unique() <stri_unique.html>`__, `stri_wrap() <stri_wrap.html>`__

Other text_boundaries: `about_search_boundaries <about_search_boundaries.html>`__, `about_search <about_search.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_brkiter() <stri_opts_brkiter.html>`__, `stri_split_lines() <stri_split_lines.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_wrap() <stri_wrap.html>`__

Examples
~~~~~~~~

.. code-block:: r

   test <- 'The\u00a0above-mentioned    features are very useful. ' %s+%
      'Spam, spam, eggs, bacon, and spam. 123 456 789'
   stri_split_boundaries(test, type='line')
   stri_split_boundaries(test, type='word')
   stri_split_boundaries(test, type='word', skip_word_none=TRUE)
   stri_split_boundaries(test, type='word', skip_word_none=TRUE, skip_word_letter=TRUE)
   stri_split_boundaries(test, type='word', skip_word_none=TRUE, skip_word_number=TRUE)
   stri_split_boundaries(test, type='sentence')
   stri_split_boundaries(test, type='sentence', skip_sentence_sep=TRUE)
   stri_split_boundaries(test, type='character')

   # a filtered break iterator with the new ICU:
   stri_split_boundaries('Mr. Jones and Mrs. Brown are very happy.
   So am I, Prof. Smith.', type='sentence', locale='en_US@ss=standard') # ICU >= 56 only
