stri_join: Concatenate Character Vectors
========================================

Description
~~~~~~~~~~~

These are the stringi's equivalents of the built-in ``paste`` function. ``stri_c`` and ``stri_paste`` are aliases for ``stri_join``.

Usage
~~~~~

.. code-block:: r

   stri_join(..., sep = "", collapse = NULL, ignore_null = FALSE)

   stri_c(..., sep = "", collapse = NULL, ignore_null = FALSE)

   stri_paste(..., sep = "", collapse = NULL, ignore_null = FALSE)

Arguments
~~~~~~~~~

+-----------------+-------------------------------------------------------------------------------------------------------------------+
| ``...``         | character vectors (or objects coercible to character vectors) which corresponding elements are to be concatenated |
+-----------------+-------------------------------------------------------------------------------------------------------------------+
| ``sep``         | a single string; separates terms                                                                                  |
+-----------------+-------------------------------------------------------------------------------------------------------------------+
| ``collapse``    | a single string or ``NULL``; an optional results separator                                                        |
+-----------------+-------------------------------------------------------------------------------------------------------------------+
| ``ignore_null`` | a single logical value; if ``TRUE``, then empty vectors provided via ``...`` are silently ignored                 |
+-----------------+-------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over each atomic vector in '``...``'.

Unless ``collapse`` is ``NULL``, the result will be a single string. Otherwise, you get a character vector of length equal to the length of the longest argument.

If any of the arguments in '``...``' is a vector of length 0 (not to be confused with vectors of empty strings) and ``ignore_null=FALSE``, then you will get a 0-length character vector in result.

If ``collapse`` or ``sep`` has length greater than 1, then only the first string will be used.

In case where there are missing values in any of the input vectors, ``NA`` is set to the corresponding element. Note that this behavior is different from ``paste``, which treats missing values as ordinary strings like ``"NA"``. Moreover, as usual in stringi, the resulting strings are always in UTF-8.

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other join: `%s+%() <oper_plus.html>`__, `stri_dup() <stri_dup.html>`__, `stri_flatten() <stri_flatten.html>`__, `stri_join_list() <stri_join_list.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_join(1:13, letters)
   stri_join(1:13, letters, sep=',')
   stri_join(1:13, letters, collapse='; ')
   stri_join(1:13, letters, sep=',', collapse='; ')
   stri_join(c('abc', '123', 'xyz'),'###', 1:6, sep=',')
   stri_join(c('abc', '123', 'xyz'),'###', 1:6, sep=',', collapse='; ')

