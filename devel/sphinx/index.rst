stringi: Fast and Portable Character String Processing in R
===========================================================

.. epigraph::
    **stringi (pronounced “stringy”, IPA [strinɡi]) is THE R package
    for very fast, portable, correct, consistent, and convenient string/text
    processing in any locale or character encoding.**



Thanks to `ICU <https://icu.unicode.org/>`_, *stringi* fully supports a wide
range of `Unicode <https://www.unicode.org/>`_ standards
(see also `this video <https://www.youtube.com/watch?v=-n2nlPHEMG8>`_).

.. code-block:: r

    stri_extract_all(regex="\\p{Emoji}",
        c("歡迎 欢迎! Χαίρετε! Bienvenidos! 😃❤🌍", "spam, spam, 🥓, 🍳, and spam"))
    ## [[1]]
    ## [1] "😃" "❤"  "🌍"
    ##
    ## [[2]]
    ## [1] "🥓" "🍳"

    stri_count_fixed("ACATGAACGGGTACACACTG", "ACA", overlap=TRUE)
    ## [1] 3

    stri_sort(c("cudný", "chladný", "hladný", "čudný"), locale="sk_SK")
    ## [1] "cudný"   "čudný"   "hladný"  "chladný"


*stringi* provides you with plenty of functions related to data cleansing,
information extraction, and natural language processing:

* string concatenation, padding, wrapping, and substring extraction,
* pattern searching (e.g., with ICU Java-like regular expressions),
* collation, sorting, and ranking,
* random string generation,
* string transliteration, case mapping and folding,
* Unicode normalisation,
* date-time formatting and parsing,

and many more.



*stringi* is among the most often downloaded `R <https://r-project.org/>`_
packages. |downloads1| |downloads2|

You can obtain it from `CRAN <https://cran.r-project.org/package=stringi>`_
by calling:

.. code-block:: r

    install.packages("stringi")




*stringi*'s source code is hosted on
`GitHub <https://github.com/gagolews/stringi>`_.
It is distributed under the open source BSD-3-clause
`license <https://raw.githubusercontent.com/gagolews/stringi/master/LICENSE>`_.

The package's API was inspired by that of the early (pre-tidyverse; v0.6.2)
version of Hadley Wickham's
`stringr <https://cran.r-project.org/package=stringr>`_
package (and since the 2015 v1.0.0 *stringr* is powered by *stringi*).
Moreover, Hadley suggested quite a few new package features.
The contributions from Bartłomiej Tartanus and
`many others <https://github.com/gagolews/stringi/graphs/contributors>`_
is greatly appreciated. Thanks!

**See also**: `stringx <https://stringx.gagolewski.com/>`_ –
a set of wrappers around *stringi* with a base R-compatible API.

.. note::
    To learn more about R, check out Marek's open-access (free!) textbook
    `Deep R Programming <https://deepr.gagolewski.com/>`_
    :cite:`deepr`\ .

**Citation**: Gagolewski M.,
*stringi*: Fast and portable character string processing in R,
*Journal of Statistical Software*  103(2), 2022, 1–59,
`doi:10.18637/jss.v103.i02 <https://dx.doi.org/10.18637/jss.v103.i02>`_.



..  COMMENT
    This should be part of some other section maybe.

    Base R functions are not suitable for natural language processing.
    In fact, Unicode should be part of every major platform/programming
    environment/application now. Still teaching only the K&R char* strings
    is too English-centric (as the early computer era was dominated by the US).
    https://en.wikipedia.org/wiki/List_of_languages_by_total_number_of_speakers:
    English ~1350 million speakers (but only 370 are native)
    Mandarin Chinese 1120 billion (920 native
    Hindi 600 billion
    Spanish 540
    Arabic 270
    Some languages (Python 3, PERL?, ..) switched to Unicode already;
    ICU takes you one step further
    36% of the world population use the Latin alphabet https://en.wikipedia.org/wiki/Latin_script
    Why would I use stringi over stringr? Using stringr you use stringi already.
    It's not about the API, it's about correctness.
    TODO: stringx
    stringi is not tidyverse





.. toctree::
    :maxdepth: 2
    :caption: stringi
    :hidden:

    About <self>
    Author <https://www.gagolewski.com/>
    install.md
    Source Code (GitHub) <https://github.com/gagolews/stringi>
    Bug Tracker and Feature Suggestions <https://github.com/gagolews/stringi/issues>
    CRAN Entry <https://cran.r-project.org/package=stringi>

.. toctree::
    :maxdepth: 2
    :caption: Tutorial

    weave/design_principles
    weave/basic_operations
    weave/codepoint_comparing
    weave/regular_expressions
    weave/collation
    weave/other_operations
    weave/input_output
    weave/example


.. toctree::
    :maxdepth: 2
    :caption: Reference Manual

    rapi.md



.. toctree::
    :maxdepth: 1
    :caption: Other

    Deep R Programming <https://deepr.gagolewski.com>
    stringx <https://stringx.gagolewski.com/>
    JStatSoft Paper <https://dx.doi.org/10.18637/jss.v103.i02>
    C++ API — Rcpp Example <https://github.com/gagolews/ExampleRcppStringi>
    news.md
    z_bibliography



.. |downloads1| image:: https://cranlogs.r-pkg.org/badges/grand-total/stringi

.. |downloads2| image:: https://cranlogs.r-pkg.org/badges/last-month/stringi
