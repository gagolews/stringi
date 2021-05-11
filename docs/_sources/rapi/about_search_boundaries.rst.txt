about_search_boundaries: Text Boundary Analysis in stringi
==========================================================

Description
~~~~~~~~~~~

Text boundary analysis is the process of locating linguistic boundaries while formatting and handling text.

Details
~~~~~~~

Examples of the boundary analysis process include:

-  Locating positions to word-wrap text to fit within specific margins while displaying or printing, see `stri_wrap`_ and `stri_split_boundaries`_.

-  Counting characters, words, sentences, or paragraphs, see `stri_count_boundaries`_.

-  Making a list of the unique words in a document, see `stri_extract_all_words`_ and then `stri_unique`_.

-  Capitalizing the first letter of each word or sentence, see also `stri_trans_totitle`_.

-  Locating a particular unit of the text (for example, finding the third word in the document), see `stri_locate_all_boundaries`_.

Generally, text boundary analysis is a locale-dependent operation. For example, in Japanese and Chinese one does not separate words with spaces - a line break can occur even in the middle of a word. These languages have punctuation and diacritical marks that cannot start or end a line, so this must also be taken into account.

stringi uses ICU's ``BreakIterator`` to locate specific text boundaries. Note that the ``BreakIterator``'s behavior may be controlled in come cases, see `stri_opts_brkiter`_.

-  The ``character`` boundary iterator tries to match what a user would think of as a “character” – a basic unit of a writing system for a language – which may be more than just a single Unicode code point.

-  The ``word`` boundary iterator locates the boundaries of words, for purposes such as “Find whole words” operations.

-  The ``line_break`` iterator locates positions that would be appropriate to wrap lines when displaying the text.

-  The break iterator of type ``sentence`` locates sentence boundaries.

For technical details on different classes of text boundaries refer to the ICU User Guide, see below.

References
~~~~~~~~~~

*Boundary Analysis* – ICU User Guide, http://userguide.icu-project.org/boundaryanalysis

See Also
~~~~~~~~

Other locale_sensitive: `%s<%()`_, `about_locale`_, `about_search_coll`_, `stri_compare()`_, `stri_count_boundaries()`_, `stri_duplicated()`_, `stri_enc_detect2()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_collator()`_, `stri_order()`_, `stri_rank()`_, `stri_sort_key()`_, `stri_sort()`_, `stri_split_boundaries()`_, `stri_trans_tolower()`_, `stri_unique()`_, `stri_wrap()`_

Other text_boundaries: `about_search`_, `stri_count_boundaries()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_brkiter()`_, `stri_split_boundaries()`_, `stri_split_lines()`_, `stri_trans_tolower()`_, `stri_wrap()`_

Other stringi_general_topics: `about_arguments`_, `about_encoding`_, `about_locale`_, `about_search_charclass`_, `about_search_coll`_, `about_search_fixed`_, `about_search_regex`_, `about_search`_, `about_stringi`_

.. _stri_wrap: stri_wrap.html
.. _stri_split_boundaries: stri_split_boundaries.html
.. _stri_count_boundaries: stri_count_boundaries.html
.. _stri_extract_all_words: stri_extract_boundaries.html
.. _stri_unique: stri_unique.html
.. _stri_trans_totitle: stri_trans_casemap.html
.. _stri_locate_all_boundaries: stri_locate_boundaries.html
.. _stri_opts_brkiter: stri_opts_brkiter.html
.. _%s<%(): operator_compare.html
.. _about_locale: about_locale.html
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
.. _about_search: about_search.html
.. _stri_opts_brkiter(): stri_opts_brkiter.html
.. _stri_split_lines(): stri_split_lines.html
.. _about_arguments: about_arguments.html
.. _about_encoding: about_encoding.html
.. _about_search_charclass: about_search_charclass.html
.. _about_search_fixed: about_search_fixed.html
.. _about_search_regex: about_search_regex.html
.. _about_stringi: about_stringi.html
