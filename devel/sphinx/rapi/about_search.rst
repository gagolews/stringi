about_search: String Searching
==============================

Description
~~~~~~~~~~~

This man page explains how to perform string search-based operations in stringi.

Details
~~~~~~~

The following independent string searching engines are available in stringi.

-  ``stri_*_regex`` – ICU's regular expressions (regexes), see `about_search_regex`_,

-  ``stri_*_fixed`` – locale-independent byte-wise pattern matching, see `about_search_fixed`_,

-  ``stri_*_coll`` – ICU's ``StringSearch``, locale-sensitive, Collator-based pattern search, useful for natural language processing tasks, see `about_search_coll`_,

-  ``stri_*_charclass`` – character classes search, e.g., Unicode General Categories or Binary Properties, see `about_search_charclass`_,

-  ``stri_*_boundaries`` – text boundary analysis, see `about_search_boundaries`_

Each search engine is able to perform many search-based operations. These may include:

-  ``stri_detect_*`` - detect if a pattern occurs in a string, see, e.g., `stri_detect`_,

-  ``stri_count_*`` - count the number of pattern occurrences, see, e.g., `stri_count`_,

-  ``stri_locate_*`` - locate all, first, or last occurrences of a pattern, see, e.g., `stri_locate`_,

-  ``stri_extract_*`` - extract all, first, or last occurrences of a pattern, see, e.g., `stri_extract`_ and, in case of regexes, `stri_match`_,

-  ``stri_replace_*`` - replace all, first, or last occurrences of a pattern, see, e.g., `stri_replace`_ and also `stri_trim`_,

-  ``stri_split_*`` - split a string into chunks indicated by occurrences of a pattern, see, e.g., `stri_split`_,

-  ``stri_startswith_*`` and ``stri_endswith_*`` detect if a string starts or ends with a pattern match, see, e.g., `stri_startswith`_,

-  ``stri_subset_*`` - return a subset of a character vector with strings that match a given pattern, see, e.g., `stri_subset`_.

See Also
~~~~~~~~

Other text_boundaries: `about_search_boundaries`_, `stri_count_boundaries()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_brkiter()`_, `stri_split_boundaries()`_, `stri_split_lines()`_, `stri_trans_tolower()`_, `stri_wrap()`_

Other search_regex: `about_search_regex`_, `stri_opts_regex()`_

Other search_fixed: `about_search_fixed`_, `stri_opts_fixed()`_

Other search_coll: `about_search_coll`_, `stri_opts_collator()`_

Other search_charclass: `about_search_charclass`_, `stri_trim_both()`_

Other search_detect: `stri_detect()`_, `stri_startswith()`_

Other search_count: `stri_count_boundaries()`_, `stri_count()`_

Other search_locate: `stri_locate_all_boundaries()`_, `stri_locate_all()`_

Other search_replace: `stri_replace_all()`_, `stri_trim_both()`_

Other search_split: `stri_split_boundaries()`_, `stri_split_lines()`_, `stri_split()`_

Other search_subset: `stri_subset()`_

Other search_extract: `stri_extract_all_boundaries()`_, `stri_extract_all()`_, `stri_match_all()`_

Other stringi_general_topics: `about_arguments`_, `about_encoding`_, `about_locale`_, `about_search_boundaries`_, `about_search_charclass`_, `about_search_coll`_, `about_search_fixed`_, `about_search_regex`_, `about_stringi`_

.. _about_search_regex: about_search_regex.html
.. _about_search_fixed: about_search_fixed.html
.. _about_search_coll: about_search_coll.html
.. _about_search_charclass: about_search_charclass.html
.. _about_search_boundaries: about_search_boundaries.html
.. _stri_detect: stri_detect.html
.. _stri_count: stri_count.html
.. _stri_locate: stri_locate.html
.. _stri_extract: stri_extract.html
.. _stri_match: stri_match.html
.. _stri_replace: stri_replace.html
.. _stri_trim: stri_trim.html
.. _stri_split: stri_split.html
.. _stri_startswith: stri_startsendswith.html
.. _stri_subset: stri_subset.html
.. _stri_count_boundaries(): stri_count_boundaries.html
.. _stri_extract_all_boundaries(): stri_extract_boundaries.html
.. _stri_locate_all_boundaries(): stri_locate_boundaries.html
.. _stri_opts_brkiter(): stri_opts_brkiter.html
.. _stri_split_boundaries(): stri_split_boundaries.html
.. _stri_split_lines(): stri_split_lines.html
.. _stri_trans_tolower(): stri_trans_casemap.html
.. _stri_wrap(): stri_wrap.html
.. _stri_opts_regex(): stri_opts_regex.html
.. _stri_opts_fixed(): stri_opts_fixed.html
.. _stri_opts_collator(): stri_opts_collator.html
.. _stri_trim_both(): stri_trim.html
.. _stri_detect(): stri_detect.html
.. _stri_startswith(): stri_startsendswith.html
.. _stri_count(): stri_count.html
.. _stri_locate_all(): stri_locate.html
.. _stri_replace_all(): stri_replace.html
.. _stri_split(): stri_split.html
.. _stri_subset(): stri_subset.html
.. _stri_extract_all(): stri_extract.html
.. _stri_match_all(): stri_match.html
.. _about_arguments: about_arguments.html
.. _about_encoding: about_encoding.html
.. _about_locale: about_locale.html
.. _about_stringi: about_stringi.html
