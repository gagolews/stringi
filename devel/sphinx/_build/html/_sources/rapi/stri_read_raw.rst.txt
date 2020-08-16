stri_read_raw: [DRAFT API] Read Whole Text File as Raw
======================================================

Description
~~~~~~~~~~~

Reads a text file as-is, with no conversion or text line splitting.

**[THIS IS AN EXPERIMENTAL FUNCTION]**

Usage
~~~~~

.. code-block:: r

   stri_read_raw(fname)

Arguments
~~~~~~~~~

+-----------+-----------+
| ``fname`` | file name |
+-----------+-----------+

Details
~~~~~~~

Once a text file is read into memory, encoding detection (see `stri_enc_detect2 <stri_enc_detect2.html>`__), conversion (see `stri_encode <stri_encode.html>`__), text lines split (see `stri_split_lines1 <stri_split_lines.html>`__) can be performed.

Value
~~~~~

Returns a ``raw``-type vector.

See Also
~~~~~~~~

Other files: `stri_read_lines() <stri_read_lines.html>`__, `stri_write_lines() <stri_write_lines.html>`__
