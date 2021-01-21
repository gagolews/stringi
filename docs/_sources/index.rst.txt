stringi: THE String Processing Package for R
============================================

    **stringi (pronounced “stringy”, IPA [strinɡi]) is THE R package
    for very fast, portable, correct, consistent, and convenient string/text
    processing in any locale or character encoding.**

    -- by `Marek Gagolewski <https://www.gagolewski.com/>`_



Thanks to `ICU <https://www.icu-project.org>`_,
`stringi` fully supports a wide range
of `Unicode <https://www.unicode.org/>`_ standards.

It gives you a multitude of functions for:

* string concatenation, padding, wrapping,
* substring extraction,
* pattern searching (e.g., with ICU Java-like regular expressions),
* collation and sorting,
* random string generation,
* case mapping,
* string transliteration,
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
`stringr <https://stringr.tidyverse.org/>`_ package
(and since 2015 `stringr` is powered by `stringi`).
Moreover, Hadley suggested quite a few new package features.
The contributions from Bartłomiej Tartanus and
`many others <https://github.com/gagolews/stringi/graphs/contributors>`_
is greatly appreciated. Thanks!


.. toctree::
    :maxdepth: 2
    :caption: Tutorial

    Tutorial (Draft) <https://stringi.gagolewski.com/_static/vignette/stringi.pdf>


.. toctree::
    :maxdepth: 2
    :caption: API Documentation

    rapi.rst



.. toctree::
    :maxdepth: 2
    :caption: Other

    Source Code (GitHub) <https://github.com/gagolews/stringi>
    Bug Tracker and Feature Suggestions <https://github.com/gagolews/stringi/issues>
    CRAN <https://cran.r-project.org/web/packages/stringi/>
    news.rst
    install.rst



.. |downloads1| image:: https://cranlogs.r-pkg.org/badges/grand-total/stringi

.. |downloads2| image:: https://cranlogs.r-pkg.org/badges/last-month/stringi
