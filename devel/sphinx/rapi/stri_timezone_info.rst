stri_timezone_info: Query a Given Time Zone
===========================================

Description
~~~~~~~~~~~

Provides some basic information on a given time zone identifier.

Usage
~~~~~

.. code-block:: r

   stri_timezone_info(tz = NULL, locale = NULL, display_type = "long")

Arguments
~~~~~~~~~

+------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``tz``           | ``NULL`` or ``''`` for default time zone, or a single string with time zone ID otherwise                                                                      |
+------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale``       | ``NULL`` or ``''`` for default locale, or a single string with locale identifier                                                                              |
+------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``display_type`` | single string; one of ``'short'``, ``'long'``, ``'generic_short'``, ``'generic_long'``, ``'gmt_short'``, ``'gmt_long'``, ``'common'``, ``'generic_location'`` |
+------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Used to fetch basic information on any supported time zone.

For more information on time zone representation in ICU, see `stri_timezone_list <stri_timezone_list.html>`__.

Value
~~~~~

Returns a list with the following named components:

#. ``ID`` (time zone identifier),

#. ``Name`` (localized human-readable time zone name),

#. ``Name.Daylight`` (localized human-readable time zone name when DST is used, if available),

#. ``Name.Windows`` (Windows time zone ID, if available),

#. ``RawOffset`` (raw GMT offset, in hours, before taking daylight savings into account), and

#. ``UsesDaylightTime`` (states whether a time zone uses daylight savings time in the current Gregorian calendar year).

See Also
~~~~~~~~

Other datetime: `stri_datetime_add() <stri_datetime_add.html>`__, `stri_datetime_create() <stri_datetime_create.html>`__, `stri_datetime_fields() <stri_datetime_fields.html>`__, `stri_datetime_format() <stri_datetime_format.html>`__, `stri_datetime_fstr() <stri_datetime_fstr.html>`__, `stri_datetime_now() <stri_datetime_now.html>`__, `stri_datetime_symbols() <stri_datetime_symbols.html>`__, `stri_timezone_get() <stri_timezone_set.html>`__, `stri_timezone_list() <stri_timezone_list.html>`__

Other timezone: `stri_timezone_get() <stri_timezone_set.html>`__, `stri_timezone_list() <stri_timezone_list.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_timezone_info()
   stri_timezone_info(locale='sk_SK')
   sapply(c('short', 'long', 'generic_short', 'generic_long',
            'gmt_short', 'gmt_long', 'common', 'generic_location'),
     function(e) stri_timezone_info('Europe/London', display_type=e))

