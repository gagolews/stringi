# **stringi**

### THE string processing package for *R*

[![Build Status](https://travis-ci.org/gagolews/stringi.svg?branch=master)](https://travis-ci.org/gagolews/stringi)
[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.19071.svg)](http://dx.doi.org/10.5281/zenodo.19071)
![RStudio CRAN mirror downloads](http://cranlogs.r-pkg.org/badges/grand-total/stringi)
![RStudio CRAN mirror downloads](http://cranlogs.r-pkg.org/badges/last-month/stringi)
![RStudio CRAN mirror downloads](http://cranlogs.r-pkg.org/badges/last-week/stringi)
![RStudio CRAN mirror downloads](http://cranlogs.r-pkg.org/badges/last-day/stringi)

**stringi** is THE *R* package for very fast, correct, consistent,
and convenient string/text processing in each locale and any native
character encoding. The use of the *ICU* library gives *R* users a
platform-independent set of functions known to *Java*, *Perl*, *Python*,
*PHP*, and *Ruby* programmers. The package's API was inspired by
Hadley Wickham's [stringr](http://cran.r-project.org/web/packages/stringr)
package (since 2015, *stringr* itself is based on *stringi*).

**Package maintainer**: [Marek Gagolewski](http://www.gagolewski.com/)

**Authors**: [Marek Gagolewski](http://www.gagolewski.com/),
with contributions from Bartlomiej Tartanus and others.

This git repository also contains a custom subset of *ICU4C 55.1* source code
which is copyrighted by IBM and others. A binary
version of the Unicode Character Database is included.
For more details on copyright holders see the
[LICENSE](http://raw.githubusercontent.com/gagolews/stringi/master/LICENSE) file.

**Homepage**: http://www.gagolewski.com/software/stringi/

**CRAN entry**: http://cran.r-project.org/web/packages/stringi/

**Online manual**: http://www.gagolewski.com/software/stringi/manual/

[How to access the stringi C API from an Rcpp-based R package](https://github.com/gagolews/ExampleRcppStringi)

**System requirements**: *R >= 2.14*, *ICU4C >= 52* (refer to the
[INSTALL](http://raw.githubusercontent.com/gagolews/stringi/master/INSTALL)
file for more details)

**License**: BSD-3-clause, for more details see the
[LICENSE](http://raw.githubusercontent.com/gagolews/stringi/master/LICENSE) file.

> **stringi**'s source code itself is released under the BSD-3-clause license,
> which is 100% open source compatible. Such a license has been verified as
> [GPL-compatible](http://en.wikipedia.org/wiki/BSD_licenses)
> by the Free Software Foundation.
>
> The reason for using BSD-3-clause is that we include full source
> code of the *ICU* library, which has its own license.
> The *ICU* projects are covered by the
> [ICU license](http://source.icu-project.org/repos/icu/icu/trunk/LICENSE),
> a simple, permissive non-copyleft free software license, compatible with
> the GNU GPL. The *ICU* license is
> [intended](http://userguide.icu-project.org/icufaq#TOC-How-is-the-ICU-licensed-)
> to allow *ICU* to be included both in free software projects
> and in proprietary or commercial products.

**Changes**: see the
[NEWS](http://raw.githubusercontent.com/gagolews/stringi/master/NEWS) file.
