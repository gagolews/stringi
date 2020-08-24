stri_locale_info: Query Given Locale
====================================

Description
~~~~~~~~~~~

Provides some basic information on a given locale identifier.

Usage
~~~~~

.. code-block:: r

   stri_locale_info(locale = NULL)

Arguments
~~~~~~~~~

+------------+-----------------------------------------------------------------------------------+
| ``locale`` | ``NULL`` or ``''`` for default locale, or a single string with locale identifier. |
+------------+-----------------------------------------------------------------------------------+

Details
~~~~~~~

With this function you may obtain some basic information on any provided locale identifier, even if it is unsupported by ICU or if you pass a malformed locale identifier (the one that is not, e.g., of the form Language_Country). See `stringi-locale <stringi-locale.html>`__ for discussion.

This function does not do anything really complicated. In many cases it is similar to a call to ``as.list(stri_split_fixed(locale, '_', 3L)[[1]])``, with ``locale`` case mapped. It may be used, however, to get insight on how ICU understands a given locale identifier.

Value
~~~~~

Returns a list with the following named character strings: ``Language``, ``Country``, ``Variant``, and ``Name``, being their underscore separated combination.

See Also
~~~~~~~~

Other locale_management: `stri_locale_list() <stri_locale_list.html>`__, `stri_locale_set() <stri_locale_set.html>`__, `stringi-locale <stringi-locale.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_locale_info('pl_PL')
   stri_locale_info('Pl_pL') # the same result

