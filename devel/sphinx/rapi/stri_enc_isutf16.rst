stri_enc_isutf16: Check If a Data Stream Is Possibly in UTF16 or UTF32
======================================================================

Description
~~~~~~~~~~~

These functions detect whether a given byte stream is valid UTF-16LE, UTF-16BE, UTF-32LE, or UTF-32BE.

Usage
~~~~~

.. code-block:: r

   stri_enc_isutf16be(str)

   stri_enc_isutf16le(str)

   stri_enc_isutf32be(str)

   stri_enc_isutf32le(str)

Arguments
~~~~~~~~~

+---------+--------------------------------------------------------------+
| ``str`` | character vector, a raw vector, or a list of ``raw`` vectors |
+---------+--------------------------------------------------------------+

Details
~~~~~~~

These functions are independent of the way R marks encodings in character strings (see `Encoding <../../base/html/Encoding.html>`__ and `stringi-encoding <stringi-encoding.html>`__). Most often, these functions act on raw vectors.

A result of ``FALSE`` means that a string is surely not valid UTF-16 or UTF-32. However, false positives are possible.

Also note that a data stream may be sometimes classified as both valid UTF-16LE and UTF-16BE.

Value
~~~~~

Returns a logical vector.

See Also
~~~~~~~~

Other encoding_detection: `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_enc_detect() <stri_enc_detect.html>`__, `stri_enc_isascii() <stri_enc_isascii.html>`__, `stri_enc_isutf8() <stri_enc_isutf8.html>`__, `stringi-encoding <stringi-encoding.html>`__
