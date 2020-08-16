stringi-arguments: Passing Arguments to Functions in stringi
============================================================

Description
~~~~~~~~~~~

Below we explain how stringi deals (in most of the cases) with its functions' arguments.

Coercion of Arguments
~~~~~~~~~~~~~~~~~~~~~

When a character vector argument is expected, factors and other vectors coercible to characters vectors are silently converted with ``as.character``, otherwise an error is generated. Coercion from a list of non-atomic vectors each of length 1 issues a warning.

When a logical, numeric, or integer vector argument is expected, factors are converted with ``as.*(as.character(...))``, and other coercible vectors are converted with ``as.*``, otherwise an error is generated.

Vectorization
~~~~~~~~~~~~~

Almost all functions are vectorized with respect to all their arguments and the recycling rule is applied whenever necessary. Due to this property you may, for instance, search for one pattern in each given string, search for each pattern in one given string, and search for the i-th pattern within the i-th string. This behaviod sometimes leads to peculiar results - we assume you know what you are doing.

We of course took great care of performance issues: e.g., in regular expression searching, regex matchers are reused from iteration to iteration, as long it is possible.

Functions with some non-vectorized arguments are rare: e.g., regular expression matcher's settings are established once per each call.

Some functions assume that a vector with one element is given as an argument (like ``collapse`` in `stri_join <stri_join.html>`__). In such cases, if an empty vector is given you will get an error and for vectors with more than 1 elements - a warning will be generated (only the first element will be used).

You may find details on vectorization behavior in the man pages on each particular function of your interest.

Handling Missing Values (``NA``\ s)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

stringi handles missing values consistently. For any vectorized operation, if at least one vector element is missing, then the corresponding resulting value is also set to ``NA``.

Preserving Input Objects' Attributes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Generally, all our functions drop input objects' attributes (e.g., ``names``, ``dim``, etc.). This is generally because of advanced vectorization and for efficiency reasons. Thus, if arguments' preserving is needed, please remember to copy important attributes manually or use, e.g., the subsetting operation like ``x[] <- stri_...(x, ...)``.

See Also
~~~~~~~~

Other stringi_general_topics: `stringi-encoding <stringi-encoding.html>`__, `stringi-locale <stringi-locale.html>`__, `stringi-package <stringi-package.html>`__, `stringi-search-boundaries <stringi-search-boundaries.html>`__, `stringi-search-charclass <stringi-search-charclass.html>`__, `stringi-search-coll <stringi-search-coll.html>`__, `stringi-search-fixed <stringi-search-fixed.html>`__, `stringi-search-regex <stringi-search-regex.html>`__, `stringi-search <stringi-search.html>`__
