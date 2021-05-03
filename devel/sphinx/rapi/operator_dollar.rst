operator_dollar: C-Style Formatting with sprintf as a Binary Operator
=====================================================================

Description
~~~~~~~~~~~

Provides access to base R's ``sprintf`` in form of a binary operator in a way similar to Python's ``%`` overloaded for strings.

Usage
~~~~~

.. code-block:: r

   e1 %s$% e2

   e1 %stri$% e2

Arguments
~~~~~~~~~

+--------+--------------------------------------------------------------------------------+
| ``e1`` | format strings, see ``sprintf`` for syntax                                     |
+--------+--------------------------------------------------------------------------------+
| ``e2`` | a list of atomic vectors to be passed to ``sprintf`` or a single atomic vector |
+--------+--------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``e1`` and ``e2``.

``e1 %s$% atomic_vector`` is equivalent to ``e1 %s$% list(atomic_vector)``.

Note that ``sprintf`` takes field width in bytes, not Unicode code points. See Examples for a workaround.

Value
~~~~~

Returns a character vector.

Examples
~~~~~~~~

.. code-block:: r

   "value='%d'" %s$% 3
   "value='%d'" %s$% 1:3
   "%s='%d'" %s$% list("value", 3)
   "%s='%d'" %s$% list("value", 1:3)
   "%s='%d'" %s$% list(c("a", "b", "c"), 1)
   "%s='%d'" %s$% list(c("a", "b", "c"), 1:3)

   # sprintf field width:
   cat(sprintf("%6s%6s%6s", "-", c("asc", "ąść", "abcdefg"), "-"), sep="\n")
   cat(sprintf("%6s%s%6s", "-", stringi::stri_pad(c("asc", "ąść", "abcdefg"), 6), "-"), sep="\n")
