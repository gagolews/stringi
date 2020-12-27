stri_startsendswith: Determine if the Start or End of a String Matches a Pattern
================================================================================

Description
~~~~~~~~~~~

These functions check if a string starts or ends with a match to a given pattern. Also, it is possible to check if there is a match at a specific position.

Usage
~~~~~

.. code-block:: r

   stri_startswith(str, ..., fixed, coll, charclass)

   stri_endswith(str, ..., fixed, coll, charclass)

   stri_startswith_fixed(
     str,
     pattern,
     from = 1L,
     negate = FALSE,
     ...,
     opts_fixed = NULL
   )

   stri_endswith_fixed(
     str,
     pattern,
     to = -1L,
     negate = FALSE,
     ...,
     opts_fixed = NULL
   )

   stri_startswith_charclass(str, pattern, from = 1L, negate = FALSE)

   stri_endswith_charclass(str, pattern, to = -1L, negate = FALSE)

   stri_startswith_coll(
     str,
     pattern,
     from = 1L,
     negate = FALSE,
     ...,
     opts_collator = NULL
   )

   stri_endswith_coll(
     str,
     pattern,
     to = -1L,
     negate = FALSE,
     ...,
     opts_collator = NULL
   )

Arguments
~~~~~~~~~

+-------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``                             | character vector                                                                                                                                                                                        |
+-------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``                             | supplementary arguments passed to the underlying functions, including additional settings for ``opts_collator``, ``opts_fixed``, and so on.                                                             |
+-------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``pattern, fixed, coll, charclass`` | character vector defining search patterns; for more details refer to `stringi-search <about_search.html>`__                                                                                             |
+-------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``from``                            | integer vector                                                                                                                                                                                          |
+-------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``negate``                          | single logical value; whether a no-match to a pattern is rather of interest                                                                                                                             |
+-------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``to``                              | integer vector                                                                                                                                                                                          |
+-------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_collator, opts_fixed``       | a named list used to tune up the search engine's settings; see `stri_opts_collator <stri_opts_collator.html>`__ and `stri_opts_fixed <stri_opts_fixed.html>`__, respectively; ``NULL`` for the defaults |
+-------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str``, ``pattern``, and ``from`` or ``to`` (with recycling of the elements in the shorter vector if necessary).

If ``pattern`` is empty, then the result is ``NA`` and a warning is generated.

Argument ``start`` controls the start position in ``str`` where there is a match to a ``pattern``. ``to`` gives the end position.

Indexes given by ``from`` or ``to`` are of course 1-based, i.e., an index 1 denotes the first character in a string. This gives a typical R look-and-feel.

For negative indexes in ``from`` or ``to``, counting starts at the end of the string. For instance, index -1 denotes the last code point in the string.

If you wish to test for a pattern match at an arbitrary position in ``str``, use `stri_detect <stri_detect.html>`__.

``stri_startswith`` and ``stri_endswith`` are convenience functions. They call either ``stri_*_fixed``, ``stri_*_coll``, or ``stri_*_charclass``, depending on the argument used. Relying on these underlying functions directly will make your code run slightly faster.

Note that testing for a pattern match at the start or end of a string has not been implemented separately for regex patterns. For that you may use the '``^``' and '``$``' meta-characters, see `stringi-search-regex <about_search_regex.html>`__.

Value
~~~~~

Each function returns a logical vector.

See Also
~~~~~~~~

Other search_detect: `about_search <about_search.html>`__, `stri_detect() <stri_detect.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_startswith_charclass(' trim me! ', '\\p{WSpace}')
   stri_startswith_fixed(c('a1', 'a2', 'b3', 'a4', 'c5'), 'a')
   stri_detect_regex(c('a1', 'a2', 'b3', 'a4', 'c5'), '^a')
   stri_startswith_fixed('ababa', 'ba')
   stri_startswith_fixed('ababa', 'ba', from=2)
   stri_startswith_coll(c('a1', 'A2', 'b3', 'A4', 'C5'), 'a', strength=1)
   pat <- stri_paste('\u0635\u0644\u0649 \u0627\u0644\u0644\u0647 ',
                     '\u0639\u0644\u064a\u0647 \u0648\u0633\u0644\u0645XYZ')
   stri_endswith_coll('\ufdfa\ufdfa\ufdfaXYZ', pat, strength=1)
