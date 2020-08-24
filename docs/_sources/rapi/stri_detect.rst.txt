stri_detect: Detect a Pattern Match
===================================

Description
~~~~~~~~~~~

These functions determine, for each string in ``str``, if there is at least one match to a corresponding ``pattern``.

Usage
~~~~~

.. code-block:: r

   stri_detect(str, ..., regex, fixed, coll, charclass)

   stri_detect_fixed(
     str,
     pattern,
     negate = FALSE,
     max_count = -1,
     ...,
     opts_fixed = NULL
   )

   stri_detect_charclass(str, pattern, negate = FALSE, max_count = -1)

   stri_detect_coll(
     str,
     pattern,
     negate = FALSE,
     max_count = -1,
     ...,
     opts_collator = NULL
   )

   stri_detect_regex(
     str,
     pattern,
     negate = FALSE,
     max_count = -1,
     ...,
     opts_regex = NULL
   )

Arguments
~~~~~~~~~

+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``                                    | character vector; strings to search in                                                                                                                                                                                                               |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``                                    | supplementary arguments passed to the underlying functions, including additional settings for ``opts_collator``, ``opts_regex``, ``opts_fixed``, and so on                                                                                           |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``pattern, regex, fixed, coll, charclass`` | character vector; search patterns; for more details refer to `stringi-search <stringi-search.html>`__                                                                                                                                                |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``negate``                                 | single logical value; whether a no-match to a pattern is rather of interest                                                                                                                                                                          |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``max_count``                              | single integer; allows to stop searching once a given number of occurrences is detected; ``-1`` (the default) inspects all elements                                                                                                                  |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_collator, opts_fixed, opts_regex``  | a named list used to tune up the search engine's settings; see `stri_opts_collator <stri_opts_collator.html>`__, `stri_opts_fixed <stri_opts_fixed.html>`__, and `stri_opts_regex <stri_opts_regex.html>`__, respectively; ``NULL`` for the defaults |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str`` and ``pattern`` (with recycling of the elements in the shorter vector if necessary). This allows to, for instance, search for one pattern in each given string, search for each pattern in one given string, and search for the i-th pattern within the i-th string.

If ``pattern`` is empty, then the result is ``NA`` and a warning is generated.

``stri_detect`` is a convenience function. It calls either ``stri_detect_regex``, ``stri_detect_fixed``, ``stri_detect_coll``, or ``stri_detect_charclass``, depending on the argument used.

See also `stri_startswith <stri_startsendswith.html>`__ and `stri_endswith <stri_startsendswith.html>`__ for testing whether a string starts or ends with a match to a given pattern. Moreover, see `stri_subset <stri_subset.html>`__ for a character vector subsetting.

If ``max_count`` is negative, then all stings are examined. Otherwise, searching terminates once ``max_count`` matches (or, if ``negate`` is ``TRUE``, no-matches) are detected. The un-inspected cases are marked as missing in the return vector. Be aware that, unless ``pattern`` is a singleton, the elements in ``str`` might be inspected in a non-consecutive order.

Value
~~~~~

Each function returns a logical vector.

See Also
~~~~~~~~

Other search_detect: `stri_startswith() <stri_startsendswith.html>`__, `stringi-search <stringi-search.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_detect_fixed(c('stringi R', 'R STRINGI', '123'), c('i', 'R', '0'))
   stri_detect_fixed(c('stringi R', 'R STRINGI', '123'), 'R')

   stri_detect_charclass(c('stRRRingi','R STRINGI', '123'),
      c('\\p{Ll}', '\\p{Lu}', '\\p{Zs}'))

   stri_detect_regex(c('stringi R', 'R STRINGI', '123'), 'R.')
   stri_detect_regex(c('stringi R', 'R STRINGI', '123'), '[[:alpha:]]*?')
   stri_detect_regex(c('stringi R', 'R STRINGI', '123'), '[a-zC1]')
   stri_detect_regex(c('stringi R', 'R STRINGI', '123'), '( R|RE)')
   stri_detect_regex('stringi', 'STRING.', case_insensitive=TRUE)

   stri_detect_regex(c('abc', 'def', '123', 'ghi', '456', '789', 'jkl'),
      '^[0-9]+$', max_count=1)
   stri_detect_regex(c('abc', 'def', '123', 'ghi', '456', '789', 'jkl'),
      '^[0-9]+$', max_count=2)
   stri_detect_regex(c('abc', 'def', '123', 'ghi', '456', '789', 'jkl'),
      '^[0-9]+$', negate=TRUE, max_count=3)

