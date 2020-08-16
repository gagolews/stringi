stri_dup: Duplicate Strings
===========================

Description
~~~~~~~~~~~

Duplicates each string ``times`` times and concatenates the results.

Usage
~~~~~

.. code-block:: r

   stri_dup(str, times)

Arguments
~~~~~~~~~

+-----------+----------------------------------------------------------------------+
| ``str``   | a character vector of strings to be duplicated                       |
+-----------+----------------------------------------------------------------------+
| ``times`` | an integer vector with the numbers of times to duplicate each string |
+-----------+----------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str`` and ``times``.

Value
~~~~~

Returns a character vector of the same length as ``str``.

See Also
~~~~~~~~

Other join: `%s+%() <oper_plus.html>`__, `stri_flatten() <stri_flatten.html>`__, `stri_join_list() <stri_join_list.html>`__, `stri_join() <stri_join.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_dup("a", 1:5)
   stri_dup(c("a", NA, "ba"), 4)
   stri_dup(c("abc", "pqrst"), c(4, 2))
