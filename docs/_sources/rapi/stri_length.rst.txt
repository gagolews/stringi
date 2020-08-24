stri_length: Count the Number of Code Points
============================================

Description
~~~~~~~~~~~

This function returns the number of code points in each string.

Usage
~~~~~

.. code-block:: r

   stri_length(str)

Arguments
~~~~~~~~~

+---------+--------------------------------------------+
| ``str`` | character vector or an object coercible to |
+---------+--------------------------------------------+

Details
~~~~~~~

Note that the number of code points is not the same as the 'width' of the string when printed on the console.

If a given string is in UTF-8 and has not been properly normalized (e.g., by `stri_trans_nfc <stri_trans_nf.html>`__), the returned counts may sometimes be misleading. See `stri_count_boundaries <stri_count_boundaries.html>`__ for a method to count *Unicode characters*. Moreover, if an incorrect UTF-8 byte sequence is detected, then a warning is generated and the corresponding output element is set to ``NA``, see also `stri_enc_toutf8 <stri_enc_toutf8.html>`__ for a method to deal with such cases.

Missing values are handled properly. For 'byte' encodings we get, as usual, an error.

Value
~~~~~

Returns an integer vector of the same length as ``str``.

See Also
~~~~~~~~

Other length: `stri_isempty() <stri_isempty.html>`__, `stri_numbytes() <stri_numbytes.html>`__, `stri_width() <stri_width.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_length(LETTERS)
   stri_length(c('abc', '123', '\u0105\u0104'))
   stri_length('\u0105') # length is one, but...
   stri_numbytes('\u0105') # 2 bytes are used
   stri_numbytes(stri_trans_nfkd('\u0105')) # 3 bytes here but...
   stri_length(stri_trans_nfkd('\u0105')) # ...two code points (!)
   stri_count_boundaries(stri_trans_nfkd('\u0105'), type='character') # ...and one Unicode character

