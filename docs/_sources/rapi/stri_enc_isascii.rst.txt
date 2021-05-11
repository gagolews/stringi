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

======= ============================================================
``str`` character vector, a raw vector, or a list of ``raw`` vectors
======= ============================================================

Details
~~~~~~~

This function is independent of the way R marks encodings in character strings (see `Encoding`_ and `stringi-encoding`_).

Value
~~~~~

Returns a logical vector. The i-th element indicates whether the i-th string corresponds to a valid ASCII byte sequence.

See Also
~~~~~~~~

Other encoding_detection: `about_encoding`_, `stri_enc_detect2()`_, `stri_enc_detect()`_, `stri_enc_isutf16be()`_, `stri_enc_isutf8()`_

Examples
~~~~~~~~

.. code-block:: r

   stri_enc_isascii(letters[1:3])
   stri_enc_isascii('\u0105\u0104')

.. _Encoding: ../../base/html/Encoding.html
.. _stringi-encoding: about_encoding.html
.. _about_encoding: about_encoding.html
.. _stri_enc_detect2(): stri_enc_detect2.html
.. _stri_enc_detect(): stri_enc_detect.html
.. _stri_enc_isutf16be(): stri_enc_isutf16.html
.. _stri_enc_isutf8(): stri_enc_isutf8.html
