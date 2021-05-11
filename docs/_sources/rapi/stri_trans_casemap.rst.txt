stri_trans_casemap: Transform Strings with Case Mapping or Folding
==================================================================

Description
~~~~~~~~~~~

These functions transform strings either to lower case, UPPER CASE, or Title Case or perform case folding.

Usage
~~~~~

.. code-block:: r

   stri_trans_tolower(str, locale = NULL)

   stri_trans_toupper(str, locale = NULL)

   stri_trans_casefold(str)

   stri_trans_totitle(str, ..., opts_brkiter = NULL)

Arguments
~~~~~~~~~

+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``          | character vector                                                                                                                                           |
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale``       | ``NULL`` or ``''`` for case mapping following the conventions of the default locale, or a single string with locale identifier, see `stringi-locale`_.     |
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``          | additional settings for ``opts_brkiter``                                                                                                                   |
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_brkiter`` | a named list with ICU BreakIterator's settings, see `stri_opts_brkiter`_; ``NULL`` for default break iterator, i.e., ``word``; ``stri_trans_totitle`` only |
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str``.

ICU implements full Unicode string case mappings. It is worth noting that, generally, case mapping:

-  can change the number of code points and/or code units of a string,

-  is language-sensitive (results may differ depending on the locale), and

-  is context-sensitive (a character in the input string may map differently depending on surrounding characters).

With ``stri_trans_totitle``, if ``word`` ``BreakIterator`` is used (the default), then the first letter of each word will be capitalized and the rest will be transformed to lower case. With the break iterator of type ``sentence``, the first letter of each sentence will be capitalized only. Note that according the ICU User Guide, the string ``'one. two. three.'`` consists of one sentence.

Case folding, on the other hand, is locale-independent. Its purpose is to make two pieces of text that differ only in case identical. This may come in handy when comparing strings.

For more general (but not locale dependent) text transforms refer to `stri_trans_general`_.

Value
~~~~~

Each function returns a character vector.

References
~~~~~~~~~~

*Case Mappings* – ICU User Guide, http://userguide.icu-project.org/transforms/casemappings

See Also
~~~~~~~~

Other locale_sensitive: `%s<%()`_, `about_locale`_, `about_search_boundaries`_, `about_search_coll`_, `stri_compare()`_, `stri_count_boundaries()`_, `stri_duplicated()`_, `stri_enc_detect2()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_collator()`_, `stri_order()`_, `stri_rank()`_, `stri_sort_key()`_, `stri_sort()`_, `stri_split_boundaries()`_, `stri_unique()`_, `stri_wrap()`_

Other transform: `stri_trans_char()`_, `stri_trans_general()`_, `stri_trans_list()`_, `stri_trans_nfc()`_

Other text_boundaries: `about_search_boundaries`_, `about_search`_, `stri_count_boundaries()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_brkiter()`_, `stri_split_boundaries()`_, `stri_split_lines()`_, `stri_wrap()`_

Examples
~~~~~~~~

.. code-block:: r

   stri_trans_toupper('\u00DF', 'de_DE') # small German Eszett / scharfes S
   stri_cmp_eq(stri_trans_toupper('i', 'en_US'), stri_trans_toupper('i', 'tr_TR'))
   stri_trans_toupper(c('abc', '123', '\u0105\u0104'))
   stri_trans_tolower(c('AbC', '123', '\u0105\u0104'))
   stri_trans_totitle(c('AbC', '123', '\u0105\u0104'))
   stri_trans_casefold(c('AbC', '123', '\u0105\u0104'))
   stri_trans_totitle('cOOkiE mOnSTeR likes COOKIES. Here HE comes!') # word boundary
   stri_trans_totitle('cOOkiE mOnSTeR likes COOKIES. Here HE comes!', type='sentence')

.. _stringi-locale: about_locale.html
.. _stri_opts_brkiter: stri_opts_brkiter.html
.. _stri_trans_general: stri_trans_general.html
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
.. _stri_split_boundaries(): stri_split_boundaries.html
.. _stri_unique(): stri_unique.html
.. _stri_wrap(): stri_wrap.html
.. _stri_trans_char(): stri_trans_char.html
.. _stri_trans_general(): stri_trans_general.html
.. _stri_trans_list(): stri_trans_list.html
.. _stri_trans_nfc(): stri_trans_nf.html
.. _about_search: about_search.html
.. _stri_opts_brkiter(): stri_opts_brkiter.html
.. _stri_split_lines(): stri_split_lines.html
