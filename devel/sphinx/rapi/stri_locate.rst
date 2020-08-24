stri_locate: Locate Occurrences of a Pattern
============================================

Description
~~~~~~~~~~~

These functions may be used, e.g., to find the indexes (positions) where there is a match to some pattern. The functions ``stri_locate_all_*`` locate all the matches. ``stri_locate_first_*`` and ``stri_locate_last_*`` give the first or the last matches, respectively.

Usage
~~~~~

.. code-block:: r

   stri_locate_all(str, ..., regex, fixed, coll, charclass)

   stri_locate_first(str, ..., regex, fixed, coll, charclass)

   stri_locate_last(str, ..., regex, fixed, coll, charclass)

   stri_locate(
     str,
     ...,
     regex,
     fixed,
     coll,
     charclass,
     mode = c("first", "all", "last")
   )

   stri_locate_all_charclass(str, pattern, merge = TRUE, omit_no_match = FALSE)

   stri_locate_first_charclass(str, pattern)

   stri_locate_last_charclass(str, pattern)

   stri_locate_all_coll(
     str,
     pattern,
     omit_no_match = FALSE,
     ...,
     opts_collator = NULL
   )

   stri_locate_first_coll(str, pattern, ..., opts_collator = NULL)

   stri_locate_last_coll(str, pattern, ..., opts_collator = NULL)

   stri_locate_all_regex(
     str,
     pattern,
     omit_no_match = FALSE,
     ...,
     opts_regex = NULL
   )

   stri_locate_first_regex(str, pattern, ..., opts_regex = NULL)

   stri_locate_last_regex(str, pattern, ..., opts_regex = NULL)

   stri_locate_all_fixed(
     str,
     pattern,
     omit_no_match = FALSE,
     ...,
     opts_fixed = NULL
   )

   stri_locate_first_fixed(str, pattern, ..., opts_fixed = NULL)

   stri_locate_last_fixed(str, pattern, ..., opts_fixed = NULL)

Arguments
~~~~~~~~~

+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``                                    | character vector; strings to search in                                                                                                                                                                                                               |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``                                    | supplementary arguments passed to the underlying functions, including additional settings for ``opts_collator``, ``opts_regex``, ``opts_fixed``, and so on                                                                                           |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``mode``                                   | single string; one of: ``'first'`` (the default), ``'all'``, ``'last'``                                                                                                                                                                              |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``pattern, regex, fixed, coll, charclass`` | character vector; search patterns; for more details refer to `stringi-search <stringi-search.html>`__                                                                                                                                                |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``merge``                                  | single logical value; indicates whether consecutive sequences of indexes in the resulting matrix should be merged; ``stri_locate_all_charclass`` only                                                                                                |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``omit_no_match``                          | single logical value; if ``FALSE``, then two missing values will indicate that there was no match; ``stri_locate_all_*`` only                                                                                                                        |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_collator, opts_fixed, opts_regex``  | a named list used to tune up the search engine's settings; see `stri_opts_collator <stri_opts_collator.html>`__, `stri_opts_fixed <stri_opts_fixed.html>`__, and `stri_opts_regex <stri_opts_regex.html>`__, respectively; ``NULL`` for the defaults |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str`` and ``pattern`` (with recycling of the elements in the shorter vector if necessary). This allows to, for instance, search for one pattern in each given string, search for each pattern in one given string, and search for the i-th pattern within the i-th string.

The matches may be extracted by calling `stri_sub <stri_sub.html>`__ or `stri_sub_all <stri_sub_all.html>`__. Alternatively, you may call `stri_extract <stri_extract.html>`__ directly.

``stri_locate``, ``stri_locate_all``, ``stri_locate_first``, and ``stri_locate_last`` are convenience functions. They just call ``stri_locate_*_*``, depending on the arguments used.

Value
~~~~~

For ``stri_locate_all_*``, a list of integer matrices is returned. Each list element represents the results of a separate search scenario. The first column gives the start positions of the matches, and the second column gives the end positions. Moreover, you may get two ``NA``\ s in one row for no match (if ``omit_no_match`` is ``FALSE``) or ``NA`` arguments.

``stri_locate_first_*`` and ``stri_locate_last_*`` return an integer matrix with two columns, giving the start and end positions of the first or the last matches, respectively, and two ``NA``\ s if and only if they are not found.

For ``stri_locate_*_regex``, if the match is of zero length, ``end`` will be one character less than ``start``.

See Also
~~~~~~~~

Other search_locate: `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stringi-search <stringi-search.html>`__

Other indexing: `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_sub_all() <stri_sub_all.html>`__, `stri_sub() <stri_sub.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_locate_all('XaaaaX',
      regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
   stri_locate_all('Bartolini', fixed='i')
   stri_locate_all('a b c', charclass='\\p{Zs}') # all white spaces

   stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}')
   stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}', merge=FALSE)
   stri_locate_first_charclass('AaBbCc', '\\p{Ll}')
   stri_locate_last_charclass('AaBbCc', '\\p{Ll}')

   stri_locate_all_coll(c('AaaaaaaA', 'AAAA'), 'a')
   stri_locate_first_coll(c('Yy\u00FD', 'AAA'), 'y', strength=2, locale='sk_SK')
   stri_locate_last_coll(c('Yy\u00FD', 'AAA'), 'y', strength=1, locale='sk_SK')

   pat <- stri_paste('\u0635\u0644\u0649 \u0627\u0644\u0644\u0647 ',
                     '\u0639\u0644\u064a\u0647 \u0648\u0633\u0644\u0645XYZ')
   stri_locate_last_coll('\ufdfa\ufdfa\ufdfaXYZ', pat, strength = 1)

   stri_locate_all_fixed(c('AaaaaaaA', 'AAAA'), 'a')
   stri_locate_all_fixed(c('AaaaaaaA', 'AAAA'), 'a', case_insensitive=TRUE, overlap=TRUE)
   stri_locate_first_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
   stri_locate_last_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')

   #first row is 1-2 like in locate_first
   stri_locate_all_fixed('bbbbb', 'bb')
   stri_locate_first_fixed('bbbbb', 'bb')

   # but last row is 3-4, unlike in locate_last,
   # keep this in mind [overlapping pattern match OK]!
   stri_locate_last_fixed('bbbbb', 'bb')

   stri_locate_all_regex('XaaaaX',
      c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
   stri_locate_first_regex('XaaaaX',
      c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
   stri_locate_last_regex('XaaaaX',
      c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))

   # Use regex positive-lookahead to locate overlapping pattern matches:
   stri_locate_all_regex('ACAGAGACTTTAGATAGAGAAGA', '(?=AGA)')
   # note that start > end here (match of 0 length)


