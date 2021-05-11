stri_read_raw: Read Text File as Raw
====================================

Description
~~~~~~~~~~~

Reads a text file as-is, with no conversion or text line splitting.

Usage
~~~~~

.. code-block:: r

   stri_read_raw(con, fname = con)

Arguments
~~~~~~~~~

+-----------+----------------------------------------------------------------------------+
| ``con``   | name of the output file or a connection object (opened in the binary mode) |
+-----------+----------------------------------------------------------------------------+
| ``fname`` | deprecated alias of ``con``                                                |
+-----------+----------------------------------------------------------------------------+

Details
~~~~~~~

Once a text file is read into memory, encoding detection (see `stri_enc_detect`_), conversion (see `stri_encode`_), and/or splitting of text into lines (see `stri_split_lines1`_) can be performed.

Value
~~~~~

Returns a vector of type ``raw``.

See Also
~~~~~~~~

Other files: `stri_read_lines()`_, `stri_write_lines()`_

.. _stri_enc_detect: stri_enc_detect.html
.. _stri_encode: stri_encode.html
.. _stri_split_lines1: stri_split_lines.html
.. _stri_read_lines(): stri_read_lines.html
.. _stri_write_lines(): stri_write_lines.html
