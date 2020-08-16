stri_numbytes: Count the Number of Bytes
========================================

Description
~~~~~~~~~~~

Counts the number of bytes needed to store each string in the computer's memory.

Usage
~~~~~

.. code-block:: r

   stri_numbytes(str)

Arguments
~~~~~~~~~

+---------+--------------------------------------------+
| ``str`` | character vector or an object coercible to |
+---------+--------------------------------------------+

Details
~~~~~~~

Often, this is not the function you would normally use in your string processing activities. See `stri_length <stri_length.html>`__ instead.

For 8-bit encoded strings, this is the same as `stri_length <stri_length.html>`__. For UTF-8 strings, the returned values may be greater than the number of code points, as UTF-8 is not a fixed-byte encoding: one code point may be encoded by 1-4 bytes (according to the current Unicode standard).

Missing values are handled properly.

The strings do not need to be re-encoded to perform this operation.

The returned values do not include the trailing NUL bytes, which are used internally to mark the end of string data (in C).

Value
~~~~~

Returns an integer vector of the same length as ``str``.

See Also
~~~~~~~~

Other length: `stri_isempty() <stri_isempty.html>`__, `stri_length() <stri_length.html>`__, `stri_width() <stri_width.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_numbytes(letters)
   stri_numbytes(c('abc', '123', '\u0105\u0104'))

   ## Not run: 
   # this used to fail on Windows, as there was no native support for 4-bytes
   # Unicode characters; see, however, stri_escape_unicode():
   stri_numbytes('\U7fffffff') # compare stri_length('\U7fffffff')

   ## End(Not run)

