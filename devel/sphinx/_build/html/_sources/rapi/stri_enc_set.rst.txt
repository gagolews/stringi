stri_enc_set: Set or Get Default Character Encoding in stringi
==============================================================

Description
~~~~~~~~~~~

``stri_enc_set`` sets the encoding used to re-encode strings internally (i.e., by R) declared to be in native encoding, see `stringi-encoding <about_encoding.html>`__ and `stri_enc_mark <stri_enc_mark.html>`__. ``stri_enc_get`` returns the currently used default encoding.

Usage
~~~~~

.. code-block:: r

   stri_enc_set(enc)

   stri_enc_get()

Arguments
~~~~~~~~~

+---------+-------------------------------------------------------------------------------------------------------------------------+
| ``enc`` | single string; character encoding name, see `stri_enc_list <stri_enc_list.html>`__ for the list of supported encodings. |
+---------+-------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

``stri_enc_get`` is the same as `stri_enc_info(NULL)$Name.friendly <stri_enc_info.html>`__.

Note that changing the default encoding may have undesired consequences. Unless you are an expert user and you know what you are doing, ``stri_enc_set`` should only be used if ICU fails to detect your system's encoding correctly (while testing stringi we only encountered such a situation on a very old Solaris machine). Note that ICU tries to match the encoding part of the ``LC_CTYPE`` category as given by ``Sys.getlocale``.

If you set a default encoding that is neither a superset of ASCII, nor an 8-bit encoding, a warning will be generated, see `stringi-encoding <about_encoding.html>`__ for discussion.

``stri_enc_set`` has no effect if the system ICU assumes that the default charset is always UTF-8 (i.e., where the internal ``U_CHARSET_IS_UTF8`` is defined and set to 1), see `stri_info <stri_info.html>`__.

Value
~~~~~

``stri_enc_set`` returns a string with previously used character encoding, invisibly.

``stri_enc_get`` returns a string with current default character encoding.

See Also
~~~~~~~~

Other encoding_management: `about_encoding <about_encoding.html>`__, `stri_enc_info() <stri_enc_info.html>`__, `stri_enc_list() <stri_enc_list.html>`__, `stri_enc_mark() <stri_enc_mark.html>`__
