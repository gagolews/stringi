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

+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``           | character vector or an object coercible to                                                                                                                      |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``omit_no_match`` | single logical value; if ``FALSE``, then two missing values will indicate that there are no text boundaries                                                     |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``           | additional settings for ``opts_brkiter``                                                                                                                        |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_brkiter``  | a named list with ICU BreakIterator's settings, see `stri_opts_brkiter`_; ``NULL`` for default break iterator, i.e., ``line_break``                             |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale``        | ``NULL`` or ``''`` for text boundary analysis following the conventions of the default locale, or a single string with locale identifier, see `stringi-locale`_ |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str``.

For more information on text boundary analysis performed by ICU's ``BreakIterator``, see `stringi-search-boundaries`_.

In case of ``stri_locate_*_words``, just like in `stri_extract_all_words`_ and `stri_count_words`_, ICU's word ``BreakIterator`` iterator is used to locate the word boundaries, and all non-word characters (``UBRK_WORD_NONE`` rule status) are ignored. This is function is equivalent to a call to ``stri_locate_*_boundaries(str, type='word', skip_word_none=TRUE, locale=locale)``

Value
~~~~~

For ``stri_locate_all_*``, a list of ``length(str)`` integer matrices is returned. The first column gives the start positions of substrings between located boundaries, and the second column gives the end positions. The indexes are code point-based, thus they may be passed, e.g., to `stri_sub`_ or `stri_sub_all`_. Note that you get two ``NA``\ s in one row if there is no match (and ``omit_no_match`` is ``FALSE``) or there are missing data in the input vector.

``stri_locate_first_*`` and ``stri_locate_last_*``, return an integer matrix with two columns, giving the start and end positions of the first or the last matches, respectively, and two ``NA``\ s if there is no match.

See Also
~~~~~~~~

Other search_locate: `about_search`_, `stri_locate_all()`_

Other indexing: `stri_locate_all()`_, `stri_sub_all()`_, `stri_sub()`_

Other locale_sensitive: `%s<%()`_, `about_locale`_, `about_search_boundaries`_, `about_search_coll`_, `stri_compare()`_, `stri_count_boundaries()`_, `stri_duplicated()`_, `stri_enc_detect2()`_, `stri_extract_all_boundaries()`_, `stri_opts_collator()`_, `stri_order()`_, `stri_rank()`_, `stri_sort_key()`_, `stri_sort()`_, `stri_split_boundaries()`_, `stri_trans_tolower()`_, `stri_unique()`_, `stri_wrap()`_

Other text_boundaries: `about_search_boundaries`_, `about_search`_, `stri_count_boundaries()`_, `stri_extract_all_boundaries()`_, `stri_opts_brkiter()`_, `stri_split_boundaries()`_, `stri_split_lines()`_, `stri_trans_tolower()`_, `stri_wrap()`_

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

.. _stri_opts_brkiter: stri_opts_brkiter.html
.. _stringi-locale: about_locale.html
.. _stringi-search-boundaries: about_search_boundaries.html
.. _stri_extract_all_words: stri_extract_boundaries.html
.. _stri_count_words: stri_count_boundaries.html
.. _stri_sub: stri_sub.html
.. _stri_sub_all: stri_sub_all.html
.. _about_search: about_search.html
.. _stri_locate_all(): stri_locate.html
.. _stri_sub_all(): stri_sub_all.html
.. _stri_sub(): stri_sub.html
.. _%s<%(): operator_compare.html
.. _about_locale: about_locale.html
.. _about_search_boundaries: about_search_boundaries.html
.. _about_search_coll: about_search_coll.html
.. _stri_compare(): stri_compare.html
.. _stri_count_boundaries(): stri_count_boundaries.html
.. _stri_duplicated(): stri_duplicated.html
.. _stri_enc_detect2(): stri_enc_detect2.html
.. _stri_extract_all_boundaries(): stri_extract_boundaries.html
.. _stri_opts_collator(): stri_opts_collator.html
.. _stri_order(): stri_order.html
.. _stri_rank(): stri_rank.html
.. _stri_sort_key(): stri_sort_key.html
.. _stri_sort(): stri_sort.html
.. _stri_split_boundaries(): stri_split_boundaries.html
.. _stri_trans_tolower(): stri_trans_casemap.html
.. _stri_unique(): stri_unique.html
.. _stri_wrap(): stri_wrap.html
.. _stri_opts_brkiter(): stri_opts_brkiter.html
.. _stri_split_lines(): stri_split_lines.html
