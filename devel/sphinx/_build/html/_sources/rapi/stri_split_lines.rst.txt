stri_split_lines: Split a String Into Text Lines
================================================

Description
~~~~~~~~~~~

These functions split each character string in a given vector into text lines.

Usage
~~~~~

.. code-block:: r

   stri_split_lines(str, omit_empty = FALSE)

   stri_split_lines1(str)

Arguments
~~~~~~~~~

+----------------+----------------------------------------------------------------------------------------------------------------+
| ``str``        | character vector (``stri_split_lines``) or a single string (``stri_split_lines1``)                             |
+----------------+----------------------------------------------------------------------------------------------------------------+
| ``omit_empty`` | logical vector; determines whether empty strings should be removed from the result [``stri_split_lines`` only] |
+----------------+----------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str`` and ``omit_empty``.

``omit_empty`` is applied when splitting. If set to ``TRUE``, then empty strings will never appear in the resulting vector.

Newlines are represented with the Carriage Return (CR, 0x0D), Line Feed (LF, 0x0A), CRLF, or Next Line (NEL, 0x85) characters, depending on the platform. Moreover, the Unicode Standard defines two unambiguous separator characters, the Paragraph Separator (PS, 0x2029) and the Line Separator (LS, 0x2028). Sometimes also the Vertical Tab (VT, 0x0B) and the Form Feed (FF, 0x0C) are used for this purpose.

These stringi functions follow UTR#18 rules, where a newline sequence corresponds to the following regular expression: ``(?:\u{D A}|(?!\u{D A})[\u{A}-\u{D}\u{85}\u{2028}\u{2029}]``. Each match serves as a text line separator.

Value
~~~~~

``stri_split_lines`` returns a list of character vectors. If any input string is ``NA``, then the corresponding list element is a single ``NA`` string.

``stri_split_lines1(str)`` is equivalent to ``stri_split_lines(str[1])[[1]]`` (with default parameters), therefore it returns a character vector. Moreover, if the input string ends with a newline sequence, the last empty string is omitted from the file's contents into text lines.

References
~~~~~~~~~~

*Unicode Newline Guidelines* – Unicode Technical Report #13, https://www.unicode.org/standard/reports/tr13/tr13-5.html

*Unicode Regular Expressions* – Unicode Technical Standard #18, https://www.unicode.org/reports/tr18/

See Also
~~~~~~~~

Other search_split: `about_search <about_search.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_split() <stri_split.html>`__

Other text_boundaries: `about_search_boundaries <about_search_boundaries.html>`__, `about_search <about_search.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_brkiter() <stri_opts_brkiter.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_wrap() <stri_wrap.html>`__
