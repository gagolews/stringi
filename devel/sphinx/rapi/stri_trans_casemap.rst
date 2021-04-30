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

+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``          | character vector                                                                                                                                                                     |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale``       | ``NULL`` or ``''`` for case mapping following the conventions of the default locale, or a single string with locale identifier, see `stringi-locale <about_locale.html>`__.          |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``          | additional settings for ``opts_brkiter``                                                                                                                                             |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_brkiter`` | a named list with ICU BreakIterator's settings, see `stri_opts_brkiter <stri_opts_brkiter.html>`__; ``NULL`` for default break iterator, i.e., ``word``; ``stri_trans_totitle`` only |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str``.

ICU implements full Unicode string case mappings. It is worth noting that, generally, case mapping:

-  can change the number of code points and/or code units of a string,

-  is language-sensitive (results may differ depending on the locale), and

-  is context-sensitive (a character in the input string may map differently depending on surrounding characters).

With ``stri_trans_totitle``, if ``word`` ``BreakIterator`` is used (the default), then the first letter of each word will be capitalized and the rest will be transformed to lower case. With the break iterator of type ``sentence``, the first letter of each sentence will be capitalized only. Note that according the ICU User Guide, the string ``'one. two. three.'`` consists of one sentence.

Case folding, on the other hand, is locale-independent. Its purpose is to make two pieces of text that differ only in case identical. This may come in handy when comparing strings.

For more general (but not locale dependent) text transforms refer to `stri_trans_general <stri_trans_general.html>`__.

Value
~~~~~

Each function returns a character vector.

References
~~~~~~~~~~

*Case Mappings* – ICU User Guide, http://userguide.icu-project.org/transforms/casemappings

See Also
~~~~~~~~

Other locale_sensitive: `%s<%() <operator_compare.html>`__, `about_locale <about_locale.html>`__, `about_search_boundaries <about_search_boundaries.html>`__, `about_search_coll <about_search_coll.html>`__, `stri_compare() <stri_compare.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_duplicated() <stri_duplicated.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_order() <stri_order.html>`__, `stri_rank() <stri_rank.html>`__, `stri_sort_key() <stri_sort_key.html>`__, `stri_sort() <stri_sort.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_unique() <stri_unique.html>`__, `stri_wrap() <stri_wrap.html>`__

Other transform: `stri_trans_char() <stri_trans_char.html>`__, `stri_trans_general() <stri_trans_general.html>`__, `stri_trans_list() <stri_trans_list.html>`__, `stri_trans_nfc() <stri_trans_nf.html>`__

Other text_boundaries: `about_search_boundaries <about_search_boundaries.html>`__, `about_search <about_search.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_brkiter() <stri_opts_brkiter.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_split_lines() <stri_split_lines.html>`__, `stri_wrap() <stri_wrap.html>`__

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
