# **stringi**

### THE String Processing Package for *R*



![Build Status](https://github.com/gagolews/stringi/workflows/stringi%20for%20R/badge.svg)
[![DOI](https://zenodo.org/badge/7457004.svg)](https://zenodo.org/badge/latestdoi/7457004)
![RStudio CRAN mirror downloads](http://cranlogs.r-pkg.org/badges/grand-total/stringi)
![RStudio CRAN mirror downloads](http://cranlogs.r-pkg.org/badges/last-month/stringi)
![RStudio CRAN mirror downloads](http://cranlogs.r-pkg.org/badges/last-day/stringi)


> The package documentation is available at https://stringi.gagolewski.com/.



**stringi**  (pronounced “stringy”, IPA [strinɡi]) is THE *R*
package for string/text/natural language processing.
It is very fast, consistent, convenient,
and — thanks to the [ICU – International Components for Unicode](http://site.icu-project.org/)
library — portable across all locales and platforms.

Available features include:

* string concatenation, padding, wrapping,
* substring extraction,
* pattern searching (e.g., with 'Java'-like regular expressions or the Unicode collation algorithm),
* random string generation,
* case mapping,
* string transliteration,
* Unicode normalisation,
* date-time formatting and parsing,

and many more.



**Package Maintainer**: [Marek Gagolewski](http://www.gagolewski.com/)

**Authors and Contributors**: [Marek Gagolewski](http://www.gagolewski.com/),
with contributions from Bartłomiej Tartanus and many others.

The package's API was inspired by
Hadley Wickham's [stringr](http://cran.r-project.org/web/packages/stringr)
package (and since 2015 *stringr* is based on *stringi*).



**Homepage**: https://stringi.gagolewski.com/

**CRAN Entry**: https://cran.r-project.org/web/packages/stringi/

[How to access the stringi C++ API from within an Rcpp-based R package](https://github.com/gagolews/ExampleRcppStringi)

**System Requirements**: *R >= 2.14*, *ICU4C >= 55* (refer to the
[INSTALL](http://raw.githubusercontent.com/gagolews/stringi/master/INSTALL)
file for more details)

**License**: *stringi*'s source code is licensed under the open source
BSD-3-clause, for more details see the
[LICENSE](http://raw.githubusercontent.com/gagolews/stringi/master/LICENSE) file.

This *git* repository also contains a custom subset of *ICU4C 55.1*
and *ICU4C 61.1* source code which is copyrighted by Unicode and others.
A binary version of the Unicode Character Database is included.
For more details on copyright holders see the
[LICENSE](http://raw.githubusercontent.com/gagolews/stringi/master/LICENSE) file.
The *ICU* project is covered by the
[ICU license](http://source.icu-project.org/repos/icu/icu/trunk/LICENSE) —
a simple, permissive non-copyleft free software license, compatible with
the GNU GPL. The *ICU* license
is [intended](http://userguide.icu-project.org/icufaq#TOC-How-is-the-ICU-licensed-)
to allow *ICU* to be included both in free software projects
and in proprietary or commercial products.

**Changes**: see the
[NEWS](http://raw.githubusercontent.com/gagolews/stringi/master/NEWS) file.
