stri_opts_regex: Generate a List with Regex Matcher Settings
============================================================

Description
~~~~~~~~~~~

A convenience function to tune the ICU regular expressions matcher's behavior, e.g., in `stri_count_regex`_ and other `stringi-search-regex`_ functions.

Usage
~~~~~

.. code-block:: r

   stri_opts_regex(
     case_insensitive,
     comments,
     dotall,
     dot_all = dotall,
     literal,
     multiline,
     multi_line = multiline,
     unix_lines,
     uword,
     error_on_unknown_escapes,
     time_limit = 0L,
     stack_limit = 0L,
     ...
   )

Arguments
~~~~~~~~~

+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``case_insensitive``         | logical; enables case insensitive matching [regex flag ``(?i)``]                                                                                                                                                                                                         |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``comments``                 | logical; allows white space and comments within patterns [regex flag ``(?x)``]                                                                                                                                                                                           |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``dotall``                   | logical; if set, '``.``' matches line terminators, otherwise matching of '``.``' stops at a line end [regex flag ``(?s)``]                                                                                                                                               |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``dot_all``                  | alias of ``dotall``                                                                                                                                                                                                                                                      |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``literal``                  | logical; if set, treat the entire pattern as a literal string: metacharacters or escape sequences in the input sequence will be given no special meaning; note that in most cases you would rather use the `stringi-search-fixed`_ facilities in this case               |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``multiline``                | logical; controls the behavior of '``$``' and '``^``'. If set, recognize line terminators within a string, otherwise, match only at start and end of input string [regex flag ``(?m)``]                                                                                  |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``multi_line``               | alias of ``multiline``                                                                                                                                                                                                                                                   |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``unix_lines``               | logical; Unix-only line endings; when enabled, only ``U+000a`` is recognized as a line ending by '``.``', '``$``', and '``^``'.                                                                                                                                          |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``uword``                    | logical; Unicode word boundaries; if set, uses the Unicode TR 29 definition of word boundaries; warning: Unicode word boundaries are quite different from traditional regex word boundaries. [regex flag ``(?w)``] See https://unicode.org/reports/tr29/#Word_Boundaries |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``error_on_unknown_escapes`` | logical; whether to generate an error on unrecognized backslash escapes; if set, fail with an error on patterns that contain backslash-escaped ASCII letters without a known special meaning; otherwise, these escaped letters represent themselves                      |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``time_limit``               | integer; processing time limit, in ~milliseconds (but not precisely so, depends on the CPU speed), for match operations; setting a limit is desirable if poorly written regexes are expected on input; 0 for no limit                                                    |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``stack_limit``              | integer; maximal size, in bytes, of the heap storage available for the match backtracking stack; setting a limit is desirable if poorly written regexes are expected on input; 0 for no limit                                                                            |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``...``                      | [DEPRECATED] any other arguments passed to this function generate a warning; this argument will be removed in the future                                                                                                                                                 |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Note that some regex settings may be changed using ICU regex flags inside regexes. For example, ``'(?i)pattern'`` performs a case-insensitive match of a given pattern, see the ICU User Guide entry on Regular Expressions in the References section or `stringi-search-regex`_.

Value
~~~~~

Returns a named list object; missing settings are left with default values.

References
~~~~~~~~~~

*``enum URegexpFlag``: Constants for Regular Expression Match Modes* – ICU4C API Documentation, https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/uregex_8h.html

*Regular Expressions* – ICU User Guide, http://userguide.icu-project.org/strings/regexp

See Also
~~~~~~~~

Other search_regex: `about_search_regex`_, `about_search`_

Examples
~~~~~~~~

.. code-block:: r

   stri_detect_regex('ala', 'ALA') # case-sensitive by default
   stri_detect_regex('ala', 'ALA', opts_regex=stri_opts_regex(case_insensitive=TRUE))
   stri_detect_regex('ala', 'ALA', case_insensitive=TRUE) # equivalent
   stri_detect_regex('ala', '(?i)ALA') # equivalent

.. _stri_count_regex: stri_count.html
.. _stringi-search-regex: about_search_regex.html
.. _stringi-search-fixed: about_search_fixed.html
.. _about_search_regex: about_search_regex.html
.. _about_search: about_search.html
