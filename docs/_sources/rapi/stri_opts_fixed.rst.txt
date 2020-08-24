stri_opts_fixed: Generate a List with Fixed Pattern Search Engine's Settings
============================================================================

Description
~~~~~~~~~~~

A convenience function used to tune up the behavior of ``stri_*_fixed`` functions, see `stringi-search-fixed <stringi-search-fixed.html>`__.

Usage
~~~~~

.. code-block:: r

   stri_opts_fixed(case_insensitive = FALSE, overlap = FALSE, ...)

Arguments
~~~~~~~~~

+----------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``case_insensitive`` | logical; enable simple case insensitive matching                                                                         |
+----------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``overlap``          | logical; enable overlapping matches' detection                                                                           |
+----------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``...``              | [DEPRECATED] any other arguments passed to this function generate a warning; this argument will be removed in the future |
+----------------------+--------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Case-insensitive matching uses a simple, single-code point case mapping (via ICU's ``u_toupper()`` function). Full case mappings should be used whenever possible because they produce better results by working on whole strings. They also take into account the string context and the language, see `stringi-search-coll <stringi-search-coll.html>`__.

Searching for overlapping pattern matches is available in `stri_extract_all_fixed <stri_extract.html>`__, `stri_locate_all_fixed <stri_locate.html>`__, and `stri_count_fixed <stri_count.html>`__ functions.

Value
~~~~~

Returns a named list object.

References
~~~~~~~~~~

*C/POSIX Migration* – ICU User Guide, http://userguide.icu-project.org/posix#case_mappings

See Also
~~~~~~~~

Other search_fixed: `stringi-search-fixed <stringi-search-fixed.html>`__, `stringi-search <stringi-search.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_detect_fixed("ala", "ALA") # case-sensitive by default
   stri_detect_fixed("ala", "ALA", opts_fixed=stri_opts_fixed(case_insensitive=TRUE))
   stri_detect_fixed("ala", "ALA", case_insensitive=TRUE) # equivalent
