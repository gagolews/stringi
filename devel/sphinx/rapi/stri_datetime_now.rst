stri_datetime_now: Get Current Date and Time
============================================

Description
~~~~~~~~~~~

Returns the current date and time.

Usage
~~~~~

.. code-block:: r

   stri_datetime_now()

Details
~~~~~~~

The current date and time in stringi is represented as the (signed) number of seconds since 1970-01-01 00:00:00 UTC. UTC leap seconds are ignored.

Value
~~~~~

Returns an object of class ``POSIXct``.

See Also
~~~~~~~~

Other datetime: `stri_datetime_add() <stri_datetime_add.html>`__, `stri_datetime_create() <stri_datetime_create.html>`__, `stri_datetime_fields() <stri_datetime_fields.html>`__, `stri_datetime_format() <stri_datetime_format.html>`__, `stri_datetime_fstr() <stri_datetime_fstr.html>`__, `stri_datetime_symbols() <stri_datetime_symbols.html>`__, `stri_timezone_get() <stri_timezone_set.html>`__, `stri_timezone_info() <stri_timezone_info.html>`__, `stri_timezone_list() <stri_timezone_list.html>`__
