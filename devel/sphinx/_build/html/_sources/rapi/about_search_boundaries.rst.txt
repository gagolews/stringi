about_search_boundaries: Text Boundary Analysis in stringi
==========================================================

Description
~~~~~~~~~~~

Text boundary analysis is the process of locating linguistic boundaries while formatting and handling text.

Details
~~~~~~~

Examples of the boundary analysis process include:

-  Locating positions to word-wrap text to fit within specific margins while displaying or printing, see `stri_wrap <stri_wrap.html>`__ and `stri_split_boundaries <stri_split_boundaries.html>`__.

-  Counting characters, words, sentences, or paragraphs, see `stri_count_boundaries <stri_count_boundaries.html>`__.

-  Making a list of the unique words in a document, see `stri_extract_all_words <stri_extract_boundaries.html>`__ and then `stri_unique <stri_unique.html>`__.

-  Capitalizing the first letter of each word or sentence, see also `stri_trans_totitle <stri_trans_casemap.html>`__.

-  Locating a particular unit of the text (for example, finding the third word in the document), see `stri_locate_all_boundaries <stri_locate_boundaries.html>`__.

Generally, text boundary analysis is a locale-dependent operation. For example, in Japanese and Chinese one does not separate words with spaces - a line break can occur even in the middle of a word. These languages have punctuation and diacritical marks that cannot start or end a line, so this must also be taken into account.

stringi uses ICU's ``BreakIterator`` to locate specific text boundaries. Note that the ``BreakIterator``'s behavior may be controlled in come cases, see `stri_opts_brkiter <stri_opts_brkiter.html>`__.

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

Other locale_sensitive: `%s<%() <operator_compare.html>`__, `about_locale <about_locale.html>`__, `about_search_coll <about_search_coll.html>`__, `stri_compare() <stri_compare.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_duplicated() <stri_duplicated.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_order() <stri_order.html>`__, `stri_rank() <stri_rank.html>`__, `stri_sort_key() <stri_sort_key.html>`__, `stri_sort() <stri_sort.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_unique() <stri_unique.html>`__, `stri_wrap() <stri_wrap.html>`__

Other text_boundaries: `about_search <about_search.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_brkiter() <stri_opts_brkiter.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_split_lines() <stri_split_lines.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_wrap() <stri_wrap.html>`__

Other stringi_general_topics: `about_arguments <about_arguments.html>`__, `about_encoding <about_encoding.html>`__, `about_locale <about_locale.html>`__, `about_search_charclass <about_search_charclass.html>`__, `about_search_coll <about_search_coll.html>`__, `about_search_fixed <about_search_fixed.html>`__, `about_search_regex <about_search_regex.html>`__, `about_search <about_search.html>`__, `about_stringi <about_stringi.html>`__
