stri_list2matrix: Convert a List to a Character Matrix
======================================================

Description
~~~~~~~~~~~

This function converts a given list of atomic vectors to a character matrix.

Usage
~~~~~

.. code-block:: r

   stri_list2matrix(
     x,
     byrow = FALSE,
     fill = NA_character_,
     n_min = 0,
     by_row = byrow
   )

Arguments
~~~~~~~~~

+------------+------------------------------------------------------------------------------------------------------------------+
| ``x``      | a list of atomic vectors                                                                                         |
+------------+------------------------------------------------------------------------------------------------------------------+
| ``byrow``  | a single logical value; should the resulting matrix be transposed?                                               |
+------------+------------------------------------------------------------------------------------------------------------------+
| ``fill``   | a single string, see Details                                                                                     |
+------------+------------------------------------------------------------------------------------------------------------------+
| ``n_min``  | a single integer value; minimal number of rows (``byrow==FALSE``) or columns (otherwise) in the resulting matrix |
+------------+------------------------------------------------------------------------------------------------------------------+
| ``by_row`` | alias of ``byrow``                                                                                               |
+------------+------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

This function is similar to the built-in `simplify2array`_ function. However, it always returns a character matrix, even if each element in ``x`` is of length 1 or if elements in ``x`` are not of the same lengths. Moreover, the elements in ``x`` are always coerced to character vectors.

If ``byrow`` is ``FALSE``, then a matrix with ``length(x)`` columns is returned. The number of rows is the length of the longest vector in ``x``, but no less than ``n_min``. Basically, we have ``result[i,j] == x[[j]][i]`` if ``i <= length(x[[j]])`` and ``result[i,j] == fill`` otherwise, see Examples.

If ``byrow`` is ``TRUE``, then the resulting matrix is a transposition of the above-described one.

This function may be useful, e.g., in connection with `stri_split`_ and `stri_extract_all`_.

Value
~~~~~

Returns a character matrix.

See Also
~~~~~~~~

Other utils: `stri_na2empty()`_, `stri_remove_empty()`_, `stri_replace_na()`_

Examples
~~~~~~~~

.. code-block:: r

   simplify2array(list(c('a', 'b'), c('c', 'd'), c('e', 'f')))
   stri_list2matrix(list(c('a', 'b'), c('c', 'd'), c('e', 'f')))
   stri_list2matrix(list(c('a', 'b'), c('c', 'd'), c('e', 'f')), byrow=TRUE)

   simplify2array(list('a', c('b', 'c')))
   stri_list2matrix(list('a', c('b', 'c')))
   stri_list2matrix(list('a', c('b', 'c')), fill='')
   stri_list2matrix(list('a', c('b', 'c')), fill='', n_min=5)

.. _simplify2array: https://stat.ethz.ch/R-manual/R-patched/library/base/html/lapply.html
.. _stri_split: stri_split.html
.. _stri_extract_all: stri_extract.html
.. _stri_na2empty(): stri_na2empty.html
.. _stri_remove_empty(): stri_remove_empty.html
.. _stri_replace_na(): stri_replace_na.html
