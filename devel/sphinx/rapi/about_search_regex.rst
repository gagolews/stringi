about_search_regex: Regular Expressions in stringi
==================================================

Description
~~~~~~~~~~~

A regular expression is a pattern describing, possibly in a very abstract way, a text fragment. With so many regex functions in stringi, regular expressions may be a very powerful tool to perform string searching, substring extraction, string splitting, etc., tasks.

Details
~~~~~~~

All ``stri_*_regex`` functions in stringi use the ICU regex engine. Its settings may be tuned up (for example to perform case-insensitive search) via the `stri_opts_regex <stri_opts_regex.html>`__ function.

Regular expression patterns in ICU are quite similar in form and behavior to Perl's regexes. Their implementation is loosely inspired by JDK 1.4 ``java.util.regex``. ICU Regular Expressions conform to the Unicode Technical Standard #18 (see References section) and its features are summarized in the ICU User Guide (see below). A good general introduction to regexes is (Friedl, 2002). Some general topics are also covered in the R manual, see `regex <../../base/html/regex.html>`__.

ICU Regex Operators at a Glance
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here is a list of operators provided by the ICU User Guide on regexes.

``|``
   Alternation. A|B matches either A or B.

``*``
   Match 0 or more times. Match as many times as possible.

``+``
   Match 1 or more times. Match as many times as possible.

``?``
   Match zero or one times. Prefer one.

``{n}``
   Match exactly n times.

``{n,}``
   Match at least n times. Match as many times as possible.

``{n,m}``
   Match between n and m times. Match as many times as possible, but not more than m.

``*?``
   Match 0 or more times. Match as few times as possible.

``+?``
   Match 1 or more times. Match as few times as possible.

``??``
   Match zero or one times. Prefer zero.

``{n}?``
   Match exactly n times.

``{n,}?``
   Match at least n times, but no more than required for an overall pattern match.

``{n,m}?``
   Match between n and m times. Match as few times as possible, but not less than n.

``*+``
   Match 0 or more times. Match as many times as possible when first encountered, do not retry with fewer even if overall match fails (Possessive Match).

``++``
   Match 1 or more times. Possessive match.

``?+``
   Match zero or one times. Possessive match.

``{n}+``
   Match exactly n times.

``{n,}+``
   Match at least n times. Possessive Match.

``{n,m}+``
   Match between n and m times. Possessive Match.

``(...)``
   Capturing parentheses. Range of input that matched the parenthesized sub-expression is available after the match, see `stri_match <stri_match.html>`__.

``(?:...)``
   Non-capturing parentheses. Groups the included pattern, but does not provide capturing of matching text. Somewhat more efficient than capturing parentheses.

