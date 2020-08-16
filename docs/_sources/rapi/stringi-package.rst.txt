stringi-package: THE String Processing Package
==============================================

Description
~~~~~~~~~~~

stringi is THE R package for fast, correct, consistent, and convenient string/text manipulation. It gives predictable results on every platform, in each locale, and under any “native” character encoding.

**Keywords**: R, text processing, character strings, internationalization, localization, ICU, ICU4C, i18n, l10n, Unicode.

**Homepage**: https://stringi.gagolewski.com/

**License**: The BSD-3-clause license for the package code, the ICU license for the accompanying ICU4C distribution, and the UCD license for the Unicode Character Database. See the COPYRIGHTS and LICENSE file for more details.

Details
~~~~~~~

Manual pages on general topics:

-  `stringi-encoding <stringi-encoding.html>`__ – character encoding issues, including information on encoding management in stringi, as well as on encoding detection and conversion.

-  `stringi-locale <stringi-locale.html>`__ – locale issues, including locale management and specification in stringi, and the list of locale-sensitive operations. In particular, see `stri_opts_collator <stri_opts_collator.html>`__ for a description of the string collation algorithm, which is used for string comparing, ordering, sorting, case-folding, and searching.

-  `stringi-arguments <stringi-arguments.html>`__ – information on how stringi treats its functions' arguments.

Facilities available
~~~~~~~~~~~~~~~~~~~~

Refer to the following:

-  `stringi-search <stringi-search.html>`__ for string searching facilities; these include pattern searching, matching, string splitting, and so on. The following independent search engines are provided:

   -  `stringi-search-regex <stringi-search-regex.html>`__ – with ICU (Java-like) regular expressions,

   -  `stringi-search-fixed <stringi-search-fixed.html>`__ – fast, locale-independent, byte-wise pattern matching,

   -  `stringi-search-coll <stringi-search-coll.html>`__ – locale-aware pattern matching for natural language processing tasks,

   -  `stringi-search-charclass <stringi-search-charclass.html>`__ – seeking elements of particular character classes, like “all whites-paces” or “all digits”,

   -  `stringi-search-boundaries <stringi-search-boundaries.html>`__ – text boundary analysis.

-  `stri_datetime_format <stri_datetime_format.html>`__ for date/time formatting and parsing. Also refer to the links therein for other date/time/time zone- related operations.

-  `stri_stats_general <stri_stats_general.html>`__ and `stri_stats_latex <stri_stats_latex.html>`__ for gathering some fancy statistics on a character vector's contents.

-  `stri_join <stri_join.html>`__, `stri_dup <stri_dup.html>`__, `%s+% <oper_plus.html>`__, and `stri_flatten <stri_flatten.html>`__ for concatenation-based operations.

-  `stri_sub <stri_sub.html>`__ for extracting and replacing substrings, and `stri_reverse <stri_reverse.html>`__ for a joyful function to reverse all code points in a string.

-  `stri_length <stri_length.html>`__ (among others) for determining the number of code points in a string. See also `stri_count_boundaries <stri_count_boundaries.html>`__ for counting the number of ``Unicode characters`` and `stri_width <stri_width.html>`__ for approximating the width of a string.

-  `stri_trim <stri_trim.html>`__ (among others) for trimming characters from the beginning or/and end of a string, see also `stringi-search-charclass <stringi-search-charclass.html>`__, and `stri_pad <stri_pad.html>`__ for padding strings so that they are of the same width. Additionally, `stri_wrap <stri_wrap.html>`__ wraps text into lines.

-  `stri_trans_tolower <stri_trans_casemap.html>`__ (among others) for case mapping, i.e., conversion to lower, UPPER, or Title Case, `stri_trans_nfc <stri_trans_nf.html>`__ (among others) for Unicode normalization, `stri_trans_char <stri_trans_char.html>`__ for translating individual code points, and `stri_trans_general <stri_trans_general.html>`__ for other universal yet powerful text transforms, including transliteration.

-  `stri_cmp <stri_compare.html>`__, `%s<% <oper_comparison.html>`__, `stri_order <stri_order.html>`__, `stri_sort <stri_sort.html>`__, `stri_unique <stri_unique.html>`__, and `stri_duplicated <stri_duplicated.html>`__ for collation-based, locale-aware operations, see also `stringi-locale <stringi-locale.html>`__.

-  `stri_split_lines <stri_split_lines.html>`__ (among others) to split a string into text lines.

-  `stri_escape_unicode <stri_escape_unicode.html>`__ (among others) for escaping some code points.

-  `stri_rand_strings <stri_rand_strings.html>`__, `stri_rand_shuffle <stri_rand_shuffle.html>`__, and `stri_rand_lipsum <stri_rand_lipsum.html>`__ for generating (pseudo)random strings.

-  DRAFT API: `stri_read_raw <stri_read_raw.html>`__, `stri_read_lines <stri_read_lines.html>`__, and `stri_write_lines <stri_write_lines.html>`__ for reading and writing text files.

Note that each man page provides many further links to other interesting facilities and topics.

Author(s)
~~~~~~~~~

Marek Gagolewski, with contributions from Bartek Tartanus and others. ICU4C was developed by IBM and others. The Unicode Character Database is due to Unicode, Inc.; see the COPYRIGHTS file for more details.

References
~~~~~~~~~~

*stringi Package homepage*, https://stringi.gagolewski.com/

*ICU – International Components for Unicode*, http://www.icu-project.org/

*ICU4C API Documentation*, http://www.icu-project.org/apiref/icu4c/

*The Unicode Consortium*, http://www.unicode.org/

*UTF-8, a transformation format of ISO 10646* – RFC 3629, http://tools.ietf.org/html/rfc3629

See Also
~~~~~~~~

Other stringi_general_topics: `stringi-arguments <stringi-arguments.html>`__, `stringi-encoding <stringi-encoding.html>`__, `stringi-locale <stringi-locale.html>`__, `stringi-search-boundaries <stringi-search-boundaries.html>`__, `stringi-search-charclass <stringi-search-charclass.html>`__, `stringi-search-coll <stringi-search-coll.html>`__, `stringi-search-fixed <stringi-search-fixed.html>`__, `stringi-search-regex <stringi-search-regex.html>`__, `stringi-search <stringi-search.html>`__
