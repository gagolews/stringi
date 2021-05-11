about_arguments: Passing Arguments to Functions in stringi
==========================================================

Description
~~~~~~~~~~~

Below we explain how stringi deals (in most of the cases) with its functions' arguments.

Coercion of Arguments
~~~~~~~~~~~~~~~~~~~~~

When a character vector argument is expected, factors and other vectors coercible to characters vectors are silently converted with `as.character`_, otherwise an error is generated. Coercion from a list of non-atomic vectors each of length 1 issues a warning.

When a logical, numeric, or integer vector argument is expected, factors are converted with ``as.*(as.character(...))``, and other coercible vectors are converted with ``as.*``, otherwise an error is generated.

Vectorization
~~~~~~~~~~~~~

Almost all functions are vectorized with respect to all their arguments and the recycling rule is applied whenever necessary. Due to this property you may, for instance, search for one pattern in each given string, search for each pattern in one given string, and search for the i-th pattern within the i-th string. This behavior sometimes leads to peculiar results - we assume you know what you are doing.

We of course took great care of performance issues: e.g., in regular expression searching, regex matchers are reused from iteration to iteration, as long it is possible.

Functions with some non-vectorized arguments are rare: e.g., regular expression matcher's settings are established once per each call.

Some functions assume that a vector with one element is given as an argument (like ``collapse`` in `stri_join`_). In such cases, if an empty vector is given you will get an error and for vectors with more than 1 elements - a warning will be generated (only the first element will be used).

You may find details on vectorization behavior in the man pages on each particular function of your interest.

Handling Missing Values (``NA``\ s)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

stringi handles missing values consistently. For any vectorized operation, if at least one vector element is missing, then the corresponding resulting value is also set to ``NA``.

Preserving Input Objects' Attributes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Generally, all our functions drop input objects' attributes (e.g., `names`_, `dim`_, etc.). This is generally because of advanced vectorization and for efficiency reasons. Thus, if arguments' preserving is needed, please remember to copy important attributes manually or use, e.g., the subsetting operation like ``x[] <- stri_...(x, ...)``.

See Also
~~~~~~~~

Other stringi_general_topics: `about_encoding`_, `about_locale`_, `about_search_boundaries`_, `about_search_charclass`_, `about_search_coll`_, `about_search_fixed`_, `about_search_regex`_, `about_search`_, `about_stringi`_

.. _as.character: https://stat.ethz.ch/R-manual/R-patched/library/base/html/character.html
.. _stri_join: stri_join.html
.. _names: https://stat.ethz.ch/R-manual/R-patched/library/base/html/names.html
.. _dim: https://stat.ethz.ch/R-manual/R-patched/library/base/html/dim.html
.. _about_encoding: about_encoding.html
.. _about_locale: about_locale.html
.. _about_search_boundaries: about_search_boundaries.html
.. _about_search_charclass: about_search_charclass.html
.. _about_search_coll: about_search_coll.html
.. _about_search_fixed: about_search_fixed.html
.. _about_search_regex: about_search_regex.html
.. _about_search: about_search.html
.. _about_stringi: about_stringi.html
