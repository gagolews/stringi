stri_enc_set: Set or Get Default Character Encoding in stringi
==============================================================

Description
~~~~~~~~~~~

``stri_enc_set`` sets the encoding used to re-encode strings internally (i.e., by R) declared to be in native encoding, see `stringi-encoding`_ and `stri_enc_mark`_. ``stri_enc_get`` returns the currently used default encoding.

Usage
~~~~~

.. code-block:: r

   stri_enc_set(enc)

   stri_enc_get()

Arguments
~~~~~~~~~

+---------+---------------------------------------------------------------------------------------------------+
| ``enc`` | single string; character encoding name, see `stri_enc_list`_ for the list of supported encodings. |
+---------+---------------------------------------------------------------------------------------------------+

Details
~~~~~~~

``stri_enc_get`` is the same as `stri_enc_info(NULL)$Name.friendly`_.

Note that changing the default encoding may have undesired consequences. Unless you are an expert user and you know what you are doing, ``stri_enc_set`` should only be used if ICU fails to detect your system's encoding correctly (while testing stringi we only encountered such a situation on a very old Solaris machine). Note that ICU tries to match the encoding part of the ``LC_CTYPE`` category as given by `Sys.getlocale`_.

If you set a default encoding that is neither a superset of ASCII, nor an 8-bit encoding, a warning will be generated, see `stringi-encoding`_ for discussion.

``stri_enc_set`` has no effect if the system ICU assumes that the default charset is always UTF-8 (i.e., where the internal ``U_CHARSET_IS_UTF8`` is defined and set to 1), see `stri_info`_.

Value
~~~~~

``stri_enc_set`` returns a string with previously used character encoding, invisibly.

``stri_enc_get`` returns a string with current default character encoding.

See Also
~~~~~~~~

Other encoding_management: `about_encoding`_, `stri_enc_info()`_, `stri_enc_list()`_, `stri_enc_mark()`_

.. _stringi-encoding: about_encoding.html
.. _stri_enc_mark: stri_enc_mark.html
.. _stri_enc_list: stri_enc_list.html
.. _stri_enc_info(NULL)$Name.friendly: stri_enc_info.html
.. _Sys.getlocale: https://stat.ethz.ch/R-manual/R-patched/library/base/html/locales.html
.. _stri_info: stri_info.html
.. _about_encoding: about_encoding.html
.. _stri_enc_info(): stri_enc_info.html
.. _stri_enc_list(): stri_enc_list.html
.. _stri_enc_mark(): stri_enc_mark.html
