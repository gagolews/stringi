stri_timezone_list: List Available Time Zone Identifiers
========================================================

Description
~~~~~~~~~~~

Returns a list of available time zone identifiers.

Usage
~~~~~

.. code-block:: r

   stri_timezone_list(region = NA_character_, offset = NA_integer_)

Arguments
~~~~~~~~~

+------------+------------------------------------------------------------------------------------------------------------+
| ``region`` | single string; a ISO 3166 two-letter country code or UN M.49 three-digit area code; ``NA`` for all regions |
+------------+------------------------------------------------------------------------------------------------------------+
| ``offset`` | single numeric value; a given raw offset from GMT, in hours; ``NA`` for all offsets                        |
+------------+------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

If ``offset`` and ``region`` are ``NA`` (the default), then all time zones are returned. Otherwise, only time zone identifiers with a given raw offset from GMT and/or time zones corresponding to a given region are provided. Note that the effect of daylight savings time is ignored.

A time zone represents an offset applied to the Greenwich Mean Time (GMT) to obtain local time (Universal Coordinated Time, or UTC, is similar, but not precisely identical, to GMT; in ICU the two terms are used interchangeably since ICU does not concern itself with either leap seconds or historical behavior). The offset might vary throughout the year, if daylight savings time (DST) is used, or might be the same all year long. Typically, regions closer to the equator do not use DST. If DST is in use, then specific rules define the point where the offset changes and the amount by which it changes.

If DST is observed, then three additional bits of information are needed:

#. The precise date and time during the year when DST begins. In the first half of the year it is in the northern hemisphere, and in the second half of the year it is in the southern hemisphere.

#. The precise date and time during the year when DST ends. In the first half of the year it is in the southern hemisphere, and in the second half of the year it is in the northern hemisphere.

#. The amount by which the GMT offset changes when DST is in effect. This is almost always one hour.

Value
~~~~~

Returns a character vector.

References
~~~~~~~~~~

*TimeZone* class – ICU API Documentation, http://www.icu-project.org/apiref/icu4c/classicu_1_1TimeZone.html

*ICU 4.8 Time Zone Names*. http://site.icu-project.org/design/formatting/timezone/icu-4-8-time-zone-names

*ICU TimeZone classes* – ICU User Guide, http://userguide.icu-project.org/datetime/timezone

*Date/Time Services* – ICU User Guide, http://userguide.icu-project.org/datetime

See Also
~~~~~~~~

Other datetime: `stri_datetime_add() <stri_datetime_add.html>`__, `stri_datetime_create() <stri_datetime_create.html>`__, `stri_datetime_fields() <stri_datetime_fields.html>`__, `stri_datetime_format() <stri_datetime_format.html>`__, `stri_datetime_fstr() <stri_datetime_fstr.html>`__, `stri_datetime_now() <stri_datetime_now.html>`__, `stri_datetime_symbols() <stri_datetime_symbols.html>`__, `stri_timezone_get() <stri_timezone_set.html>`__, `stri_timezone_info() <stri_timezone_info.html>`__

Other timezone: `stri_timezone_get() <stri_timezone_set.html>`__, `stri_timezone_info() <stri_timezone_info.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_timezone_list()
   stri_timezone_list(offset=1)
   stri_timezone_list(offset=5.5)
   stri_timezone_list(offset=5.75)
   stri_timezone_list(region='PL')
   stri_timezone_list(region='US', offset=-10)

   # Fetch info on all time zones
   do.call(rbind.data.frame,
      lapply(stri_timezone_list(), function(tz) stri_timezone_info(tz)))

