stri_replace: Replace Occurrences of a Pattern
==============================================

Description
~~~~~~~~~~~

These functions replace, with the given replacement string, every/first/last substring of the input that matches the specified ``pattern``.

Usage
~~~~~

.. code-block:: r

   stri_replace_all(str, replacement, ..., regex, fixed, coll, charclass)

   stri_replace_first(str, replacement, ..., regex, fixed, coll, charclass)

   stri_replace_last(str, replacement, ..., regex, fixed, coll, charclass)

   stri_replace(
     str,
     replacement,
     ...,
     regex,
     fixed,
     coll,
     charclass,
     mode = c("first", "all", "last")
   )

   stri_replace_all_charclass(
     str,
     pattern,
     replacement,
     merge = FALSE,
     vectorize_all = TRUE,
     vectorise_all = vectorize_all
   )

   stri_replace_first_charclass(str, pattern, replacement)

   stri_replace_last_charclass(str, pattern, replacement)

   stri_replace_all_coll(
     str,
     pattern,
     replacement,
     vectorize_all = TRUE,
     vectorise_all = vectorize_all,
     ...,
     opts_collator = NULL
   )

   stri_replace_first_coll(str, pattern, replacement, ..., opts_collator = NULL)

   stri_replace_last_coll(str, pattern, replacement, ..., opts_collator = NULL)

   stri_replace_all_fixed(
     str,
     pattern,
     replacement,
     vectorize_all = TRUE,
     vectorise_all = vectorize_all,
     ...,
     opts_fixed = NULL
   )

   stri_replace_first_fixed(str, pattern, replacement, ..., opts_fixed = NULL)

   stri_replace_last_fixed(str, pattern, replacement, ..., opts_fixed = NULL)

   stri_replace_all_regex(
     str,
     pattern,
     replacement,
     vectorize_all = TRUE,
     vectorise_all = vectorize_all,
     ...,
     opts_regex = NULL
   )

   stri_replace_first_regex(str, pattern, replacement, ..., opts_regex = NULL)

   stri_replace_last_regex(str, pattern, replacement, ..., opts_regex = NULL)

Arguments
~~~~~~~~~

+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``                                    | character vector; strings to search in                                                                                                                                                                                                               |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``replacement``                            | character vector with replacements for matched patterns                                                                                                                                                                                              |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``                                    | supplementary arguments passed to the underlying functions, including additional settings for ``opts_collator``, ``opts_regex``, ``opts_fixed``, and so on                                                                                           |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``mode``                                   | single string; one of: ``'first'`` (the default), ``'all'``, ``'last'``                                                                                                                                                                              |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``pattern, regex, fixed, coll, charclass`` | character vector; search patterns; for more details refer to `stringi-search <stringi-search.html>`__                                                                                                                                                |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``merge``                                  | single logical value; should consecutive matches be merged into one string; ``stri_replace_all_charclass`` only                                                                                                                                      |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``vectorize_all``                          | single logical value; should each occurrence of a pattern in every string be replaced by a corresponding replacement string?; ``stri_replace_all_*`` only                                                                                            |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``vectorise_all``                          | alias of ``vectorize_all``                                                                                                                                                                                                                           |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_collator, opts_fixed, opts_regex``  | a named list used to tune up the search engine's settings; see `stri_opts_collator <stri_opts_collator.html>`__, `stri_opts_fixed <stri_opts_fixed.html>`__, and `stri_opts_regex <stri_opts_regex.html>`__, respectively; ``NULL`` for the defaults |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

By default, all the functions are vectorized over ``str``, ``pattern``, ``replacement`` (with recycling of the elements in the shorter vector if necessary). Input that is not part of any match is left unchanged; each match is replaced in the result by the replacement string.

However, for ``stri_replace_all*``, if ``vectorize_all`` is ``FALSE``, the each substring matching any of the supplied ``pattern``\ s is replaced by a corresponding ``replacement`` string. In such a case, the vectorization is over ``str``, and - independently - over ``pattern`` and ``replacement``. In other words, this is equivalent to something like ``for (i in 1:npatterns) str <- stri_replace_all(str, pattern[i], replacement[i]``. Note that you must set ``length(pattern) >= length(replacement)``.

In case of ``stri_replace_*_regex``, the replacement string may contain references to capture groups (in round parentheses). References are of the form ``$n``, where ``n`` is the number of the capture group (``$1`` denotes the first group). For the literal ``$``, escape it with a backslash. Moreover, ``${name}`` are used for named capture groups.

``stri_replace``, ``stri_replace_all``, ``stri_replace_first``, and ``stri_replace_last`` are convenience functions; they just call ``stri_replace_*_*`` variants, depending on the arguments used.

If you wish to remove white-spaces from the start or end of a string, see `stri_trim <stri_trim.html>`__.

Value
~~~~~

All the functions return a character vector.

See Also
~~~~~~~~

Other search_replace: `stri_trim_both() <stri_trim.html>`__, `stringi-search <stringi-search.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_replace_all_charclass('aaaa', '[a]', 'b', merge=c(TRUE, FALSE))

   stri_replace_all_charclass('a\nb\tc   d', '\\p{WHITE_SPACE}', ' ')
   stri_replace_all_charclass('a\nb\tc   d', '\\p{WHITE_SPACE}', ' ', merge=TRUE)

   s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
   stri_replace_all_fixed(s, ' ', '#')
   stri_replace_all_fixed(s, 'o', '0')

   stri_replace_all_fixed(c('1', 'NULL', '3'), 'NULL', NA)

   stri_replace_all_regex(s, ' .*? ', '#')
   stri_replace_all_regex(s, '(el|s)it', '1234')
   stri_replace_all_regex('abaca', 'a', c('!', '*'))
   stri_replace_all_regex('123|456|789', '(\\p{N}).(\\p{N})', '$2-$1')
   stri_replace_all_regex(c('stringi R', 'REXAMINE', '123'), '( R|R.)', ' r ')

   ## Not run: 
   # named capture groups available since ICU 55
   stri_replace_all_regex('words 123 and numbers 456',
      '(?<numbers>[0-9]+)', '!${numbers}!')

   ## End(Not run)

   # Compare the results:
   stri_replace_all_fixed('The quick brown fox jumped over the lazy dog.',
        c('quick', 'brown', 'fox'), c('slow',  'black', 'bear'), vectorize_all=TRUE)
   stri_replace_all_fixed('The quick brown fox jumped over the lazy dog.',
        c('quick', 'brown', 'fox'), c('slow',  'black', 'bear'), vectorize_all=FALSE)

   # Compare the results:
   stri_replace_all_fixed('The quicker brown fox jumped over the lazy dog.',
        c('quick', 'brown', 'fox'), c('slow',  'black', 'bear'), vectorize_all=FALSE)
   stri_replace_all_regex('The quicker brown fox jumped over the lazy dog.',
        '\\b'%s+%c('quick', 'brown', 'fox')%s+%'\\b', c('slow',  'black', 'bear'), vectorize_all=FALSE)

