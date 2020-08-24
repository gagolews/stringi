stri_datetime_add: Date and Time Arithmetic
===========================================

Description
~~~~~~~~~~~

Modifies a date-time object by adding a specific amount of time units.

Usage
~~~~~

.. code-block:: r

   stri_datetime_add(
     time,
     value = 1L,
     units = "seconds",
     tz = NULL,
     locale = NULL
   )

   stri_datetime_add(time, units = "seconds", tz = NULL, locale = NULL) <- value

Arguments
~~~~~~~~~

+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``time``   | an object of class ``POSIXct`` or an object coercible to                                                                                                              |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``value``  | integer vector; signed number of units to add to ``time``                                                                                                             |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``units``  | single string; one of ``'years'``, ``'months'``, ``'weeks'``, ``'days'``, ``'hours'``, ``'minutes'``, ``'seconds'``, or ``'milliseconds'``                            |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``tz``     | ``NULL`` or ``''`` for the default time zone or a single string with a timezone identifier,                                                                           |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale`` | ``NULL`` or ``''`` for default locale, or a single string with locale identifier; a non-Gregorian calendar may be specified by setting the ``@calendar=name`` keyword |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``time`` and ``value``.

Note that, e.g., January, 31 + 1 month = February, 28 or 29.

Value
~~~~~

Both functions return an object of class ``POSIXct``.

The replacement version of ``stri_datetime_add`` modifies the state of the ``time`` object.

References
~~~~~~~~~~

*Calendar Classes* - ICU User Guide, http://userguide.icu-project.org/datetime/calendar

See Also
~~~~~~~~

Other datetime: `stri_datetime_create() <stri_datetime_create.html>`__, `stri_datetime_fields() <stri_datetime_fields.html>`__, `stri_datetime_format() <stri_datetime_format.html>`__, `stri_datetime_fstr() <stri_datetime_fstr.html>`__, `stri_datetime_now() <stri_datetime_now.html>`__, `stri_datetime_symbols() <stri_datetime_symbols.html>`__, `stri_timezone_get() <stri_timezone_set.html>`__, `stri_timezone_info() <stri_timezone_info.html>`__, `stri_timezone_list() <stri_timezone_list.html>`__

Examples
~~~~~~~~

.. code-block:: r

   x <- stri_datetime_now()
   stri_datetime_add(x, units='months') <- 2
   print(x)
   stri_datetime_add(x, -2, units='months')
   stri_datetime_add(stri_datetime_create(2014, 4, 20), 1, units='years')
   stri_datetime_add(stri_datetime_create(2014, 4, 20), 1, units='years', locale='@calendar=hebrew')

   stri_datetime_add(stri_datetime_create(2016, 1, 31), 1, units='months')

