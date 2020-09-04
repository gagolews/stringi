stri_read_lines: Read Text Lines from a Text File
=================================================

Description
~~~~~~~~~~~

Reads a text file in ins entirety, re-encodes it, and splits it into text lines.

Usage
~~~~~

.. code-block:: r

   stri_read_lines(con, encoding = NULL, fname = con, fallback_encoding = NULL)

Arguments
~~~~~~~~~

+-----------------------+-------------------------------------------------------------------------------------+
| ``con``               | name of the output file or a connection object (opened in the binary mode)          |
+-----------------------+-------------------------------------------------------------------------------------+
| ``encoding``          | single string; input encoding; ``NULL`` or ``''`` for the current default encoding. |
+-----------------------+-------------------------------------------------------------------------------------+
| ``fname``             | deprecated alias of ``con``                                                         |
+-----------------------+-------------------------------------------------------------------------------------+
| ``fallback_encoding`` | deprecated argument, no longer used                                                 |
+-----------------------+-------------------------------------------------------------------------------------+

Details
~~~~~~~

This aims to be a substitute for the ``readLines`` function, with the ability to re-encode the input file in a much more robust way, and split the text into lines with `stri_split_lines1 <stri_split_lines.html>`__ (which conforms with the Unicode guidelines for newline markers).

The function calls `stri_read_raw <stri_read_raw.html>`__, `stri_encode <stri_encode.html>`__, and `stri_split_lines1 <stri_split_lines.html>`__, in this order.

Because of the way this function is currently implemented, maximal file size cannot exceed ~0.67 GB.

Value
~~~~~

Returns a character vector, each text line is a separate string. The output is always marked as UTF-8.

See Also
~~~~~~~~

Other files: `stri_read_raw() <stri_read_raw.html>`__, `stri_write_lines() <stri_write_lines.html>`__
