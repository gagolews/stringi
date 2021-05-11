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

======= ==================================
``str`` a character vector to be converted
======= ==================================

Details
~~~~~~~

This function just calls `stri_encode(str, NULL, NULL)`_. The current native encoding can be read with `stri_enc_get`_. Character strings declared to be in ``bytes`` encoding will fail here.

Note that if working in a UTF-8 environment, resulting strings will be marked with ``UTF-8`` and not ``native``, see `stri_enc_mark`_.

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other encoding_conversion: `about_encoding`_, `stri_enc_fromutf32()`_, `stri_enc_toascii()`_, `stri_enc_toutf32()`_, `stri_enc_toutf8()`_, `stri_encode()`_

.. _stri_encode(str, NULL, NULL): stri_encode.html
.. _stri_enc_get: stri_enc_set.html
.. _stri_enc_mark: stri_enc_mark.html
.. _about_encoding: about_encoding.html
.. _stri_enc_fromutf32(): stri_enc_fromutf32.html
.. _stri_enc_toascii(): stri_enc_toascii.html
.. _stri_enc_toutf32(): stri_enc_toutf32.html
.. _stri_enc_toutf8(): stri_enc_toutf8.html
.. _stri_encode(): stri_encode.html
