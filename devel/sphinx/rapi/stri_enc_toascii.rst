stri_enc_toascii: Convert To ASCII
==================================

Description
~~~~~~~~~~~

This function converts input strings to ASCII, i.e., to character strings consisting of bytes not greater than 127.

Usage
~~~~~

.. code-block:: r

   stri_enc_toascii(str)

Arguments
~~~~~~~~~

+---------+------------------------------------+
| ``str`` | a character vector to be converted |
+---------+------------------------------------+

Details
~~~~~~~

All code points greater than 127 are replaced with the ASCII SUBSTITUTE CHARACTER (0x1A). R encoding declarations are always used to determine which encoding is assumed for each input, see `stri_enc_mark <stri_enc_mark.html>`__. If ill-formed byte sequences are found in UTF-8 byte streams, a warning is generated.

A ``bytes``-marked string is assumed to be in an 8-bit encoding extending the ASCII map (a common assumption in R itself).

Note that the SUBSTITUTE CHARACTER (``\x1a == \032``) may be interpreted as the ASCII missing value for single characters.

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other encoding_conversion: `about_encoding <about_encoding.html>`__, `stri_enc_fromutf32() <stri_enc_fromutf32.html>`__, `stri_enc_tonative() <stri_enc_tonative.html>`__, `stri_enc_toutf32() <stri_enc_toutf32.html>`__, `stri_enc_toutf8() <stri_enc_toutf8.html>`__, `stri_encode() <stri_encode.html>`__
