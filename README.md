<a href="https://stringi.gagolewski.com/"><img src="https://www.gagolewski.com/_static/img/stringi.png" align="right" height="128" width="128" /></a>
# [**`stringi`**](https://stringi.gagolewski.com/)

### Fast and Portable Character String Processing in R (with the Unicode ICU)

![Build Status](https://github.com/gagolews/stringi/workflows/stringi%20for%20R/badge.svg)
![RStudio CRAN mirror downloads](http://cranlogs.r-pkg.org/badges/grand-total/stringi)
![RStudio CRAN mirror downloads](http://cranlogs.r-pkg.org/badges/last-month/stringi)
![RStudio CRAN mirror downloads](http://cranlogs.r-pkg.org/badges/last-day/stringi)


> A comprehensive tutorial and reference manual is available
> at <https://stringi.gagolewski.com/>.
>
> Check out [**`stringx`**](https://stringx.gagolewski.com/) for a set of wrappers
> around **`stringi`** with a base R-compatible API.
>
> To learn more about R, check out Marek's open-access (free!) textbook
> [Deep R Programming](https://deepr.gagolewski.com/).

**`stringi`**  (pronounced “stringy”, IPA [strinɡi])
is THE *R* package for string/text/natural language processing.
It is very fast, consistent, convenient, and — thanks to the
[ICU – International Components for Unicode](https://icu.unicode.org/)
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
[**`stringr`**](https://cran.r-project.org/web/packages/stringr/)
package (and since the 2015 v1.0.0 **`stringr`** is powered by **`stringi`**).


**Homepage**: https://stringi.gagolewski.com/

**Citation**: Gagolewski M.,
**`stringi`**: Fast and portable character string processing in R,
*Journal of Statistical Software*  **103**(2), 2022, 1–59,
<https://dx.doi.org/10.18637/jss.v103.i02>.

**CRAN Entry**: https://CRAN.R-project.org/package=stringi

**System Requirements**: *R >= 3.4*, *ICU4C >= 61* (refer to the
[INSTALL](https://raw.githubusercontent.com/gagolews/stringi/master/INSTALL)
file for more details)

**License**: **`stringi`**'s source code is distributed under the open source
BSD-3-clause license. For more details, see
[LICENSE](https://raw.githubusercontent.com/gagolews/stringi/master/LICENSE).

This *git* repository also contains a custom subset of *ICU4C* source code which
is copyrighted by Unicode, Inc. and others. A binary version of the Unicode
Character Database is included. For more details on copyright holders, see
[LICENSE](https://raw.githubusercontent.com/gagolews/stringi/master/LICENSE).
The *ICU* project is covered by the
[Unicode license](https://github.com/unicode-org/icu/blob/main/icu4c/LICENSE) —
a simple, permissive non-copyleft free software license, compatible with
the GNU GPL. The *ICU* license
is [intended](https://unicode-org.github.io/icu/userguide/icu4c/faq.html)
to allow *ICU* to be included in free software projects as well as
in proprietary or commercial products.

**Changes**: see the
[NEWS](https://raw.githubusercontent.com/gagolews/stringi/master/NEWS) file.

[How to access the stringi C++ API from within an Rcpp-based R package](https://github.com/gagolews/ExampleRcppStringi)
