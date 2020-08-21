stri_read_raw: Read Text File as Raw
====================================

Description
~~~~~~~~~~~

Reads a text file as-is, with no conversion or text line splitting.

Usage
~~~~~

.. code-block:: r

   stri_read_raw(con)

Arguments
~~~~~~~~~

+---------+----------------------------------------------------------------------------+
| ``con`` | name of the output file or a connection object (opened in the binary mode) |
+---------+----------------------------------------------------------------------------+

Details
~~~~~~~

Once a text file is read into memory, encoding detection (see `stri_enc_detect <stri_enc_detect.html>`__), conversion (see `stri_encode <stri_encode.html>`__), and/or splitting of text into lines (see `stri_split_lines1 <stri_split_lines.html>`__) can be performed.

Value
~~~~~

Returns a vector of type ``raw``.

See Also
~~~~~~~~

Other files: `stri_read_lines() <stri_read_lines.html>`__, `stri_write_lines() <stri_write_lines.html>`__
