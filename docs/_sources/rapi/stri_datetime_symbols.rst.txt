stri_datetime_symbols: List Localizable Date-Time Formatting Data
=================================================================

Description
~~~~~~~~~~~

Returns a list of all localizable date-time formatting data, including month and weekday names, localized AM/PM strings, etc.

Usage
~~~~~

.. code-block:: r

   stri_datetime_symbols(locale = NULL, context = "standalone", width = "wide")

Arguments
~~~~~~~~~

+-------------+----------------------------------------------------------------------------------+
| ``locale``  | ``NULL`` or ``''`` for default locale, or a single string with locale identifier |
+-------------+----------------------------------------------------------------------------------+
| ``context`` | single string; one of: ``'format'``, ``'standalone'``                            |
+-------------+----------------------------------------------------------------------------------+
| ``width``   | single string; one of: ``'abbreviated'``, ``'wide'``, ``'narrow'``               |
+-------------+----------------------------------------------------------------------------------+

Details
~~~~~~~

``context`` stands for a selector for date formatting context and ``width`` - for date formatting width.

Value
~~~~~

Returns a list with the following named components:

#. ``Month`` - month names,

#. ``Weekday`` - weekday names,

#. ``Quarter`` - quarter names,

#. ``AmPm`` - AM/PM names,

#. ``Era`` - era names.

References
~~~~~~~~~~

*Calendar* - ICU User Guide, http://userguide.icu-project.org/datetime/calendar

*DateFormatSymbols* class – ICU API Documentation, https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/classicu_1_1DateFormatSymbols.html

*Formatting Dates and Times* – ICU User Guide, http://userguide.icu-project.org/formatparse/datetime

See Also
~~~~~~~~

Other datetime: `stri_datetime_add() <stri_datetime_add.html>`__, `stri_datetime_create() <stri_datetime_create.html>`__, `stri_datetime_fields() <stri_datetime_fields.html>`__, `stri_datetime_format() <stri_datetime_format.html>`__, `stri_datetime_fstr() <stri_datetime_fstr.html>`__, `stri_datetime_now() <stri_datetime_now.html>`__, `stri_timezone_get() <stri_timezone_set.html>`__, `stri_timezone_info() <stri_timezone_info.html>`__, `stri_timezone_list() <stri_timezone_list.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_datetime_symbols() # uses the Gregorian calendar in most locales
   stri_datetime_symbols('@calendar=hebrew')
   stri_datetime_symbols('he_IL@calendar=hebrew')
   stri_datetime_symbols('@calendar=islamic')
   stri_datetime_symbols('@calendar=persian')
   stri_datetime_symbols('@calendar=indian')
   stri_datetime_symbols('@calendar=coptic')
   stri_datetime_symbols('@calendar=japanese')

   stri_datetime_symbols('ja_JP_TRADITIONAL') # uses the Japanese calendar by default
   stri_datetime_symbols('th_TH_TRADITIONAL') # uses the Buddhist calendar

   stri_datetime_symbols('pl_PL', context='format')
   stri_datetime_symbols('pl_PL', context='standalone')

   stri_datetime_symbols(width='wide')
   stri_datetime_symbols(width='abbreviated')
   stri_datetime_symbols(width='narrow')
