about_search_fixed: Locale-Insensitive Fixed Pattern Matching in stringi
========================================================================

Description
~~~~~~~~~~~

String searching facilities described here provide a way to locate a specific sequence of bytes in a string. The search engine's settings may be tuned up (for example to perform case-insensitive search) via a call to the `stri_opts_fixed`_ function.

Byte Compare
~~~~~~~~~~~~

The fast Knuth-Morris-Pratt search algorithm, with worst time complexity of O(n+p) (``n == length(str)``, ``p == length(pattern)``) is implemented (with some tweaks for very short search patterns).

Be aware that, for natural language processing, fixed pattern searching might not be what you actually require. It is because a bitwise match will not give correct results in cases of:

#. accented letters;

#. conjoined letters;

#. ignorable punctuation;

#. ignorable case,

see also `about_search_coll`_.

Note that the conversion of input data to Unicode is done as usual.

See Also
~~~~~~~~

Other search_fixed: `about_search`_, `stri_opts_fixed()`_

Other stringi_general_topics: `about_arguments`_, `about_encoding`_, `about_locale`_, `about_search_boundaries`_, `about_search_charclass`_, `about_search_coll`_, `about_search_regex`_, `about_search`_, `about_stringi`_

.. _stri_opts_fixed: stri_opts_fixed.html
.. _about_search_coll: about_search_coll.html
.. _about_search: about_search.html
.. _stri_opts_fixed(): stri_opts_fixed.html
.. _about_arguments: about_arguments.html
.. _about_encoding: about_encoding.html
.. _about_locale: about_locale.html
.. _about_search_boundaries: about_search_boundaries.html
.. _about_search_charclass: about_search_charclass.html
.. _about_search_regex: about_search_regex.html
.. _about_stringi: about_stringi.html
