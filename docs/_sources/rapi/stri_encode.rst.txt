stri_encode: Convert Strings Between Given Encodings
====================================================

Description
~~~~~~~~~~~

These functions convert strings between encodings. They aim to replace R's ``iconv``. They are not only faster, but also much more portable - they work in the same manner on all platforms.

Usage
~~~~~

.. code-block:: r

   stri_encode(str, from = NULL, to = NULL, to_raw = FALSE)

   stri_conv(str, from = NULL, to = NULL, to_raw = FALSE)

Arguments
~~~~~~~~~

+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``    | a character vector, a raw vector, or a list of ``raw`` vectors to be converted                                                                                                                         |
+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``from``   | input encoding: ``NULL`` or ``""`` for the default encoding or internal encoding marks' usage (see Details); otherwise, a single string with encoding name, see `stri_enc_list <stri_enc_list.html>`__ |
+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``to``     | target encoding: ``NULL`` or ``""`` for default encoding (see `stri_enc_get <stri_enc_set.html>`__), or a single string with encoding name                                                             |
+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``to_raw`` | a single logical value; indicates whether a list of raw vectors rather than a character vector should be returned                                                                                      |
+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

``stri_conv`` is an alias for ``stri_encode``.

Please refer to `stri_enc_list <stri_enc_list.html>`__ for the list of supported encodings and `stringi-encoding <stringi-encoding.html>`__ for a general discussion.

If ``str`` is a character vector and ``from`` is either missing, ``""``, or ``NULL``, then the declared encodings are used (see `stri_enc_mark <stri_enc_mark.html>`__) – in such a case ``bytes``-declared strings are disallowed. Otherwise, the internal encoding declarations are ignored and a converter selected via ``from`` is used.

If ``str`` is a ``raw``-type vector or a list of raw vectors, we assume that the input encoding is the current default encoding as given by `stri_enc_get <stri_enc_set.html>`__.

For ``to_raw=FALSE``, the output strings have always marked encodings according to the target converter used (as specified by ``to``) and the current default Encoding (``ASCII``, ``latin1``, ``UTF-8``, ``native``, or ``bytes`` in all other cases).

Note that some issues might occur if ``to`` indicates, e.g, UTF-16 or UTF-32, as the output strings may have embedded NULs. In such cases, please use ``to_raw=TRUE`` and consider specifying a byte order marker (BOM) for portability reasons (e.g., set ``UTF-16`` or ``UTF-32`` which automatically adds the BOMs).

Note that ``stri_encode(as.raw(data), "encodingname")`` is a clever substitute for ``rawToChar``.

In the current version of stringi, if an incorrect code point is found on input, it is replaced by the default (for that target encoding) substitute character. Also, in such a case a warning is generated.

Value
~~~~~

If ``to_raw`` is ``FALSE``, then a character vector with encoded strings (and appropriate encoding marks) is returned. Otherwise, a list of raw vectors is produced.

References
~~~~~~~~~~

*Conversion* – ICU User Guide, http://userguide.icu-project.org/conversion

*Converters* – ICU User Guide, http://userguide.icu-project.org/conversion/converters (technical details)

See Also
~~~~~~~~

Other encoding_conversion: `stri_enc_fromutf32() <stri_enc_fromutf32.html>`__, `stri_enc_toascii() <stri_enc_toascii.html>`__, `stri_enc_tonative() <stri_enc_tonative.html>`__, `stri_enc_toutf32() <stri_enc_toutf32.html>`__, `stri_enc_toutf8() <stri_enc_toutf8.html>`__, `stringi-encoding <stringi-encoding.html>`__
