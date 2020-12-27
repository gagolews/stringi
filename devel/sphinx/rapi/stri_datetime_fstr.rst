stri_datetime_fstr: Convert strptime-Style Format Strings
=========================================================

Description
~~~~~~~~~~~

A function to convert ``strptime``/``strftime``-style format strings to ICU format strings that may be used in `stri_datetime_parse <stri_datetime_format.html>`__ and `stri_datetime_format <stri_datetime_format.html>`__ functions.

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

For more details on conversion specifiers please refer to the manual page of ``strptime``. Most of the formatters of the form ``%x``, where ``x`` is a letter, are supported. Moreover, each ``%%`` is replaced with ``%``.

Warnings are given in case of ``%x``, ``%X``, ``%u``, ``%w``, ``%g``, ``%G``, ``%c``, ``%U`` and ``%W`` as in such circumstances either ICU does not support the functionality requested using the format-strings API or there are some inconsistencies between base R and ICU.

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other datetime: `stri_datetime_add() <stri_datetime_add.html>`__, `stri_datetime_create() <stri_datetime_create.html>`__, `stri_datetime_fields() <stri_datetime_fields.html>`__, `stri_datetime_format() <stri_datetime_format.html>`__, `stri_datetime_now() <stri_datetime_now.html>`__, `stri_datetime_symbols() <stri_datetime_symbols.html>`__, `stri_timezone_get() <stri_timezone_set.html>`__, `stri_timezone_info() <stri_timezone_info.html>`__, `stri_timezone_list() <stri_timezone_list.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_datetime_fstr('%Y-%m-%d %H:%M:%S')
