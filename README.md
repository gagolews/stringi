# **stringi**

### THE String Processing Package for *R*



![Build Status](https://github.com/gagolews/stringi/workflows/stringi%20for%20R/badge.svg)
[![DOI](https://zenodo.org/badge/7457004.svg)](https://zenodo.org/badge/latestdoi/7457004)
![RStudio CRAN mirror downloads](http://cranlogs.r-pkg.org/badges/grand-total/stringi)
![RStudio CRAN mirror downloads](http://cranlogs.r-pkg.org/badges/last-month/stringi)
![RStudio CRAN mirror downloads](http://cranlogs.r-pkg.org/badges/last-day/stringi)


> Online reference manual is available at https://stringi.gagolewski.com/.

> Paper on **stringi** (draft version — any comments are welcome)
is available at https://stringi.gagolewski.com/_static/vignette/stringi.pdf.


**stringi**  (pronounced “stringy”, IPA [strinɡi]) is THE *R*
package for string/text/natural language processing.
It is very fast, consistent, convenient, and — thanks to the
[ICU – International Components for Unicode](http://site.icu-project.org/)
library — portable across all locales and platforms.

Available features include:

* string concatenation, padding, wrapping,
* substring extraction,
* pattern searching (e.g., with Java-like regular expressions),
* collation and sorting,
* random string generation,
* case mapping and folding,
* string transliteration,
* Unicode normalisation,
* date-time formatting and parsing,

and many more.



**Package Maintainer**: [Marek Gagolewski](https://www.gagolewski.com/)

**Authors and Contributors**: [Marek Gagolewski](https://www.gagolewski.com/),
with contributions from Bartłomiej Tartanus and many others.

The package's API was inspired by that of the early (pre-tidyverse; v0.6.2)
version of Hadley Wickham's
[stringr](https://cran.r-project.org/web/packages/stringr/)
package (and since the 2015 v1.0.0 *stringr* is powered by *stringi*).



**Homepage**: https://stringi.gagolewski.com/

**CRAN Entry**: https://cran.r-project.org/web/packages/stringi/

[How to access the stringi C++ API from within an Rcpp-based R package](https://github.com/gagolews/ExampleRcppStringi)

**System Requirements**: *R >= 3.1*, *ICU4C >= 55* (refer to the
[INSTALL](https://raw.githubusercontent.com/gagolews/stringi/master/INSTALL)
file for more details)

**License**: *stringi*'s source code is distributed under the open source
BSD-3-clause license, for more details see the
[LICENSE](https://raw.githubusercontent.com/gagolews/stringi/master/LICENSE) file.

This *git* repository also contains a custom subset of *ICU4C* source code
which is copyrighted by Unicode, Inc. and others.
A binary version of the Unicode Character Database is included.
For more details on copyright holders see the
[LICENSE](https://raw.githubusercontent.com/gagolews/stringi/master/LICENSE) file.
The *ICU* project is covered by the
[Unicode license](https://github.com/unicode-org/icu/blob/main/icu4c/LICENSE) —
a simple, permissive non-copyleft free software license, compatible with
the GNU GPL. The *ICU* license
is [intended](http://userguide.icu-project.org/icufaq#TOC-How-is-the-ICU-licensed-)
to allow *ICU* to be included in free software projects as well as
in proprietary or commercial products.

**Changes**: see the
[NEWS](https://raw.githubusercontent.com/gagolews/stringi/master/NEWS) file.
