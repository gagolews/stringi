stri_trim: Trim Characters from the Left and/or Right Side of a String
======================================================================

Description
~~~~~~~~~~~

These functions may be used, e.g., to remove unnecessary white-spaces from strings. Trimming ends at the first or starts at the last ``pattern`` match.

Usage
~~~~~

.. code-block:: r

   stri_trim_both(str, pattern = "\\P{Wspace}")

   stri_trim_left(str, pattern = "\\P{Wspace}")

   stri_trim_right(str, pattern = "\\P{Wspace}")

   stri_trim(str, side = c("both", "left", "right"), pattern = "\\P{Wspace}")

Arguments
~~~~~~~~~

+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``     | a character vector of strings to be trimmed                                                                                                                              |
+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``pattern`` | a single pattern, specifying character classes that should be preserved (see `stringi-search-charclass <stringi-search-charclass.html>`__). Defaults to '``\P{Wspace}``. |
+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``side``    | character [``stri_trim`` only]; defaults to ``'both'``                                                                                                                   |
+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str`` and ``pattern``.

``stri_trim`` is a convenience wrapper over ``stri_trim_left`` and ``stri_trim_right``.

Contrary to many other string processing libraries, our trimming functions are universal. A character class, given by ``pattern``, may be adjusted to suit your needs (yet, most often you stick to the default value).

For replacing pattern matches with arbitrary replacement string, see `stri_replace <stri_replace.html>`__.

Trimming can also be used where you would normally rely on regular expressions. For instance, you may get ``'23.5'`` out of ``'total of 23.5 bitcoins'``.

For trimming white-spaces, please note the difference between Unicode binary property '``\p{Wspace}``' (more universal) and general character category '``\p{Z}``', see `stringi-search-charclass <stringi-search-charclass.html>`__.

Value
~~~~~

All these functions return a character vector.

See Also
~~~~~~~~

Other search_replace: `stri_replace_all() <stri_replace.html>`__, `stringi-search <stringi-search.html>`__

Other search_charclass: `stringi-search-charclass <stringi-search-charclass.html>`__, `stringi-search <stringi-search.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_trim_left('               aaa')
   stri_trim_right('r-project.org/', '\\p{P}')
   stri_trim_both(' Total of 23.5 bitcoins. ', '\\p{N}')
   stri_trim_both(' Total of 23.5 bitcoins. ', '\\p{L}')

