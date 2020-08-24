stri_timezone_set: Set or Get Default Time Zone in stringi
==========================================================

Description
~~~~~~~~~~~

``stri_timezone_set`` changes the current default time zone for all functions in the stringi package, i.e., establishes the meaning of the “\ ``NULL`` time zone” argument to date/time processing functions.

``stri_timezone_get`` gets the current default time zone.

For more information on time zone representation in ICU and stringi, refer to `stri_timezone_list <stri_timezone_list.html>`__.

Usage
~~~~~

.. code-block:: r

   stri_timezone_get()

   stri_timezone_set(tz)

Arguments
~~~~~~~~~

+--------+-------------------------------------+
| ``tz`` | single string; time zone identifier |
+--------+-------------------------------------+

Details
~~~~~~~

Unless the default time zone has already been set using ``stri_timezone_set``, the default time zone is determined by querying the OS with methods in ICU's internal platform utilities.

Value
~~~~~

``stri_timezone_set`` returns a string with previously used timezone, invisibly.

``stri_timezone_get`` returns a single string with the current default time zone.

References
~~~~~~~~~~

*TimeZone* class – ICU API Documentation, http://www.icu-project.org/apiref/icu4c/classicu_1_1TimeZone.html

See Also
~~~~~~~~

Other datetime: `stri_datetime_add() <stri_datetime_add.html>`__, `stri_datetime_create() <stri_datetime_create.html>`__, `stri_datetime_fields() <stri_datetime_fields.html>`__, `stri_datetime_format() <stri_datetime_format.html>`__, `stri_datetime_fstr() <stri_datetime_fstr.html>`__, `stri_datetime_now() <stri_datetime_now.html>`__, `stri_datetime_symbols() <stri_datetime_symbols.html>`__, `stri_timezone_info() <stri_timezone_info.html>`__, `stri_timezone_list() <stri_timezone_list.html>`__

Other timezone: `stri_timezone_info() <stri_timezone_info.html>`__, `stri_timezone_list() <stri_timezone_list.html>`__

Examples
~~~~~~~~

.. code-block:: r

   ## Not run: 
   oldtz <- stri_timezone_set('Europe/Warsaw')
   # ... many time zone-dependent operations
   stri_timezone_set(oldtz) # restore previous default time zone

   ## End(Not run)

