stri_info: Query Default Settings for stringi
=============================================

Description
~~~~~~~~~~~

Gives the current default settings used by the ICU library.

Usage
~~~~~

.. code-block:: r

   stri_info(short = FALSE)

Arguments
~~~~~~~~~

+-----------+---------------------------------------------------------------------------------------------+
| ``short`` | logical; whether or not the results should be given in a concise form; defaults to ``TRUE`` |
+-----------+---------------------------------------------------------------------------------------------+

Value
~~~~~

If ``short==TRUE``, then a single string providing information on the default character encoding, locale, and Unicode as well as ICU version is returned.

Otherwise, a list with the following components is returned:

-  ``Unicode.version`` – version of Unicode supported by the ICU library;

-  ``ICU.version`` – ICU library version used;

-  ``Locale`` – contains information on default locale, as returned by `stri_locale_info <stri_locale_info.html>`__;

-  ``Charset.internal`` – fixed at ``c("UTF-8", "UTF-16")``;

-  ``Charset.native`` – information on the default encoding, as returned by `stri_enc_info <stri_enc_info.html>`__;

-  ``ICU.system`` – logical; ``TRUE`` indicates that the system ICU libs are used, otherwise ICU was built together with stringi;

-  ``ICU.UTF8`` – logical; ``TRUE`` if the internal ``U_CHARSET_IS_UTF8`` flag is defined and set.
