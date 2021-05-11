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

======= ==============================================================
``str`` a character vector (or an object coercible to) to be converted
======= ==============================================================

Details
~~~~~~~

See `stri_enc_fromutf32`_ for a dual operation.

This function is roughly equivalent to a vectorized call to `utf8ToInt(enc2utf8(str))`_. If you want a list of raw vectors on output, use `stri_encode`_.

Unlike ``utf8ToInt``, if ill-formed UTF-8 byte sequences are detected, a corresponding element is set to NULL and a warning is generated. To deal with such issues, use, e.g., `stri_enc_toutf8`_.

Value
~~~~~

Returns a list of integer vectors. Missing values are converted to ``NULL``\ s.

See Also
~~~~~~~~

Other encoding_conversion: `about_encoding`_, `stri_enc_fromutf32()`_, `stri_enc_toascii()`_, `stri_enc_tonative()`_, `stri_enc_toutf8()`_, `stri_encode()`_

.. _stri_enc_fromutf32: stri_enc_fromutf32.html
.. _utf8ToInt(enc2utf8(str)): https://stat.ethz.ch/R-manual/R-patched/library/base/html/utf8Conversion.html
.. _stri_encode: stri_encode.html
.. _stri_enc_toutf8: stri_enc_toutf8.html
.. _about_encoding: about_encoding.html
.. _stri_enc_fromutf32(): stri_enc_fromutf32.html
.. _stri_enc_toascii(): stri_enc_toascii.html
.. _stri_enc_tonative(): stri_enc_tonative.html
.. _stri_enc_toutf8(): stri_enc_toutf8.html
.. _stri_encode(): stri_encode.html
