stri_opts_regex: Generate a List with Regex Matcher Settings
============================================================

Description
~~~~~~~~~~~

A convenience function to tune the ICU regular expressions matcher's behavior, e.g., in `stri_count_regex <stri_count.html>`__ and other `stringi-search-regex <stringi-search-regex.html>`__ functions.

Usage
~~~~~

.. code-block:: r

   stri_opts_regex(
     case_insensitive,
     comments,
     dotall,
     literal,
     multiline,
     unix_lines,
     uword,
     error_on_unknown_escapes,
     ...
   )

Arguments
~~~~~~~~~

+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``case_insensitive``         | logical; enables case insensitive matching [regex flag ``(?i)``]                                                                                                                                                                                                                        |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``comments``                 | logical; allows white space and comments within patterns [regex flag ``(?x)``]                                                                                                                                                                                                          |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``dotall``                   | logical; if set, '``.``' matches line terminators, otherwise matching of '``.``' stops at a line end [regex flag ``(?s)``]                                                                                                                                                              |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``literal``                  | logical; if set, treat the entire pattern as a literal string: metacharacters or escape sequences in the input sequence will be given no special meaning; note that in most cases you would rather use the `stringi-search-fixed <stringi-search-fixed.html>`__ facilities in this case |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``multiline``                | logical; controls the behavior of '``$``' and '``^``'. If set, recognize line terminators within a string, otherwise, match only at start and end of input string [regex flag ``(?m)``]                                                                                                 |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``unix_lines``               | logical; Unix-only line endings; when enabled, only ``U+000a`` is recognized as a line ending by '``.``', '``$``', and '``^``'.                                                                                                                                                         |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``uword``                    | logical; Unicode word boundaries; if set, uses the Unicode TR 29 definition of word boundaries; warning: Unicode word boundaries are quite different from traditional regex word boundaries. [regex flag ``(?w)``] See http://unicode.org/reports/tr29/#Word_Boundaries                 |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``error_on_unknown_escapes`` | logical; whether to generate an error on unrecognized backslash escapes; if set, fail with an error on patterns that contain backslash-escaped ASCII letters without a known special meaning; otherwise, these escaped letters represent themselves                                     |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``                      | [DEPRECATED] any other arguments passed to this function generate a warning; this argument will be removed in the future                                                                                                                                                                |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Note that some regex settings may be changed using ICU regex flags inside regexes. For example, ``"(?i)pattern"`` performs a case-insensitive match of a given pattern, see the ICU User Guide entry on Regular Expressions in the References section or `stringi-search-regex <stringi-search-regex.html>`__.

Value
~~~~~

Returns a named list object; missing settings are left with default values.

References
~~~~~~~~~~

*``enum URegexpFlag``: Constants for Regular Expression Match Modes* – ICU4C API Documentation, http://www.icu-project.org/apiref/icu4c/uregex_8h.html

*Regular Expressions* – ICU User Guide, http://userguide.icu-project.org/strings/regexp

See Also
~~~~~~~~

Other search_regex: `stringi-search-regex <stringi-search-regex.html>`__, `stringi-search <stringi-search.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_detect_regex("ala", "ALA") # case-sensitive by default
   stri_detect_regex("ala", "ALA", opts_regex=stri_opts_regex(case_insensitive=TRUE))
   stri_detect_regex("ala", "ALA", case_insensitive=TRUE) # equivalent
   stri_detect_regex("ala", "(?i)ALA") # equivalent
