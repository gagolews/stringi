stri_opts_collator: Generate a List with Collator Settings
==========================================================

Description
~~~~~~~~~~~

A convenience function to tune the ICU Collator's behavior, e.g., in `stri_compare`_, `stri_order`_, `stri_unique`_, `stri_duplicated`_, as well as `stri_detect_coll`_ and other `stringi-search-coll`_ functions.

Usage
~~~~~

.. code-block:: r

   stri_opts_collator(
     locale = NULL,
     strength = 3L,
     alternate_shifted = FALSE,
     french = FALSE,
     uppercase_first = NA,
     case_level = FALSE,
     normalization = FALSE,
     normalisation = normalization,
     numeric = FALSE,
     ...
   )

   stri_coll(
     locale = NULL,
     strength = 3L,
     alternate_shifted = FALSE,
     french = FALSE,
     uppercase_first = NA,
     case_level = FALSE,
     normalization = FALSE,
     normalisation = normalization,
     numeric = FALSE,
     ...
   )

Arguments
~~~~~~~~~

+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale``            | single string, ``NULL`` or ``''`` for default locale                                                                                                                                                                                                                            |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``strength``          | single integer in {1,2,3,4}, which defines collation strength; ``1`` for the most permissive collation rules, ``4`` for the strictest ones                                                                                                                                      |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``alternate_shifted`` | single logical value; ``FALSE`` treats all the code points with non-ignorable primary weights in the same way, ``TRUE`` causes code points with primary weights that are equal or below the variable top value to be ignored on primary level and moved to the quaternary level |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``french``            | single logical value; used in Canadian French; ``TRUE`` results in secondary weights being considered backwards                                                                                                                                                                 |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``uppercase_first``   | single logical value; ``NA`` orders upper and lower case letters in accordance to their tertiary weights, ``TRUE`` forces upper case letters to sort before lower case letters, ``FALSE`` does the opposite                                                                     |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``case_level``        | single logical value; controls whether an extra case level (positioned before the third level) is generated or not                                                                                                                                                              |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``normalization``     | single logical value; if ``TRUE``, then incremental check is performed to see whether the input data is in the FCD form. If the data is not in the FCD form, incremental NFD normalization is performed                                                                         |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``normalisation``     | alias of ``normalization``                                                                                                                                                                                                                                                      |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``numeric``           | single logical value; when turned on, this attribute generates a collation key for the numeric value of substrings of digits; this is a way to get '100' to sort AFTER '2'                                                                                                      |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``               | [DEPRECATED] any other arguments passed to this function generate a warning; this argument will be removed in the future                                                                                                                                                        |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

ICU's *collator* performs a locale-aware, natural-language alike string comparison. This is a more reliable way of establishing relationships between strings than the one provided by base R, and definitely one that is more complex and appropriate than ordinary bytewise comparison.

Value
~~~~~

Returns a named list object; missing settings are left with default values.

References
~~~~~~~~~~

*Collation* – ICU User Guide, http://userguide.icu-project.org/collation

*ICU Collation Service Architecture* – ICU User Guide, http://userguide.icu-project.org/collation/architecture

*``icu::Collator`` Class Reference* – ICU4C API Documentation, https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/classicu_1_1Collator.html

See Also
~~~~~~~~

Other locale_sensitive: `%s<%()`_, `about_locale`_, `about_search_boundaries`_, `about_search_coll`_, `stri_compare()`_, `stri_count_boundaries()`_, `stri_duplicated()`_, `stri_enc_detect2()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_order()`_, `stri_rank()`_, `stri_sort_key()`_, `stri_sort()`_, `stri_split_boundaries()`_, `stri_trans_tolower()`_, `stri_unique()`_, `stri_wrap()`_

Other search_coll: `about_search_coll`_, `about_search`_

Examples
~~~~~~~~

.. code-block:: r

   stri_cmp('number100', 'number2')
   stri_cmp('number100', 'number2', opts_collator=stri_opts_collator(numeric=TRUE))
   stri_cmp('number100', 'number2', numeric=TRUE) # equivalent
   stri_cmp('above mentioned', 'above-mentioned')
   stri_cmp('above mentioned', 'above-mentioned', alternate_shifted=TRUE)

.. _stri_compare: stri_compare.html
.. _stri_order: stri_order.html
.. _stri_unique: stri_unique.html
.. _stri_duplicated: stri_duplicated.html
.. _stri_detect_coll: stri_detect.html
.. _stringi-search-coll: about_search_coll.html
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
.. _stri_order(): stri_order.html
.. _stri_rank(): stri_rank.html
.. _stri_sort_key(): stri_sort_key.html
.. _stri_sort(): stri_sort.html
.. _stri_split_boundaries(): stri_split_boundaries.html
.. _stri_trans_tolower(): stri_trans_casemap.html
.. _stri_unique(): stri_unique.html
.. _stri_wrap(): stri_wrap.html
.. _about_search: about_search.html
