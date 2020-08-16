stringi: THE String Processing Package for R
============================================

    **stringi (pronounced “stringy”, IPA [strinɡi]) is THE R package
    for very fast, portable, correct, consistent, and convenient string/text
    processing in any locale or character encoding.**

    -- by `Marek Gagolewski <https://www.gagolewski.com/>`_



Thanks to the use of the `ICU <https://www.icu-project.org>`_
library, `stringi` fully supports `Unicode <https://www.unicode.org/>`_.
It gives you a multitude of functions for:

* pattern searching (e.g., with ICU Java-like regular expressions or the
  Unicode Collation Algorithm),
* collation and sorting,
* random string generation,
* case mapping,
* string transliteration,
* concatenation,
* Unicode normalisation,
* date-time formatting and parsing,

and many more.

`stringi` is among the most often downloaded `R <https://r-project.org/>`_
packages. |downloads1| |downloads2|

You can obtain it from `CRAN <https://cran.r-project.org/web/packages/stringi/>`_
by calling:

.. code-block:: r

    install.packages("stringi")




`stringi`'s source code is hosted on `GitHub <https://github.com/gagolews/stringi>`_.
It has been released under the open source BSD-3-clause
`license <https://raw.githubusercontent.com/gagolews/stringi/master/LICENSE>`_.

The package's API was inspired by Hadley Wickham's
`stringr <https://cran.r-project.org/web/packages/stringr/>`_ package
(and since 2015 `stringr` is based on `stringi`).
Moreover, Hadley suggested many new cool package features. Thanks!
The contributions from Bartlomiej Tartanus and
`many others <https://github.com/gagolews/stringi/graphs/contributors>`_
is greatly appreciated.



.. toctree::
    :maxdepth: 2
    :caption: API Documentation

    rapi.rst



.. toctree::
    :maxdepth: 2
    :caption: External Links

    Source code (GitHub) <https://github.com/gagolews/stringi>
    Bug Tracker and Feature Proposals <https://github.com/gagolews/stringi/issues>
    CRAN <https://cran.r-project.org/web/packages/stringi/>



.. |downloads1| image:: https://cranlogs.r-pkg.org/badges/grand-total/stringi

.. |downloads2| image:: https://cranlogs.r-pkg.org/badges/last-month/stringi
