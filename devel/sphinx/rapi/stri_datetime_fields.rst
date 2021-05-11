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
| ``time``   | an object of class `POSIXct`_ or an object coercible to                                                                                                                         |
+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``tz``     | ``NULL`` or ``''`` for the default time zone or a single string with time zone identifier, see `stri_timezone_list`_                                                            |
+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale`` | ``NULL`` or ``''`` for the current default locale, or a single string with a locale identifier; a non-Gregorian calendar may be specified by setting ``@calendar=name`` keyword |
+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``time``.

Value
~~~~~

Returns a data frame with the following columns:

#. Year (0 is 1BC, -1 is 2BC, etc.)

#. Month (1-based, i.e., 1 stands for the first month, e.g., January; note that the number of months depends on the selected calendar, see `stri_datetime_symbols`_)

#. Day

#. Hour (24-h clock)

#. Minute

#. Second

#. Millisecond

#. WeekOfYear (this is locale-dependent)

#. WeekOfMonth (this is locale-dependent)

#. DayOfYear

#. DayOfWeek (1-based, 1 denotes Sunday; see `stri_datetime_symbols`_)

#. Hour12 (12-h clock)

#. AmPm (see `stri_datetime_symbols`_)

#. Era (see `stri_datetime_symbols`_)

See Also
~~~~~~~~

Other datetime: `stri_datetime_add()`_, `stri_datetime_create()`_, `stri_datetime_format()`_, `stri_datetime_fstr()`_, `stri_datetime_now()`_, `stri_datetime_symbols()`_, `stri_timezone_get()`_, `stri_timezone_info()`_, `stri_timezone_list()`_

Examples
~~~~~~~~

.. code-block:: r

   stri_datetime_fields(stri_datetime_now())
   stri_datetime_fields(stri_datetime_now(), locale='@calendar=hebrew')
   stri_datetime_symbols(locale='@calendar=hebrew')$Month[
      stri_datetime_fields(stri_datetime_now(), locale='@calendar=hebrew')$Month
   ]

.. _POSIXct: https://stat.ethz.ch/R-manual/R-patched/library/base/html/DateTimeClasses.html
.. _stri_timezone_list: stri_timezone_list.html
.. _stri_datetime_symbols: stri_datetime_symbols.html
.. _stri_datetime_add(): stri_datetime_add.html
.. _stri_datetime_create(): stri_datetime_create.html
.. _stri_datetime_format(): stri_datetime_format.html
.. _stri_datetime_fstr(): stri_datetime_fstr.html
.. _stri_datetime_now(): stri_datetime_now.html
.. _stri_datetime_symbols(): stri_datetime_symbols.html
.. _stri_timezone_get(): stri_timezone_set.html
.. _stri_timezone_info(): stri_timezone_info.html
.. _stri_timezone_list(): stri_timezone_list.html
