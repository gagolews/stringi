stri_join_list: Concatenate Strings in a List
=============================================

Description
~~~~~~~~~~~

These functions concatenate all the strings in each character vector in a given list. ``stri_c_list`` and ``stri_paste_list`` are aliases for ``stri_join_list``.

Usage
~~~~~

.. code-block:: r

   stri_join_list(x, sep = "", collapse = NULL)

   stri_c_list(x, sep = "", collapse = NULL)

   stri_paste_list(x, sep = "", collapse = NULL)

Arguments
~~~~~~~~~

+--------------+------------------------------------------------------------------------------+
| ``x``        | a list consisting of character vectors                                       |
+--------------+------------------------------------------------------------------------------+
| ``sep``      | a single string; separates strings in each of the character vectors in ``x`` |
+--------------+------------------------------------------------------------------------------+
| ``collapse`` | a single string or ``NULL``; an optional results separator                   |
+--------------+------------------------------------------------------------------------------+

Details
~~~~~~~

Unless ``collapse`` is ``NULL``, the result will be a single string. Otherwise, you get a character vector of length equal to the length of ``x``.

Vectors in ``x`` of length 0 are silently ignored.

If ``collapse`` or ``sep`` has length greater than 1, then only the first string will be used.

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other join: `%s+%() <operator_add.html>`__, `stri_dup() <stri_dup.html>`__, `stri_flatten() <stri_flatten.html>`__, `stri_join() <stri_join.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_join_list(
      stri_extract_all_words(c('Lorem ipsum dolor sit amet.',
      'Spam spam bacon sausage and spam.')),
   sep=', ')

   stri_join_list(
      stri_extract_all_words(c('Lorem ipsum dolor sit amet.',
      'Spam spam bacon sausage and spam.')),
   sep=', ', collapse='. ')

   stri_join_list(
      stri_extract_all_regex(
         c('spam spam bacon', '123 456', 'spam 789 sausage'), '\\p{L}+'
      ),
   sep=',')

   stri_join_list(
      stri_extract_all_regex(
         c('spam spam bacon', '123 456', 'spam 789 sausage'), '\\p{L}+',
         omit_no_match=TRUE
      ),
   sep=',', collapse='; ')

