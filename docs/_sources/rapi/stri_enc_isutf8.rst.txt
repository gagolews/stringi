stri_enc_isutf8: Check If a Data Stream Is Possibly in UTF-8
============================================================

Description
~~~~~~~~~~~

The function checks whether given sequences of bytes forms a proper UTF-8 string.

Usage
~~~~~

.. code-block:: r

   stri_enc_isutf8(str)

Arguments
~~~~~~~~~

======= ============================================================
``str`` character vector, a raw vector, or a list of ``raw`` vectors
======= ============================================================

Details
~~~~~~~

``FALSE`` means that a string is certainly not valid UTF-8. However, false positives are possible. For instance, ``(c4,85)`` represents ('a with ogonek') in UTF-8 as well as ('A umlaut', 'Ellipsis') in WINDOWS-1250. Also note that UTF-8, as well as most 8-bit encodings, extend ASCII (note that `stri_enc_isascii <stri_enc_isascii.html>`__ implies that `stri_enc_isutf8 <stri_enc_isutf8.html>`__).

However, the longer the sequence, the greater the possibility that the result is indeed in UTF-8 – this is because not all sequences of bytes are valid UTF-8.

This function is independent of the way R marks encodings in character strings (see `Encoding <../../base/html/Encoding.html>`__ and `stringi-encoding <about_encoding.html>`__).

Value
~~~~~

Returns a logical vector. Its i-th element indicates whether the i-th string corresponds to a valid UTF-8 byte sequence.

See Also
~~~~~~~~

Other encoding_detection: `about_encoding <about_encoding.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_enc_detect() <stri_enc_detect.html>`__, `stri_enc_isascii() <stri_enc_isascii.html>`__, `stri_enc_isutf16be() <stri_enc_isutf16.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_enc_isutf8(letters[1:3])
   stri_enc_isutf8('\u0105\u0104')
   stri_enc_isutf8('\u1234\u0222')