``(?>...)``
   Atomic-match parentheses. First match of the parenthesized sub-expression is the only one tried; if it does not lead to an overall pattern match, back up the search for a match to a position before the ``(?>``.

``(?#...)``
   Free-format comment ``(?# comment )``.

``(?=...)``
   Look-ahead assertion. True if the parenthesized pattern matches at the current input position, but does not advance the input position.

``(?!...)``
   Negative look-ahead assertion. True if the parenthesized pattern does not match at the current input position. Does not advance the input position.

``(?<=...)``
   Look-behind assertion. True if the parenthesized pattern matches text preceding the current input position, with the last character of the match being the input character just before the current position. Does not alter the input position. The length of possible strings matched by the look-behind pattern must not be unbounded (no ``*`` or ``+`` operators.)

``(?<!...)``
   Negative Look-behind assertion. True if the parenthesized pattern does not match text preceding the current input position, with the last character of the match being the input character just before the current position. Does not alter the input position. The length of possible strings matched by the look-behind pattern must not be unbounded (no ``*`` or ``+`` operators.)

``(?<name>...)``
   Named capture group. The ``<angle brackets>`` are literal - they appear in the pattern.

``(?ismwx-ismwx:...)``
   Flag settings. Evaluate the parenthesized expression with the specified flags enabled or ``-``\ disabled, see also `stri_opts_regex <stri_opts_regex.html>`__.

``(?ismwx-ismwx)``
   Flag settings. Change the flag settings. Changes apply to the portion of the pattern following the setting. For example, ``(?i)`` changes to a case insensitive match, see also `stri_opts_regex <stri_opts_regex.html>`__.

ICU Regex Meta-characters at a Glance
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here is a list of meta-characters provided by the ICU User Guide on regexes.

``\a``
   Match a BELL, ``\u0007``.

``\A``
   Match at the beginning of the input. Differs from ``^``. in that ``\A`` will not match after a new line within the input.

``\b``
   Match if the current position is a word boundary. Boundaries occur at the transitions between word (``\w``) and non-word (``\W``) characters, with combining marks ignored. For better word boundaries, see ICU Boundary Analysis, e.g., `stri_extract_all_words <stri_extract_boundaries.html>`__.

``\B``
   Match if the current position is not a word boundary.

``\cX``
   Match a control-``X`` character.

``\d``
   Match any character with the Unicode General Category of ``Nd`` (Number, Decimal Digit.).

``\D``
   Match any character that is not a decimal digit.

``\e``
   Match an ESCAPE, ``\u001B``.

``\E``
   Terminates a ``\Q`` ... ``\E`` quoted sequence.

``\f``
   Match a FORM FEED, ``\u000C``.

``\G``
   Match if the current position is at the end of the previous match.

``\h``
   Match a Horizontal White Space character. They are characters with Unicode General Category of Space_Separator plus the ASCII tab, ``\u0009``. [Since ICU 55]

``\H``
   Match a non-Horizontal White Space character. [Since ICU 55]

``\k<name>``
   Named Capture Back Reference. [Since ICU 55]

``\n``
   Match a LINE FEED, ``\u000A``.

``\N{UNICODE CHARACTER NAME}``
   Match the named character.

``\p{UNICODE PROPERTY NAME}``
   Match any character with the specified Unicode Property.

``\P{UNICODE PROPERTY NAME}``
   Match any character not having the specified Unicode Property.

``\Q``
   Quotes all following characters until ``\E``.

``\r``
   Match a CARRIAGE RETURN, ``\u000D``.

``\s``
   Match a white space character. White space is defined as ``[\t\n\f\r\p{Z}]``.

``\S``
   Match a non-white space character.

``\t``
   Match a HORIZONTAL TABULATION, ``\u0009``.

``\uhhhh``
   Match the character with the hex value ``hhhh``.

``\Uhhhhhhhh``
   Match the character with the hex value ``hhhhhhhh``. Exactly eight hex digits must be provided, even though the largest Unicode code point is ``\U0010ffff``.

``\w``
   Match a word character. Word characters are ``[\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\u200c\u200d]``.

``\W``
   Match a non-word character.

``\x{hhhh}``
   Match the character with hex value hhhh. From one to six hex digits may be supplied.

``\xhh``
   Match the character with two digit hex value hh

``\X``
   Match a Grapheme Cluster.

``\Z``
   Match if the current position is at the end of input, but before the final line terminator, if one exists.

``\z``
   Match if the current position is at the end of input.

``\n``
   Back Reference. Match whatever the nth capturing group matched. n must be a number > 1 and < total number of capture groups in the pattern.

``\0ooo``
   Match an Octal character. ``'ooo'`` is from one to three octal digits. 0377 is the largest allowed Octal character. The leading zero is required; it distinguishes Octal constants from back references.

``[pattern]``
   Match any one character from the set.

``.``
   Match any character except for - by default - newline, compare `stri_opts_regex <stri_opts_regex.html>`__.

``^``
   Match at the beginning of a line.

``$``
   Match at the end of a line.

``\``
   [outside of sets] Quotes the following character. Characters that must be quoted to be treated as literals are ``* ? + [ ( ) { } ^ $ | \ .``.

``\``
   [inside sets] Quotes the following character. Characters that must be quoted to be treated as literals are ``[ ] \``; Characters that may need to be quoted, depending on the context are ``- &``.

For information on how to define character classes in regexes, refer to `about_search_charclass <about_search_charclass.html>`__.

Regex Functions in stringi
~~~~~~~~~~~~~~~~~~~~~~~~~~

Note that if a given regex ``pattern`` is empty, then all the functions in stringi give ``NA`` in result and generate a warning. On a syntax error, a quite informative failure message is shown.

If you wish to search for a fixed pattern, refer to `about_search_coll <about_search_coll.html>`__ or `about_search_fixed <about_search_fixed.html>`__. They allow to perform a locale-aware text lookup, or a very fast exact-byte search, respectively.

References
~~~~~~~~~~

*Regular expressions* – ICU User Guide, http://userguide.icu-project.org/strings/regexp

J.E.F. Friedl, *Mastering Regular Expressions*, O'Reilly, 2002

*Unicode Regular Expressions* – Unicode Technical Standard #18, https://www.unicode.org/reports/tr18/

*Unicode Regular Expressions* – Regex tutorial, https://www.regular-expressions.info/unicode.html

See Also
~~~~~~~~

Other search_regex: `about_search <about_search.html>`__, `stri_opts_regex() <stri_opts_regex.html>`__

Other stringi_general_topics: `about_arguments <about_arguments.html>`__, `about_encoding <about_encoding.html>`__, `about_locale <about_locale.html>`__, `about_search_boundaries <about_search_boundaries.html>`__, `about_search_charclass <about_search_charclass.html>`__, `about_search_coll <about_search_coll.html>`__, `about_search_fixed <about_search_fixed.html>`__, `about_search <about_search.html>`__, `about_stringi <about_stringi.html>`__
