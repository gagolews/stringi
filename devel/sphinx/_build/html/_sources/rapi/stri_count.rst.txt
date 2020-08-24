stri_count: Count the Number of Pattern Matches
===============================================

Description
~~~~~~~~~~~

These functions count the number of occurrences of a pattern in a string.

Usage
~~~~~

.. code-block:: r

   stri_count(str, ..., regex, fixed, coll, charclass)

   stri_count_charclass(str, pattern)

   stri_count_coll(str, pattern, ..., opts_collator = NULL)

   stri_count_fixed(str, pattern, ..., opts_fixed = NULL)

   stri_count_regex(str, pattern, ..., opts_regex = NULL)

Arguments
~~~~~~~~~

+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``                                    | character vector; strings to search in                                                                                                                                                                                                               |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``                                    | supplementary arguments passed to the underlying functions, including additional settings for ``opts_collator``, ``opts_regex``, ``opts_fixed``, and so on                                                                                           |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``pattern, regex, fixed, coll, charclass`` | character vector; search patterns; for more details refer to `stringi-search <stringi-search.html>`__                                                                                                                                                |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_collator, opts_fixed, opts_regex``  | a named list used to tune up the search engine's settings; see `stri_opts_collator <stri_opts_collator.html>`__, `stri_opts_fixed <stri_opts_fixed.html>`__, and `stri_opts_regex <stri_opts_regex.html>`__, respectively; ``NULL`` for the defaults |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str`` and ``pattern`` (with recycling of the elements in the shorter vector if necessary). This allows to, for instance, search for one pattern in each given string, search for each pattern in one given string, and search for the i-th pattern within the i-th string.

If ``pattern`` is empty, then the result is ``NA`` and a warning is generated.

``stri_count`` is a convenience function. It calls either ``stri_count_regex``, ``stri_count_fixed``, ``stri_count_coll``, or ``stri_count_charclass``, depending on the argument used.

Value
~~~~~

All the functions return an integer vector.

See Also
~~~~~~~~

Other search_count: `stri_count_boundaries() <stri_count_boundaries.html>`__, `stringi-search <stringi-search.html>`__

Examples
~~~~~~~~

.. code-block:: r

   s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
   stri_count(s, fixed='dolor')
   stri_count(s, regex='\\p{L}+')

   stri_count_fixed(s, ' ')
   stri_count_fixed(s, 'o')
   stri_count_fixed(s, 'it')
   stri_count_fixed(s, letters)
   stri_count_fixed('babab', 'b')
   stri_count_fixed(c('stringi', '123'), 'string')

   stri_count_charclass(c('stRRRingi', 'STrrrINGI', '123'),
      c('\\p{Ll}', '\\p{Lu}', '\\p{Zs}'))
   stri_count_charclass(' \t\n', '\\p{WHITE_SPACE}') # white space - binary property
   stri_count_charclass(' \t\n', '\\p{Z}') # white-space - general category (note the difference)

   stri_count_regex(s, '(s|el)it')
   stri_count_regex(s, 'i.i')
   stri_count_regex(s, '.it')
   stri_count_regex('bab baab baaab', c('b.*?b', 'b.b'))
   stri_count_regex(c('stringi', '123'), '^(s|1)')

