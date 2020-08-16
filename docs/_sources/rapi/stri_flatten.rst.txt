stri_flatten: Flatten a String
==============================

Description
~~~~~~~~~~~

Joins the elements of a character vector into one string.

Usage
~~~~~

.. code-block:: r

   stri_flatten(str, collapse = "", na_empty = FALSE, omit_empty = FALSE)

Arguments
~~~~~~~~~

+----------------+-------------------------------------------------------------------------------------+
| ``str``        | a vector of strings to be coerced to character                                      |
+----------------+-------------------------------------------------------------------------------------+
| ``collapse``   | a single string denoting the separator                                              |
+----------------+-------------------------------------------------------------------------------------+
| ``na_empty``   | single logical value; should missing values in ``str`` be treated as empty strings? |
+----------------+-------------------------------------------------------------------------------------+
| ``omit_empty`` | single logical value; should missing values in ``str`` be omitted?                  |
+----------------+-------------------------------------------------------------------------------------+

Details
~~~~~~~

The ``stri_flatten(str, collapse='XXX')`` call is equivalent to ``paste(str, collapse='XXX', sep="")``.

If you wish to use some more fancy (e.g., differing) separators between flattened strings, call `stri_join(str, separators, collapse='') <stri_join.html>`__.

If ``str`` is not empty, then a single string is returned. If ``collapse`` has length > 1, then only the first string will be used.

Value
~~~~~

Returns a single string, i.e., a character vector of length 1.

See Also
~~~~~~~~

Other join: `%s+%() <oper_plus.html>`__, `stri_dup() <stri_dup.html>`__, `stri_join_list() <stri_join_list.html>`__, `stri_join() <stri_join.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_flatten(LETTERS)
   stri_flatten(LETTERS, collapse=",")
   stri_flatten(stri_dup(letters[1:6], 1:3))
   stri_flatten(c(NA, "", "A", "", "B", NA, "C"), collapse=",", na_empty=TRUE, omit_empty=TRUE)

