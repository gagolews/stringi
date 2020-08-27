stri_dup: Duplicate Strings
===========================

Description
~~~~~~~~~~~

Duplicates each ``str``\ (``e1``) string ``times``\ (``e2``) times and concatenates the results.

Usage
~~~~~

.. code-block:: r

   stri_dup(str, times)

   e1 %s*% e2

   e1 %stri*% e2

Arguments
~~~~~~~~~

+---------------+----------------------------------------------------------------------+
| ``str, e1``   | a character vector of strings to be duplicated                       |
+---------------+----------------------------------------------------------------------+
| ``times, e2`` | an integer vector with the numbers of times to duplicate each string |
+---------------+----------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over all arguments.

``e1 %s*% e2`` and ``e1 %stri*% e2`` are synonyms for ``stri_dup(e1, e2)``

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other join: `%s+%() <operator_add.html>`__, `stri_flatten() <stri_flatten.html>`__, `stri_join_list() <stri_join_list.html>`__, `stri_join() <stri_join.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_dup('a', 1:5)
   stri_dup(c('a', NA, 'ba'), 4)
   stri_dup(c('abc', 'pqrst'), c(4, 2))
   "a" %s*% 5
