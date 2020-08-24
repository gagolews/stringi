stri_subset: Select Elements that Match a Given Pattern
=======================================================

Description
~~~~~~~~~~~

These functions return or modify a sub-vector where there is a match a given pattern. In other words, they are roughly equivalent (but faster and easier to use) to a call to ``str[stri_detect(str, ...)]`` or ``str[stri_detect(str, ...)] <- value``.

Usage
~~~~~

.. code-block:: r

   stri_subset(str, ..., regex, fixed, coll, charclass)

   stri_subset(str, ..., regex, fixed, coll, charclass) <- value

   stri_subset_fixed(
     str,
     pattern,
     omit_na = FALSE,
     negate = FALSE,
     ...,
     opts_fixed = NULL
   )

   stri_subset_fixed(str, pattern, negate=FALSE, ..., opts_fixed=NULL) <- value

   stri_subset_charclass(str, pattern, omit_na = FALSE, negate = FALSE)

   stri_subset_charclass(str, pattern, negate=FALSE) <- value

   stri_subset_coll(
     str,
     pattern,
     omit_na = FALSE,
     negate = FALSE,
     ...,
     opts_collator = NULL
   )

   stri_subset_coll(str, pattern, negate=FALSE, ..., opts_collator=NULL) <- value

   stri_subset_regex(
     str,
     pattern,
     omit_na = FALSE,
     negate = FALSE,
     ...,
     opts_regex = NULL
   )

   stri_subset_regex(str, pattern, negate=FALSE, ..., opts_regex=NULL) <- value

Arguments
~~~~~~~~~

+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``                                    | character vector; strings to search in                                                                                                                                                                                                               |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``                                    | supplementary arguments passed to the underlying functions, including additional settings for ``opts_collator``, ``opts_regex``, ``opts_fixed``, and so on                                                                                           |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``value``                                  | character vector to be substituted with; replacement function only                                                                                                                                                                                   |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``pattern, regex, fixed, coll, charclass`` | character vector; search patterns; for more details refer to `stringi-search <stringi-search.html>`__; the replacement functions accept only one pattern at a time                                                                                   |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``omit_na``                                | single logical value; should missing values be excluded from the result?                                                                                                                                                                             |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``negate``                                 | single logical value; whether a no-match is rather of interest                                                                                                                                                                                       |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``opts_collator, opts_fixed, opts_regex``  | a named list used to tune up the search engine's settings; see `stri_opts_collator <stri_opts_collator.html>`__, `stri_opts_fixed <stri_opts_fixed.html>`__, and `stri_opts_regex <stri_opts_regex.html>`__, respectively; ``NULL`` for the defaults |
+--------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str``, and ``pattern`` or ``value`` (replacement version) (with recycling of the elements in the shorter vector if necessary).

``stri_subset`` and ``stri_subset<-`` are convenience functions. They call either ``stri_subset_regex``, ``stri_subset_fixed``, ``stri_subset_coll``, or ``stri_subset_charclass``, depending on the argument used.

Value
~~~~~

The ``stri_subset`` functions return a character vector. As usual, the output encoding is always UTF-8.

The ``stri_subset<-`` function modifies the ``str`` object 'in-place'.

See Also
~~~~~~~~

Other search_subset: `stringi-search <stringi-search.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_subset_regex(c('stringi R', '123', 'ID456', ''), '^[0-9]+$')

   x <- c('stringi R', '123', 'ID456', '')
   stri_subset_regex(x, '[^0-9]+|^$') <- NA
   print(x)

   x <- c('stringi R', '123', 'ID456', '')
   stri_subset_regex(x, '^[0-9]+$', negate=TRUE) <- NA
   print(x)

