stri_read_lines: [DRAFT API] Read Text Lines from a Text File
=============================================================

Description
~~~~~~~~~~~

Reads a text file, re-encodes it, and splits it into text lines.

**[THIS IS AN EXPERIMENTAL FUNCTION]**

Usage
~~~~~

.. code-block:: r

   stri_read_lines(
     fname,
     encoding = "auto",
     locale = NA,
     fallback_encoding = stri_enc_get()
   )

Arguments
~~~~~~~~~

+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``fname``             | single string with file name                                                                                                                                                  |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``encoding``          | single string; input encoding, ``"auto"`` for automatic detection with `stri_enc_detect2 <stri_enc_detect2.html>`__, and ``NULL`` or ``""`` for the current default encoding. |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale``            | single string passed to `stri_enc_detect2 <stri_enc_detect2.html>`__; ``NULL`` or ``""`` for default locale, ``NA`` for checking just UTF-\* family                           |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``fallback_encoding`` | single string; encoding to be used if encoding detection fails; defaults to the current default encoding, see `stri_enc_get <stri_enc_set.html>`__                            |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

This aims to be a substitute for the ``readLines`` function, with the ability to auto-detect input encodings (or to specify one manually), re-encode input without any strange function calls or sys options change, and split the text into lines with `stri_split_lines1 <stri_split_lines.html>`__ (which conforms with the Unicode guidelines for newline markers).

If ``locale`` is ``NA`` and auto-detection of UTF-32/16/8 fails, then ``fallback_encoding`` is used.

Value
~~~~~

Returns a character vector, each text line is a separate string. The output is always in UTF-8.

See Also
~~~~~~~~

Other files: `stri_read_raw() <stri_read_raw.html>`__, `stri_write_lines() <stri_write_lines.html>`__
