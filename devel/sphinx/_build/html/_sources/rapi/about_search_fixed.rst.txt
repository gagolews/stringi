about_search_fixed: Locale-Insensitive Fixed Pattern Matching in stringi
========================================================================

Description
~~~~~~~~~~~

String searching facilities described here provide a way to locate a specific sequence of bytes in a string. The search engine's settings may be tuned up (for example to perform case-insensitive search) via a call to the `stri_opts_fixed <stri_opts_fixed.html>`__ function.

Byte Compare
~~~~~~~~~~~~

The fast Knuth-Morris-Pratt search algorithm, with worst time complexity of O(n+p) (``n == length(str)``, ``p == length(pattern)``) is implemented (with some tweaks for very short search patterns).

Be aware that, for natural language processing, fixed pattern searching might not be what you actually require. It is because a bitwise match will not give correct results in cases of:

#. accented letters;

#. conjoined letters;

#. ignorable punctuation;

#. ignorable case,

see also `about_search_coll <about_search_coll.html>`__.

Note that the conversion of input data to Unicode is done as usual.

See Also
~~~~~~~~

Other search_fixed: `about_search <about_search.html>`__, `stri_opts_fixed() <stri_opts_fixed.html>`__

Other stringi_general_topics: `about_arguments <about_arguments.html>`__, `about_encoding <about_encoding.html>`__, `about_locale <about_locale.html>`__, `about_search_boundaries <about_search_boundaries.html>`__, `about_search_charclass <about_search_charclass.html>`__, `about_search_coll <about_search_coll.html>`__, `about_search_regex <about_search_regex.html>`__, `about_search <about_search.html>`__, `about_stringi <about_stringi.html>`__
