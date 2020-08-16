stri_enc_tonative: Convert Strings To Native Encoding
=====================================================

Description
~~~~~~~~~~~

Converts character strings with declared encodings to the current native encoding.

Usage
~~~~~

.. code-block:: r

   stri_enc_tonative(str)

Arguments
~~~~~~~~~

+---------+------------------------------------+
| ``str`` | a character vector to be converted |
+---------+------------------------------------+

Details
~~~~~~~

This function just calls `stri_encode(str, NULL, NULL) <stri_encode.html>`__. The current native encoding can be read with `stri_enc_get <stri_enc_set.html>`__. Character strings declared to be in ``bytes`` encoding will fail here.

Note that if working in a UTF-8 environment, resulting strings will be marked with ``UTF-8`` and not ``native``, see `stri_enc_mark <stri_enc_mark.html>`__.

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other encoding_conversion: `stri_enc_fromutf32() <stri_enc_fromutf32.html>`__, `stri_enc_toascii() <stri_enc_toascii.html>`__, `stri_enc_toutf32() <stri_enc_toutf32.html>`__, `stri_enc_toutf8() <stri_enc_toutf8.html>`__, `stri_encode() <stri_encode.html>`__, `stringi-encoding <stringi-encoding.html>`__
