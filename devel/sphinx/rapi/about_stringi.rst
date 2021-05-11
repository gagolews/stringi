about_stringi: THE String Processing Package
============================================

Description
~~~~~~~~~~~

stringi is THE R package for fast, correct, consistent, and convenient string/text manipulation. It gives predictable results on every platform, in each locale, and under any native character encoding.

**Keywords**: R, text processing, character strings, internationalization, localization, ICU, ICU4C, i18n, l10n, Unicode.

**Homepage**: https://stringi.gagolewski.com/

**License**: The BSD-3-clause license for the package code, the ICU license for the accompanying ICU4C distribution, and the UCD license for the Unicode Character Database. See the COPYRIGHTS and LICENSE file for more details.

Details
~~~~~~~

Manual pages on general topics:

-  `about_encoding`_ – character encoding issues, including information on encoding management in stringi, as well as on encoding detection and conversion.

-  `about_locale`_ – locale issues, including locale management and specification in stringi, and the list of locale-sensitive operations. In particular, see `stri_opts_collator`_ for a description of the string collation algorithm, which is used for string comparing, ordering, ranking, sorting, case-folding, and searching.

-  `about_arguments`_ – information on how stringi handles the arguments passed to its function.

Facilities available
~~~~~~~~~~~~~~~~~~~~

Refer to the following:

-  `about_search`_ for string searching facilities; these include pattern searching, matching, string splitting, and so on. The following independent search engines are provided:

   -  `about_search_regex`_ – with ICU (Java-like) regular expressions,

   -  `about_search_fixed`_ – fast, locale-independent, byte-wise pattern matching,

   -  `about_search_coll`_ – locale-aware pattern matching for natural language processing tasks,

   -  `about_search_charclass`_ – seeking elements of particular character classes, like “all whites-paces” or “all digits”,

   -  `about_search_boundaries`_ – text boundary analysis.

-  `stri_datetime_format`_ for date/time formatting and parsing. Also refer to the links therein for other date/time/time zone- related operations.

-  `stri_stats_general`_ and `stri_stats_latex`_ for gathering some fancy statistics on a character vector's contents.

-  `stri_join`_, `stri_dup`_, `%s+%`_, and `stri_flatten`_ for concatenation-based operations.

-  `stri_sub`_ for extracting and replacing substrings, and `stri_reverse`_ for a joyful function to reverse all code points in a string.

-  `stri_length`_ (among others) for determining the number of code points in a string. See also `stri_count_boundaries`_ for counting the number of Unicode characters and `stri_width`_ for approximating the width of a string.

-  `stri_trim`_ (among others) for trimming characters from the beginning or/and end of a string, see also `about_search_charclass`_, and `stri_pad`_ for padding strings so that they are of the same width. Additionally, `stri_wrap`_ wraps text into lines.

-  `stri_trans_tolower`_ (among others) for case mapping, i.e., conversion to lower, UPPER, or Title Case, `stri_trans_nfc`_ (among others) for Unicode normalization, `stri_trans_char`_ for translating individual code points, and `stri_trans_general`_ for other universal yet powerful text transforms, including transliteration.

-  `stri_cmp`_, `%s<%`_, `stri_order`_, `stri_sort`_, `stri_rank`_, `stri_unique`_, and `stri_duplicated`_ for collation-based, locale-aware operations, see also `about_locale`_.

-  `stri_split_lines`_ (among others) to split a string into text lines.

-  `stri_escape_unicode`_ (among others) for escaping some code points.

-  `stri_rand_strings`_, `stri_rand_shuffle`_, and `stri_rand_lipsum`_ for generating (pseudo)random strings.

-  `stri_read_raw`_, `stri_read_lines`_, and `stri_write_lines`_ for reading and writing text files.

Note that each man page provides many further links to other interesting facilities and topics.

Author(s)
~~~~~~~~~

Marek Gagolewski, with contributions from Bartek Tartanus and many others. ICU4C was developed by IBM, Unicode, Inc., and others.

References
~~~~~~~~~~

*stringi Package homepage*, https://stringi.gagolewski.com/

*ICU – International Components for Unicode*, http://site.icu-project.org/

*ICU4C API Documentation*, https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/

*The Unicode Consortium*, https://home.unicode.org/

*UTF-8, a transformation format of ISO 10646* – RFC 3629, https://tools.ietf.org/html/rfc3629

See Also
~~~~~~~~

Other stringi_general_topics: `about_arguments`_, `about_encoding`_, `about_locale`_, `about_search_boundaries`_, `about_search_charclass`_, `about_search_coll`_, `about_search_fixed`_, `about_search_regex`_, `about_search`_

.. _about_encoding: about_encoding.html
.. _about_locale: about_locale.html
.. _stri_opts_collator: stri_opts_collator.html
.. _about_arguments: about_arguments.html
.. _about_search: about_search.html
.. _about_search_regex: about_search_regex.html
.. _about_search_fixed: about_search_fixed.html
.. _about_search_coll: about_search_coll.html
.. _about_search_charclass: about_search_charclass.html
.. _about_search_boundaries: about_search_boundaries.html
.. _stri_datetime_format: stri_datetime_format.html
.. _stri_stats_general: stri_stats_general.html
.. _stri_stats_latex: stri_stats_latex.html
.. _stri_join: stri_join.html
.. _stri_dup: stri_dup.html
.. _%s+%: operator_add.html
.. _stri_flatten: stri_flatten.html
.. _stri_sub: stri_sub.html
.. _stri_reverse: stri_reverse.html
.. _stri_length: stri_length.html
.. _stri_count_boundaries: stri_count_boundaries.html
.. _stri_width: stri_width.html
.. _stri_trim: stri_trim.html
.. _stri_pad: stri_pad.html
.. _stri_wrap: stri_wrap.html
.. _stri_trans_tolower: stri_trans_casemap.html
.. _stri_trans_nfc: stri_trans_nf.html
.. _stri_trans_char: stri_trans_char.html
.. _stri_trans_general: stri_trans_general.html
.. _stri_cmp: stri_compare.html
.. _%s<%: operator_compare.html
.. _stri_order: stri_order.html
.. _stri_sort: stri_sort.html
.. _stri_rank: stri_rank.html
.. _stri_unique: stri_unique.html
.. _stri_duplicated: stri_duplicated.html
.. _stri_split_lines: stri_split_lines.html
.. _stri_escape_unicode: stri_escape_unicode.html
.. _stri_rand_strings: stri_rand_strings.html
.. _stri_rand_shuffle: stri_rand_shuffle.html
.. _stri_rand_lipsum: stri_rand_lipsum.html
.. _stri_read_raw: stri_read_raw.html
.. _stri_read_lines: stri_read_lines.html
.. _stri_write_lines: stri_write_lines.html
