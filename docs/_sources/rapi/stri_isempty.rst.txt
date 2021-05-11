stri_isempty: Determine if a String is of Length Zero
=====================================================

Description
~~~~~~~~~~~

This is the fastest way to find out whether the elements of a character vector are empty strings.

Usage
~~~~~

.. code-block:: r

   stri_isempty(str)

Arguments
~~~~~~~~~

======= ==========================================
``str`` character vector or an object coercible to
======= ==========================================

Details
~~~~~~~

Missing values are handled properly.

Value
~~~~~

Returns a logical vector of the same length as ``str``.

See Also
~~~~~~~~

Other length: `stri_length()`_, `stri_numbytes()`_, `stri_width()`_

Examples
~~~~~~~~

.. code-block:: r

   stri_isempty(letters[1:3])
   stri_isempty(c(',', '', 'abc', '123', '\u0105\u0104'))
   stri_isempty(character(1))

.. _stri_length(): stri_length.html
.. _stri_numbytes(): stri_numbytes.html
.. _stri_width(): stri_width.html
