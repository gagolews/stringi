stri_enc_toutf32: Convert Strings To UTF-32
===========================================

Description
~~~~~~~~~~~

UTF-32 is a 32-bit encoding where each Unicode code point corresponds to exactly one integer value. This function converts a character vector to a list of integer vectors so that, e.g., individual code points may be easily accessed, changed, etc.

Usage
~~~~~

.. code-block:: r

   stri_enc_toutf32(str)

Arguments
~~~~~~~~~

+---------+----------------------------------------------------------------+
| ``str`` | a character vector (or an object coercible to) to be converted |
+---------+----------------------------------------------------------------+

Details
~~~~~~~

See `stri_enc_fromutf32 <stri_enc_fromutf32.html>`__ for a dual operation.

This function is roughly equivalent to a vectorized call to ``utf8ToInt(enc2utf8(str))``. If you want a list of raw vectors on output, use `stri_encode <stri_encode.html>`__.

Unlike ``utf8ToInt``, if ill-formed UTF-8 byte sequences are detected, a corresponding element is set to NULL and a warning is generated. To deal with such issues, use, e.g., `stri_enc_toutf8 <stri_enc_toutf8.html>`__.

Value
~~~~~

Returns a list of integer vectors. Missing values are converted to ``NULL``\ s.

See Also
~~~~~~~~

Other encoding_conversion: `stri_enc_fromutf32() <stri_enc_fromutf32.html>`__, `stri_enc_toascii() <stri_enc_toascii.html>`__, `stri_enc_tonative() <stri_enc_tonative.html>`__, `stri_enc_toutf8() <stri_enc_toutf8.html>`__, `stri_encode() <stri_encode.html>`__, `stringi-encoding <stringi-encoding.html>`__
