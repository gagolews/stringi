stri_escape_unicode: Escape Unicode Code Points
===============================================

Description
~~~~~~~~~~~

Escapes all Unicode (not ASCII-printable) code points.

Usage
~~~~~

.. code-block:: r

   stri_escape_unicode(str)

Arguments
~~~~~~~~~

+---------+------------------+
| ``str`` | character vector |
+---------+------------------+

Details
~~~~~~~

For non-printable and certain special (well-known, see also R man page `Quotes <../../base/html/Quotes.html>`__) ASCII characters the following (also recognized in R) convention is used. We get ``\a``, ``\b``, ``\t``, ``\n``, ``\v``, ``\f``, ``\r``, ``\"``, ``\'``, ``\\`` or either \\uXXXX (4 hex digits) or \\UXXXXXXXX (8 hex digits) otherwise.

As usual, any input string is converted to Unicode before executing the escape process.

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other escape: `stri_unescape_unicode() <stri_unescape_unicode.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_escape_unicode("a\u0105!")

