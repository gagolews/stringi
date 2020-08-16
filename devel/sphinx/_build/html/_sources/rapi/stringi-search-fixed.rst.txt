stringi-search-fixed: Locale-Insensitive Fixed Pattern Matching in stringi
==========================================================================

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

see also `stringi-search-coll <stringi-search-coll.html>`__.

Note that the conversion of input data to Unicode is done as usual.

See Also
~~~~~~~~

Other search_fixed: `stri_opts_fixed() <stri_opts_fixed.html>`__, `stringi-search <stringi-search.html>`__

Other stringi_general_topics: `stringi-arguments <stringi-arguments.html>`__, `stringi-encoding <stringi-encoding.html>`__, `stringi-locale <stringi-locale.html>`__, `stringi-package <stringi-package.html>`__, `stringi-search-boundaries <stringi-search-boundaries.html>`__, `stringi-search-charclass <stringi-search-charclass.html>`__, `stringi-search-coll <stringi-search-coll.html>`__, `stringi-search-regex <stringi-search-regex.html>`__, `stringi-search <stringi-search.html>`__
