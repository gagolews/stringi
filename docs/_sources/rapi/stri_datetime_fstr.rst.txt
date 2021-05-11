stri_datetime_fstr: Convert strptime-Style Format Strings
=========================================================

Description
~~~~~~~~~~~

A function to convert `strptime`_/`strftime`_-style format strings to ICU format strings that may be used in `stri_datetime_parse`_ and `stri_datetime_format`_ functions.

Usage
~~~~~

.. code-block:: r

   stri_datetime_fstr(x)

Arguments
~~~~~~~~~

===== =======================================================
``x`` character vector consisting of date/time format strings
===== =======================================================

Details
~~~~~~~

For more details on conversion specifiers please refer to the manual page of `strptime`_. Most of the formatters of the form ``%x``, where ``x`` is a letter, are supported. Moreover, each ``%%`` is replaced with ``%``.

Warnings are given in case of ``%x``, ``%X``, ``%u``, ``%w``, ``%g``, ``%G``, ``%c``, ``%U`` and ``%W`` as in such circumstances either ICU does not support the functionality requested using the format-strings API or there are some inconsistencies between base R and ICU.

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other datetime: `stri_datetime_add()`_, `stri_datetime_create()`_, `stri_datetime_fields()`_, `stri_datetime_format()`_, `stri_datetime_now()`_, `stri_datetime_symbols()`_, `stri_timezone_get()`_, `stri_timezone_info()`_, `stri_timezone_list()`_

Examples
~~~~~~~~

.. code-block:: r

   stri_datetime_fstr('%Y-%m-%d %H:%M:%S')

.. _strptime: https://stat.ethz.ch/R-manual/R-patched/library/base/html/strptime.html
.. _strftime: https://stat.ethz.ch/R-manual/R-patched/library/base/html/strptime.html
.. _stri_datetime_parse: stri_datetime_format.html
.. _stri_datetime_format: stri_datetime_format.html
.. _stri_datetime_add(): stri_datetime_add.html
.. _stri_datetime_create(): stri_datetime_create.html
.. _stri_datetime_fields(): stri_datetime_fields.html
.. _stri_datetime_format(): stri_datetime_format.html
.. _stri_datetime_now(): stri_datetime_now.html
.. _stri_datetime_symbols(): stri_datetime_symbols.html
.. _stri_timezone_get(): stri_timezone_set.html
.. _stri_timezone_info(): stri_timezone_info.html
.. _stri_timezone_list(): stri_timezone_list.html
