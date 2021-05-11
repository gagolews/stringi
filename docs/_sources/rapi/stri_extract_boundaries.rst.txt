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

+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``           | character vector or an object coercible to                                                                                                                      |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``simplify``      | single logical value; if ``TRUE`` or ``NA``, then a character matrix is returned; otherwise (the default), a list of character vectors is given, see Value      |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``omit_no_match`` | single logical value; if ``FALSE``, then a missing value will indicate that there are no words                                                                  |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``           | additional settings for ``opts_brkiter``                                                                                                                        |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_brkiter``  | a named list with ICU BreakIterator's settings, see `stri_opts_brkiter`_; ``NULL`` for the default break iterator, i.e., ``line_break``                         |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale``        | ``NULL`` or ``''`` for text boundary analysis following the conventions of the default locale, or a single string with locale identifier, see `stringi-locale`_ |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str``.

For more information on text boundary analysis performed by ICU's ``BreakIterator``, see `stringi-search-boundaries`_.

In case of ``stri_extract_*_words``, just like in `stri_count_words`_, ICU's word ``BreakIterator`` iterator is used to locate the word boundaries, and all non-word characters (``UBRK_WORD_NONE`` rule status) are ignored.

Value
~~~~~

For ``stri_extract_all_*``, if ``simplify=FALSE`` (the default), then a list of character vectors is returned. Each string consists of a separate word. In case of ``omit_no_match=FALSE`` and if there are no words or if a string is missing, a single ``NA`` is provided on output.

Otherwise, `stri_list2matrix`_ with ``byrow=TRUE`` argument is called on the resulting object. In such a case, a character matrix with ``length(str)`` rows is returned. Note that `stri_list2matrix`_'s ``fill`` argument is set to an empty string and ``NA``, for ``simplify`` ``TRUE`` and ``NA``, respectively.

For ``stri_extract_first_*`` and ``stri_extract_last_*``, a character vector is returned. A ``NA`` element indicates a no-match.

See Also
~~~~~~~~

Other search_extract: `about_search`_, `stri_extract_all()`_, `stri_match_all()`_

Other locale_sensitive: `%s<%()`_, `about_locale`_, `about_search_boundaries`_, `about_search_coll`_, `stri_compare()`_, `stri_count_boundaries()`_, `stri_duplicated()`_, `stri_enc_detect2()`_, `stri_locate_all_boundaries()`_, `stri_opts_collator()`_, `stri_order()`_, `stri_rank()`_, `stri_sort_key()`_, `stri_sort()`_, `stri_split_boundaries()`_, `stri_trans_tolower()`_, `stri_unique()`_, `stri_wrap()`_

Other text_boundaries: `about_search_boundaries`_, `about_search`_, `stri_count_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_brkiter()`_, `stri_split_boundaries()`_, `stri_split_lines()`_, `stri_trans_tolower()`_, `stri_wrap()`_

Examples
~~~~~~~~

.. code-block:: r

   stri_extract_all_words('stringi: THE string processing package 123.48...')

.. _stri_opts_brkiter: stri_opts_brkiter.html
.. _stringi-locale: about_locale.html
.. _stringi-search-boundaries: about_search_boundaries.html
.. _stri_count_words: stri_count_boundaries.html
.. _stri_list2matrix: stri_list2matrix.html
.. _about_search: about_search.html
.. _stri_extract_all(): stri_extract.html
.. _stri_match_all(): stri_match.html
.. _%s<%(): operator_compare.html
.. _about_locale: about_locale.html
.. _about_search_boundaries: about_search_boundaries.html
.. _about_search_coll: about_search_coll.html
.. _stri_compare(): stri_compare.html
.. _stri_count_boundaries(): stri_count_boundaries.html
.. _stri_duplicated(): stri_duplicated.html
.. _stri_enc_detect2(): stri_enc_detect2.html
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
.. _stri_opts_brkiter(): stri_opts_brkiter.html
.. _stri_split_lines(): stri_split_lines.html
