stri_locate_boundaries: Locate Text Boundaries
==============================================

Description
~~~~~~~~~~~

These functions locate text boundaries (like character, word, line, or sentence boundaries). Use ``stri_locate_all_*`` to locate all the matches. ``stri_locate_first_*`` and ``stri_locate_last_*`` give the first or the last matches, respectively.

Usage
~~~~~

.. code-block:: r

   stri_locate_all_boundaries(
     str,
     omit_no_match = FALSE,
     ...,
     opts_brkiter = NULL
   )

   stri_locate_last_boundaries(str, ..., opts_brkiter = NULL)

   stri_locate_first_boundaries(str, ..., opts_brkiter = NULL)

   stri_locate_all_words(str, omit_no_match = FALSE, locale = NULL)

   stri_locate_last_words(str, locale = NULL)

   stri_locate_first_words(str, locale = NULL)

Arguments
~~~~~~~~~

+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``           | character vector or an object coercible to                                                                                                                                             |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``omit_no_match`` | single logical value; if ``FALSE``, then two missing values will indicate that there are no text boundaries                                                                            |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``           | additional settings for ``opts_brkiter``                                                                                                                                               |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_brkiter``  | a named list with ICU BreakIterator's settings, see `stri_opts_brkiter <stri_opts_brkiter.html>`__; ``NULL`` for default break iterator, i.e., ``line_break``                          |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale``        | ``NULL`` or ``''`` for text boundary analysis following the conventions of the default locale, or a single string with locale identifier, see `stringi-locale <stringi-locale.html>`__ |
+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str``.

For more information on text boundary analysis performed by ICU's ``BreakIterator``, see `stringi-search-boundaries <stringi-search-boundaries.html>`__.

In case of ``stri_locate_*_words``, just like in `stri_extract_all_words <stri_extract_boundaries.html>`__ and `stri_count_words <stri_count_boundaries.html>`__, ICU's word ``BreakIterator`` iterator is used to locate the word boundaries, and all non-word characters (``UBRK_WORD_NONE`` rule status) are ignored. This is function is equivalent to a call to ``stri_locate_*_boundaries(str, type='word', skip_word_none=TRUE, locale=locale)``

Value
~~~~~

For ``stri_locate_all_*``, a list of ``length(str)`` integer matrices is returned. The first column gives the start positions of substrings between located boundaries, and the second column gives the end positions. The indexes are code point-based, thus they may be passed, e.g., to `stri_sub <stri_sub.html>`__ or `stri_sub_all <stri_sub_all.html>`__. Note that you get two ``NA``\ s in one row if there is no match (and ``omit_no_match`` is ``FALSE``) or there are missing data in the input vector.

``stri_locate_first_*`` and ``stri_locate_last_*``, return an integer matrix with two columns, giving the start and end positions of the first or the last matches, respectively, and two ``NA``\ s if there is no match.

See Also
~~~~~~~~

Other search_locate: `stri_locate_all() <stri_locate.html>`__, `stringi-search <stringi-search.html>`__

Other indexing: `stri_locate_all() <stri_locate.html>`__, `stri_sub_all() <stri_sub_all.html>`__, `stri_sub() <stri_sub.html>`__

Other locale_sensitive: `%s<%() <oper_comparison.html>`__, `stri_compare() <stri_compare.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_duplicated() <stri_duplicated.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_order() <stri_order.html>`__, `stri_sort_key() <stri_sort_key.html>`__, `stri_sort() <stri_sort.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_unique() <stri_unique.html>`__, `stri_wrap() <stri_wrap.html>`__, `stringi-locale <stringi-locale.html>`__, `stringi-search-boundaries <stringi-search-boundaries.html>`__, `stringi-search-coll <stringi-search-coll.html>`__

Other text_boundaries: `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_opts_brkiter() <stri_opts_brkiter.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_split_lines() <stri_split_lines.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_wrap() <stri_wrap.html>`__, `stringi-search-boundaries <stringi-search-boundaries.html>`__, `stringi-search <stringi-search.html>`__

Examples
~~~~~~~~

.. code-block:: r

   test <- 'The\u00a0above-mentioned    features are very useful. Spam, spam, eggs, bacon, and spam.'
   stri_locate_all_boundaries(test, type='line')
   stri_locate_all_boundaries(test, type='word')
   stri_locate_all_boundaries(test, type='sentence')
   stri_locate_all_boundaries(test, type='character')
   stri_locate_all_words(test)

   stri_extract_all_boundaries('Mr. Jones and Mrs. Brown are very happy.
   So am I, Prof. Smith.', type='sentence', locale='en_US@ss=standard') # ICU >= 56 only

