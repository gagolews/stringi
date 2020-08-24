stri_enc_isascii: Check If a Data Stream Is Possibly in ASCII
=============================================================

Description
~~~~~~~~~~~

The function checks whether all bytes in a string are <= 127.

Usage
~~~~~

.. code-block:: r

   stri_enc_isascii(str)

Arguments
~~~~~~~~~

+---------+--------------------------------------------------------------+
| ``str`` | character vector, a raw vector, or a list of ``raw`` vectors |
+---------+--------------------------------------------------------------+

Details
~~~~~~~

This function is independent of the way R marks encodings in character strings (see `Encoding <../../base/html/Encoding.html>`__ and `stringi-encoding <stringi-encoding.html>`__).

Value
~~~~~

Returns a logical vector. The i-th element indicates whether the i-th string corresponds to a valid ASCII byte sequence.

See Also
~~~~~~~~

Other encoding_detection: `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_enc_detect() <stri_enc_detect.html>`__, `stri_enc_isutf16be() <stri_enc_isutf16.html>`__, `stri_enc_isutf8() <stri_enc_isutf8.html>`__, `stringi-encoding <stringi-encoding.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_enc_isascii(letters[1:3])
   stri_enc_isascii('\u0105\u0104')

