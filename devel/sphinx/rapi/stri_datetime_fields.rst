stri_datetime_fields: Get Values for Date and Time Fields
=========================================================

Description
~~~~~~~~~~~

Computes and returns values for all date and time fields.

Usage
~~~~~

.. code-block:: r

   stri_datetime_fields(time, tz = attr(time, "tzone"), locale = NULL)

Arguments
~~~~~~~~~

+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``time``   | an object of class ``POSIXct`` or an object coercible to                                                                                                                        |
+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``tz``     | ``NULL`` or ``""`` for the default time zone or a single string with time zone identifier, see `stri_timezone_list <stri_timezone_list.html>`__                                 |
+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale`` | ``NULL`` or ``""`` for the current default locale, or a single string with a locale identifier; a non-Gregorian calendar may be specified by setting ``@calendar=name`` keyword |
+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``time``.

Value
~~~~~

Returns a data frame with the following columns:

#. Year (0 is 1BC, -1 is 2BC, etc.)

#. Month (1-based, i.e., 1 stands for the first month, e.g., January; note that the number of months depends on the selected calendar, see `stri_datetime_symbols <stri_datetime_symbols.html>`__)

#. Day

#. Hour (24-h clock)

#. Minute

#. Second

#. Millisecond

#. WeekOfYear (this is locale-dependent)

#. WeekOfMonth (this is locale-dependent)

#. DayOfYear

#. DayOfWeek (1-based, 1 denotes Sunday; see `stri_datetime_symbols <stri_datetime_symbols.html>`__)

#. Hour12 (12-h clock)

#. AmPm (see `stri_datetime_symbols <stri_datetime_symbols.html>`__)

#. Era (see `stri_datetime_symbols <stri_datetime_symbols.html>`__)

See Also
~~~~~~~~

Other datetime: `stri_datetime_add() <stri_datetime_add.html>`__, `stri_datetime_create() <stri_datetime_create.html>`__, `stri_datetime_format() <stri_datetime_format.html>`__, `stri_datetime_fstr() <stri_datetime_fstr.html>`__, `stri_datetime_now() <stri_datetime_now.html>`__, `stri_datetime_symbols() <stri_datetime_symbols.html>`__, `stri_timezone_get() <stri_timezone_set.html>`__, `stri_timezone_info() <stri_timezone_info.html>`__, `stri_timezone_list() <stri_timezone_list.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_datetime_fields(stri_datetime_now())
   stri_datetime_fields(stri_datetime_now(), locale="@calendar=hebrew")
   stri_datetime_symbols(locale="@calendar=hebrew")$Month[
      stri_datetime_fields(stri_datetime_now(), locale="@calendar=hebrew")$Month
   ]

