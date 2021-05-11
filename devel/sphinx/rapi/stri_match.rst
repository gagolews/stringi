stri_match: Extract Regex Pattern Matches, Together with Capture Groups
=======================================================================

Description
~~~~~~~~~~~

These functions extract substrings in ``str`` that match a given regex ``pattern``. Additionally, they extract matches to every *capture group*, i.e., to all the sub-patterns given in round parentheses.

Usage
~~~~~

.. code-block:: r

   stri_match_all(str, ..., regex)

   stri_match_first(str, ..., regex)

   stri_match_last(str, ..., regex)

   stri_match(str, ..., regex, mode = c("first", "all", "last"))

   stri_match_all_regex(
     str,
     pattern,
     omit_no_match = FALSE,
     cg_missing = NA_character_,
     ...,
     opts_regex = NULL
   )

   stri_match_first_regex(
     str,
     pattern,
     cg_missing = NA_character_,
     ...,
     opts_regex = NULL
   )

   stri_match_last_regex(
     str,
     pattern,
     cg_missing = NA_character_,
     ...,
     opts_regex = NULL
   )

Arguments
~~~~~~~~~

+--------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| ``str``            | character vector; strings to search in                                                                                              |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| ``...``            | supplementary arguments passed to the underlying functions, including additional settings for ``opts_regex``                        |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| ``mode``           | single string; one of: ``'first'`` (the default), ``'all'``, ``'last'``                                                             |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| ``pattern, regex`` | character vector; search patterns; for more details refer to `stringi-search`_                                                      |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| ``omit_no_match``  | single logical value; if ``FALSE``, then a row with missing values will indicate that there was no match; ``stri_match_all_*`` only |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| ``cg_missing``     | single string to be used if a capture group match is unavailable                                                                    |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_regex``     | a named list with ICU Regex settings, see `stri_opts_regex`_; ``NULL`` for default settings                                         |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str`` and ``pattern`` (with recycling of the elements in the shorter vector if necessary). This allows to, for instance, search for one pattern in each given string, search for each pattern in one given string, and search for the i-th pattern within the i-th string.

If no pattern match is detected and ``omit_no_match=FALSE``, then ``NA``\ s are included in the resulting matrix (matrices), see Examples.

Please note: ICU regex engine currently does not fully support named capture groups.

``stri_match``, ``stri_match_all``, ``stri_match_first``, and ``stri_match_last`` are convenience functions. They just call ``stri_match_*_regex`` and were provided for consistency with other string searching functions' wrappers, see, among others, `stri_extract`_.

Value
~~~~~

For ``stri_match_all*``, a list of character matrices is returned. Each list element represents the results of a different search scenario.

For ``stri_match_first*`` and ``stri_match_last*`` a character matrix is returned. Each row corresponds to a different search result.

The first matrix column gives the whole match. The second one corresponds to the first capture group, the third – the second capture group, and so on.

See Also
~~~~~~~~

Other search_extract: `about_search`_, `stri_extract_all_boundaries()`_, `stri_extract_all()`_

Examples
~~~~~~~~

.. code-block:: r

   stri_match_all_regex('breakfast=eggs, lunch=pizza, dessert=icecream',
      '(\\w+)=(\\w+)')
   stri_match_all_regex(c('breakfast=eggs', 'lunch=pizza', 'no food here'),
      '(\\w+)=(\\w+)')
   stri_match_all_regex(c('breakfast=eggs;lunch=pizza',
      'breakfast=bacon;lunch=spaghetti', 'no food here'),
      '(\\w+)=(\\w+)')
   stri_match_first_regex(c('breakfast=eggs;lunch=pizza',
      'breakfast=bacon;lunch=spaghetti', 'no food here'),
      '(\\w+)=(\\w+)')
   stri_match_last_regex(c('breakfast=eggs;lunch=pizza',
      'breakfast=bacon;lunch=spaghetti', 'no food here'),
      '(\\w+)=(\\w+)')

   stri_match_first_regex(c('abcd', ':abcd', ':abcd:'), '^(:)?([^:]*)(:)?$')
   stri_match_first_regex(c('abcd', ':abcd', ':abcd:'), '^(:)?([^:]*)(:)?$', cg_missing='')

   # Match all the pattern of the form XYX, including overlapping matches:
   stri_match_all_regex('ACAGAGACTTTAGATAGAGAAGA', '(?=(([ACGT])[ACGT]\\2))')[[1]][,2]
   # Compare the above to:
   stri_extract_all_regex('ACAGAGACTTTAGATAGAGAAGA', '([ACGT])[ACGT]\\1')

.. _stringi-search: about_search.html
.. _stri_opts_regex: stri_opts_regex.html
.. _stri_extract: stri_extract.html
.. _about_search: about_search.html
.. _stri_extract_all_boundaries(): stri_extract_boundaries.html
.. _stri_extract_all(): stri_extract.html
