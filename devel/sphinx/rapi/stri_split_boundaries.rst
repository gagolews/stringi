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

+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``          | character vector or an object coercible to                                                                                                                 |
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``n``            | integer vector, maximal number of strings to return                                                                                                        |
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``tokens_only``  | single logical value; may affect the result if ``n`` is positive, see Details                                                                              |
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``simplify``     | single logical value; if ``TRUE`` or ``NA``, then a character matrix is returned; otherwise (the default), a list of character vectors is given, see Value |
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``          | additional settings for ``opts_brkiter``                                                                                                                   |
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_brkiter`` | a named list with ICU BreakIterator's settings, see `stri_opts_brkiter`_; ``NULL`` for the default break iterator, i.e., ``line_break``                    |
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str`` and ``n``.

If ``n`` is negative (the default), then all text pieces are extracted.

Otherwise, if ``tokens_only`` is ``FALSE`` (which is the default), then ``n-1`` tokens are extracted (if possible) and the ``n``-th string gives the (non-split) remainder (see Examples). On the other hand, if ``tokens_only`` is ``TRUE``, then only full tokens (up to ``n`` pieces) are extracted.

For more information on text boundary analysis performed by ICU's ``BreakIterator``, see `stringi-search-boundaries`_.

Value
~~~~~

If ``simplify=FALSE`` (the default), then the functions return a list of character vectors.

Otherwise, `stri_list2matrix`_ with ``byrow=TRUE`` and ``n_min=n`` arguments is called on the resulting object. In such a case, a character matrix with ``length(str)`` rows is returned. Note that `stri_list2matrix`_'s ``fill`` argument is set to an empty string and ``NA``, for ``simplify`` equal to ``TRUE`` and ``NA``, respectively.

See Also
~~~~~~~~

Other search_split: `about_search`_, `stri_split_lines()`_, `stri_split()`_

Other locale_sensitive: `%s<%()`_, `about_locale`_, `about_search_boundaries`_, `about_search_coll`_, `stri_compare()`_, `stri_count_boundaries()`_, `stri_duplicated()`_, `stri_enc_detect2()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_collator()`_, `stri_order()`_, `stri_rank()`_, `stri_sort_key()`_, `stri_sort()`_, `stri_trans_tolower()`_, `stri_unique()`_, `stri_wrap()`_

Other text_boundaries: `about_search_boundaries`_, `about_search`_, `stri_count_boundaries()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_brkiter()`_, `stri_split_lines()`_, `stri_trans_tolower()`_, `stri_wrap()`_

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

.. _stri_opts_brkiter: stri_opts_brkiter.html
.. _stringi-search-boundaries: about_search_boundaries.html
.. _stri_list2matrix: stri_list2matrix.html
.. _about_search: about_search.html
.. _stri_split_lines(): stri_split_lines.html
.. _stri_split(): stri_split.html
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
.. _stri_sort_key(): stri_sort_key.html
.. _stri_sort(): stri_sort.html
.. _stri_trans_tolower(): stri_trans_casemap.html
.. _stri_unique(): stri_unique.html
.. _stri_wrap(): stri_wrap.html
.. _stri_opts_brkiter(): stri_opts_brkiter.html
