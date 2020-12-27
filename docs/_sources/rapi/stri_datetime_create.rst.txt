stri_datetime_create: Create a Date-Time Object
===============================================

Description
~~~~~~~~~~~

Constructs date-time objects from numeric representations.

Usage
~~~~~

.. code-block:: r

   stri_datetime_create(
     year,
     month,
     day,
     hour = 12L,
     minute = 0L,
     second = 0,
     lenient = FALSE,
     tz = NULL,
     locale = NULL
   )

Arguments
~~~~~~~~~

+-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``year``    | integer vector; 0 is 1BC, -1 is 2BC, etc.                                                                                                                         |
+-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``month``   | integer vector; months are 1-based                                                                                                                                |
+-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``day``     | integer vector                                                                                                                                                    |
+-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``hour``    | integer vector                                                                                                                                                    |
+-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``minute``  | integer vector                                                                                                                                                    |
+-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``second``  | numeric vector; fractional seconds are allowed                                                                                                                    |
+-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``lenient`` | single logical value; should the operation be lenient?                                                                                                            |
+-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``tz``      | ``NULL`` or ``''`` for the default time zone or a single string with time zone identifier, see `stri_timezone_list <stri_timezone_list.html>`__                   |
+-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale``  | ``NULL`` or ``''`` for default locale, or a single string with locale identifier; a non-Gregorian calendar may be specified by setting ``@calendar=name`` keyword |
+-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``year``, ``month``, ``day``, ``hour``, ``hour``, ``minute``, and ``second``.

Value
~~~~~

Returns an object of class ``POSIXct``.

See Also
~~~~~~~~

Other datetime: `stri_datetime_add() <stri_datetime_add.html>`__, `stri_datetime_fields() <stri_datetime_fields.html>`__, `stri_datetime_format() <stri_datetime_format.html>`__, `stri_datetime_fstr() <stri_datetime_fstr.html>`__, `stri_datetime_now() <stri_datetime_now.html>`__, `stri_datetime_symbols() <stri_datetime_symbols.html>`__, `stri_timezone_get() <stri_timezone_set.html>`__, `stri_timezone_info() <stri_timezone_info.html>`__, `stri_timezone_list() <stri_timezone_list.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_datetime_create(2015, 12, 31, 23, 59, 59.999)
   stri_datetime_create(5775, 8, 1, locale='@calendar=hebrew') # 1 Nisan 5775 -> 2015-03-21
   stri_datetime_create(2015, 02, 29)
   stri_datetime_create(2015, 02, 29, lenient=TRUE)
