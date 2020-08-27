about_search: String Searching
==============================

Description
~~~~~~~~~~~

This man page explains how to perform string search-based operations in stringi.

Details
~~~~~~~

The following independent string searching engines are available in stringi.

-  ``stri_*_regex`` – ICU's regular expressions (regexes), see `about_search_regex <about_search_regex.html>`__,

-  ``stri_*_fixed`` – locale-independent byte-wise pattern matching, see `about_search_fixed <about_search_fixed.html>`__,

-  ``stri_*_coll`` – ICU's ``StringSearch``, locale-sensitive, Collator-based pattern search, useful for natural language processing tasks, see `about_search_coll <about_search_coll.html>`__,

-  ``stri_*_charclass`` – character classes search, e.g., Unicode General Categories or Binary Properties, see `about_search_charclass <about_search_charclass.html>`__,

-  ``stri_*_boundaries`` – text boundary analysis, see `about_search_boundaries <about_search_boundaries.html>`__

Each search engine is able to perform many search-based operations. These may include:

-  ``stri_detect_*`` - detect if a pattern occurs in a string, see, e.g., `stri_detect <stri_detect.html>`__,

-  ``stri_count_*`` - count the number of pattern occurrences, see, e.g., `stri_count <stri_count.html>`__,

-  ``stri_locate_*`` - locate all, first, or last occurrences of a pattern, see, e.g., `stri_locate <stri_locate.html>`__,

-  ``stri_extract_*`` - extract all, first, or last occurrences of a pattern, see, e.g., `stri_extract <stri_extract.html>`__ and, in case of regexes, `stri_match <stri_match.html>`__,

-  ``stri_replace_*`` - replace all, first, or last occurrences of a pattern, see, e.g., `stri_replace <stri_replace.html>`__ and also `stri_trim <stri_trim.html>`__,

-  ``stri_split_*`` - split a string into chunks indicated by occurrences of a pattern, see, e.g., `stri_split <stri_split.html>`__,

-  ``stri_startswith_*`` and ``stri_endswith_*`` detect if a string starts or ends with a pattern match, see, e.g., `stri_startswith <stri_startsendswith.html>`__,

-  ``stri_subset_*`` - return a subset of a character vector with strings that match a given pattern, see, e.g., `stri_subset <stri_subset.html>`__.

See Also
~~~~~~~~

Other text_boundaries: `about_search_boundaries <about_search_boundaries.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_brkiter() <stri_opts_brkiter.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_split_lines() <stri_split_lines.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_wrap() <stri_wrap.html>`__

Other search_regex: `about_search_regex <about_search_regex.html>`__, `stri_opts_regex() <stri_opts_regex.html>`__

Other search_fixed: `about_search_fixed <about_search_fixed.html>`__, `stri_opts_fixed() <stri_opts_fixed.html>`__

Other search_coll: `about_search_coll <about_search_coll.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__

Other search_charclass: `about_search_charclass <about_search_charclass.html>`__, `stri_trim_both() <stri_trim.html>`__

Other search_detect: `stri_detect() <stri_detect.html>`__, `stri_startswith() <stri_startsendswith.html>`__

Other search_count: `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_count() <stri_count.html>`__

Other search_locate: `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_locate_all() <stri_locate.html>`__

Other search_replace: `stri_replace_all() <stri_replace.html>`__, `stri_trim_both() <stri_trim.html>`__

Other search_split: `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_split_lines() <stri_split_lines.html>`__, `stri_split() <stri_split.html>`__

Other search_subset: `stri_subset() <stri_subset.html>`__

Other search_extract: `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_extract_all() <stri_extract.html>`__, `stri_match_all() <stri_match.html>`__

Other stringi_general_topics: `about_arguments <about_arguments.html>`__, `about_encoding <about_encoding.html>`__, `about_locale <about_locale.html>`__, `about_search_boundaries <about_search_boundaries.html>`__, `about_search_charclass <about_search_charclass.html>`__, `about_search_coll <about_search_coll.html>`__, `about_search_fixed <about_search_fixed.html>`__, `about_search_regex <about_search_regex.html>`__, `about_stringi <about_stringi.html>`__
