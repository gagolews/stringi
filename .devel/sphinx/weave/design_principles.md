

General Design Principles
=========================



> This tutorial is based on the [paper on *stringi*](https://dx.doi.org/10.18637/jss.v103.i02) that was published in the *Journal of Statistical Software*; see {cite}`stringi`. To learn more about R, check out Marek's open-access (free!) textbook [*Deep R Programming*](https://deepr.gagolewski.com/) {cite}`deepr`.


The API of the early releases of *stringi* has been designed to be
fairly compatible with that of the 0.6.2 version of the [*stringr*](https://stringr.tidyverse.org/)
package {cite}`Wickham2010:stringr` (dated 2012[^footstringr]),
with some fixes in the consistency of the
handling of missing values and zero-length vectors, amongst others.
However, instead of being merely thin wrappers around base R[^footstringx] functions,
which we have identified as not necessarily portable across platforms
and not really suitable for natural language processing tasks, all the
functionality has been implemented from the ground up, with the use of
[*ICU*](https://icu.unicode.org/) services wherever applicable.
Since the initial release, an
abundance of new features has been added, and the package can now be
considered a complete workhorse for text data processing.

Note that
the *stringi* API is stable. Future releases will aim for as much
backward compatibility as possible so that other software projects can
safely rely on it.

[^footstringr]: Interestingly, in 2015 the aforementioned
    *stringr* package was rewritten as a set of wrappers around some of
    the *stringi* functions instead of the base R ones. In Section 14.7 of
    *R for Data Science* {cite}`GrolemundWickham2017:rdatascience` we read:
    "*stringr* is useful when you're learning because it exposes a minimal
    set of functions, which have been carefully picked to handle the most
    common string manipulation functions. *stringi*, on the other hand, is
    designed to be comprehensive. It contains almost every function you
    might ever need: *stringi* has 250 functions to *stringr*'s 49".

[^footstringx]: See also the new
    [*stringx*](https://stringx.gagolewski.com) package
    which supplies a set of portable and efficient
    replacements for and enhancements of the base R functions
    (based on *stringi*).





Naming
------

Function and argument names use a combination of lowercase letters and
underscores (and no dots). To avoid namespace clashes, all function
names feature the "`stri_`" prefix. Names are quite self-explanatory,
e.g., `stri_locate_first_regex` and `stri_locate_all_fixed` find,
respectively, the first match to a regular expression and all
occurrences of a substring as-is.

Vectorisation
-------------

Individual character (or code point) strings can be entered using double
quotes or apostrophes:



```r
"spam"  # or 'spam'
## [1] "spam"
```

However, as the R language does not feature any classical scalar types,
strings are wrapped around atomic vectors of type "`character`":



```r
typeof("spam")  # object type; see also is.character() and is.vector()
## [1] "character"
length("spam")  # how many strings are in this vector?
## [1] 1
```

Hence, we will be using the terms "string" and "character vector of
length 1" interchangeably.

Not having a separate scalar type is very convenient; the so-called
*vectorisation* strategy encourages writing code that processes whole
collections of objects, all at once, regardless of their size.

For instance, given the following character vector:



```r
pythons <- c("Graham Chapman", "John Cleese", "Terry Gilliam",
  "Eric Idle", "Terry Jones", "Michael Palin")
```

we can separate the first and the last names from each other (assuming
for simplicity that no middle names are given), using just a single
function call:



```r
(pythons <- stri_split_fixed(pythons, " ", simplify=TRUE))
##      [,1]      [,2]     
## [1,] "Graham"  "Chapman"
## [2,] "John"    "Cleese" 
## [3,] "Terry"   "Gilliam"
## [4,] "Eric"    "Idle"   
## [5,] "Terry"   "Jones"  
## [6,] "Michael" "Palin"
```

Due to vectorisation, we can generally avoid using the `for`- and
`while`-loops ("for each string in a vector..."). This can make the code
much more readable, maintainable, and faster to execute.


Acting Elementwise with Recycling
---------------------------------

Binary and higher-arity operations in R are oftentimes vectorised with
respect to all arguments (or at least to the crucial, non-optional
ones). As a prototype, let's consider the binary arithmetic, logical,
or comparison operators (and, to some extent, `paste()`, `strrep()`, and
more generally `mapply()`), for example the multiplication:



```r
c(10, -1) * c(1, 2, 3, 4)  # == c(10, -1, 10, -1) * c(1, 2, 3, 4)
## [1] 10 -2 30 -4
```

Calling "`x * y`" multiplies the corresponding components of the two
vectors elementwisely. As one operand happens to be shorter than
the other, the former is recycled as many times as necessary to match the
length of the latter (there would be a warning if partial recycling
occurred). Also, acting on a zero-length input always yields an empty
vector.

All functions in *stringi* follow this convention (with some obvious
exceptions, such as the `collapse` argument in `stri_join()`, `locale`
in `stri_datetime_parse()`, etc.). In particular, all string search
functions are vectorised with respect to both the `haystack` and the
`needle` arguments (and, e.g., the replacement string, if applicable).

Some users, unaware of this rule, might find this behaviour unintuitive
at the beginning and thus miss out on how powerful it is. Therefore, let's
enumerate the most noteworthy scenarios that are possible thanks to
the arguments' recycling, using the call to
`stri_count_fixed(haystack, needle)` (which looks for a needle in a
haystack) as an illustration:

* many strings -- one pattern:

    

    ```r
    stri_count_fixed(c("abcd", "abcabc", "abdc", "dab", NA), "abc")
    ```
    
    ```
    ## [1]  1  2  0  0 NA
    ```

    (there is 1 occurrence of `"abc"` in `"abcd"`,
    2 in `"abcabc"`, and so forth);

* one string -- many patterns:

    

    ```r
    stri_count_fixed("abcdeabc", c("def", "bc", "abc", NA))
    ```
    
    ```
    ## [1]  0  2  2 NA
    ```

    (`"def"` does not occur in `"abcdeabc"`,
    `"bc"` can be found therein twice, etc.);

* each string -- its own corresponding pattern:

    

    ```r
    stri_count_fixed(c("abca", "def", "ghi"), c("a", "z", "h"))
    ```
    
    ```
    ## [1] 2 0 1
    ```

    (there are two `"a"`s in `"abca"`,
    no `"z"` in `"def"`, and one `"h"` in `"ghi"`);

* each row in a matrix -- its own corresponding pattern:

    

    ```r
    (haystack <- matrix(  # example input
    do.call(stri_join,
        expand.grid(
        c("a", "b", "c"), c("a", "b", "c"), c("a", "b", "c")
        )), nrow=3))
    ```
    
    ```
    ##      [,1]  [,2]  [,3]  [,4]  [,5]  [,6]  [,7]  [,8]  [,9] 
    ## [1,] "aaa" "aba" "aca" "aab" "abb" "acb" "aac" "abc" "acc"
    ## [2,] "baa" "bba" "bca" "bab" "bbb" "bcb" "bac" "bbc" "bcc"
    ## [3,] "caa" "cba" "cca" "cab" "cbb" "ccb" "cac" "cbc" "ccc"
    ```
    

    ```r
    needle <- c("a", "b", "c")
    matrix(stri_count_fixed(haystack, needle),  # call to stringi
    nrow=3, dimnames=list(needle, NULL))
    ```
    
    ```
    ##   [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9]
    ## a    3    2    2    2    1    1    2    1    1
    ## b    1    2    1    2    3    2    1    2    1
    ## c    1    1    2    1    1    2    2    2    3
    ```

    (this looks for `"a"` in the 1st row of
    `haystack`, `"b"` in the 2nd row, and `"c"` in the 3rd;
    in particular, there are 3 `"a"`s in `"aaa"`, 2 in `"aba"`,
    and 1 `"b"` in `"baa"`;
    this is possible because matrices are
    represented as "flat" vectors of length `nrow*ncol`,
    whose elements are read in a column-major (Fortran) order;
    therefore, here,
    the pattern `"a"` is being sought in the 1st, 4th, 7th, ...
    string in `haystack`, i.e., `"aaa"`, `"aba"`, `"aca"`, ...;
    pattern `"b"` in the 2nd, 5th, 8th, ... string;
    and `"c"` in the 3rd, 6th, 9th, ... one);

    On a side note, to match different patterns
    with respect to each column, we can (amongst others)
    apply matrix transpose twice (`t(stri_count_fixed(t(haystack), needle))`).

* all strings -- all patterns:

    

    ```r
    haystack <- c("aaa", "bbb", "ccc", "abc", "cba", "aab", "bab", "acc")
    needle <- c("a", "b", "c")
    structure(
    outer(haystack, needle, stri_count_fixed),
    dimnames=list(haystack, needle))  # add row and column names
    ```
    
    ```
    ##     a b c
    ## aaa 3 0 0
    ## bbb 0 3 0
    ## ccc 0 0 3
    ## abc 1 1 1
    ## cba 1 1 1
    ## aab 2 1 0
    ## bab 1 2 0
    ## acc 1 0 2
    ```

    (which computes the counts over the Cartesian product
    of the two arguments)

    This is equivalent to:

    

    ```r
    matrix(
    stri_count_fixed(rep(haystack, each=length(needle)), needle),
    byrow=TRUE, ncol=length(needle), dimnames=list(haystack, needle))
    ```
    
    ```
    ##     a b c
    ## aaa 3 0 0
    ## bbb 0 3 0
    ## ccc 0 0 3
    ## abc 1 1 1
    ## cba 1 1 1
    ## aab 2 1 0
    ## bab 1 2 0
    ## acc 1 0 2
    ```





Missing Values
--------------

Some base R string processing functions, e.g., `paste()`, treat missing
values as literal `"NA"` strings. *stringi*, however, *does* enforce the
consistent propagation of missing values (like arithmetic operations):



```r
paste(c(NA_character_, "b", "c"), "x", 1:2)  # base R
## [1] "NA x 1" "b x 2"  "c x 1"
stri_join(c(NA_character_, "b", "c"), "x", 1:2)  # stringi
## Warning in stri_join(c(NA_character_, "b", "c"), "x", 1:2): longer object
##     length is not a multiple of shorter object length
## [1] NA    "bx2" "cx1"
```

For dealing with missing values, we may rely on the convenience
functions such as `stri_omit_na()` or `stri_replace_na()`.

Data Flow
---------

All vector-like arguments (including factors and objects) in *stringi*
are treated in the same manner. For example, if a function expects a
character vector on input and an object of another type is provided,
`as.character()` is called first (we see that in the example above,
"`1:2`" is treated as `c("1", "2")`).

Following {cite}`Wickham2010:stringr`, *stringi* makes sure the output data
types are consistent and that different functions are interoperable.
This makes operation chaining easier and less error-prone.

For example, `stri_extract_first_regex()` finds the first occurrence of
a pattern in each string. Therefore, the output is a character of the
same length as the input (with the recycling rule in place if necessary).



```r
haystack <- c("bacon", "spam", "jam, spam, bacon, and spam")
stri_extract_first_regex(haystack, "\\b\\w{1,4}\\b")
## [1] NA     "spam" "jam"
```

Note that a no-match (here, we have been looking for words of at most 4
characters) is marked with a missing string. This makes the output
vector size consistent with the length of the inputs.

On the other hand, `stri_extract_all_regex()` identifies all occurrences
of a pattern, whose counts may differ from input to input, therefore it
yields a list of character vectors.



```r
stri_extract_all_regex(haystack, "\\b\\w{1,4}\\b", omit_no_match=TRUE)
## [[1]]
## character(0)
## 
## [[2]]
## [1] "spam"
## 
## [[3]]
## [1] "jam"  "spam" "and"  "spam"
```

If the 3rd argument were not specified, a no-match would be represented
by a missing value (for consistency with the previous function).

Also, care is taken so that the "data" or "`x`" argument is most often
listed as the first one (e.g., in base R we have
`grepl(needle, haystack)` vs `stri_detect(haystack, needle)` here). This
makes the functions more intuitive to use, but also more forward pipe
operator-friendly (either when using "`|>`" introduced in R 4.1 or
"`%>%`" from [*magrittr*](https://magrittr.tidyverse.org/)).

Furthermore, for increased convenience, some functions have been added
despite the fact that they can  trivially be reduced to a series of other
calls. In particular, writing:



```r
stri_sub_all(haystack,
  stri_locate_all_regex(haystack, "\\b\\w{1,4}\\b", omit_no_match=TRUE))
```

yields the same result as in the previous example, but refers to
`haystack` twice.


Further Deviations from Base R
------------------------------

*stringi* can be used as a replacement for the existing string processing
functions. Also, it offers many facilities not available in base R.
Except for being fully vectorised with respect to all crucial arguments,
propagating missing values and empty vectors consistently, and following
coherent naming conventions, our functions deviate from their classic
counterparts even further.


**Following Unicode Standards.**
Thanks to the comprehensive coverage of the most important services
provided by *ICU*, its users gain access to collation, pattern
searching, normalisation, transliteration, etc., that follow the current
Unicode standards for text processing in any locale. Due to this, as we
state in {ref}`Sec:encoding`, all inputs are converted to Unicode.
Furthermore, all outputs are always in UTF-8.


**Portability Issues in Base R.**
As mentioned in the introduction, base R string operations have
traditionally been limited in scope. There also might be some issues
with regards to their portability, reasons for which may be plentiful.
For instance, varied versions of the [*PCRE*](https://www.pcre.org/)
(8.x or 10.x) pattern
matching libraries may be linked to during the compilation of R. On
Windows, there is a custom implementation of *iconv* that has a set of
character encoding IDs not fully compatible with that on GNU/Linux: to
select the Polish locale, we are required to pass `"Polish_Poland"` to
`Sys.setlocale()` on Windows whereas `"pl_PL"` on Linux. Interestingly,
R can be built against the system *ICU* so that it uses its Collator for
comparing strings (e.g., using the "`<=`" operator). However, this is
only optional and does not provide access to any other Unicode services.

For example, let us consider the matching of "all letters" by means of
the built-in `gregexpr()` function and the [*TRE*](https://github.com/laurikari/tre/)
(`perl=FALSE`) and
*PCRE* (`perl=TRUE`) libraries using a POSIX-like and Unicode-style
character set (see {ref}`Sec:regex` for more details):


```r
x <- "AEZaezĄĘŻąęż"  # "AEZaez\u0104\u0118\u017b\u0105\u0119\u017c"
stri_sub(x, gregexpr("[[:alpha:]]", x, perl=FALSE)[[1]], length=1)
stri_sub(x, gregexpr("[[:alpha:]]", x, perl=TRUE)[[1]],  length=1)
stri_sub(x, gregexpr("\\p{L}", x, perl=TRUE)[[1]],       length=1)
```

On Ubuntu Linux 20.04 (UTF-8 locale), the respective outputs are:


```r
## [1] "A" "E" "Z" "a" "e" "z" "Ą" "Ę" "Ż" "ą" "ę" "ż"
## [1] "A" "E" "Z" "a" "e" "z"
## [1] "A" "E" "Z" "a" "e" "z" "Ą" "Ę" "Ż" "ą" "ę" "ż"
```

On Windows, when `x` is marked as UTF-8
(see {ref}`Sec:encoding`), the current author obtained:


```r
## [1] "A" "E" "Z" "a" "e" "z"
## [1] "A" "E" "Z" "a" "e" "z"
## [1] "A" "E" "Z" "a" "e" "z" "Ą" "Ę" "Ż" "ą" "ę" "ż"
```

And again on Windows using the Polish locale but `x` marked as
natively-encoded (CP-1250 in this case):


```r
## [1] "A" "E" "Z" "a" "e" "z" "Ę" "ę"
## [1] "A" "E" "Z" "a" "e" "z" "Ą" "Ę" "Ż" "ą" "ę" "ż"
## [1] "A" "E" "Z" "a" "e" "z" "Ę" "ę"
```

As we mention in {ref}`Sec:collator`, when *stringi* links to
*ICU* built from sources
(`install.packages("stringi", configure.args="--disable-pkg-config")`),
we are always guaranteed to get the same results on every platform.


**High Performance of *stringi*.**
Because of the aforementioned reasons, functions in *stringi* do not
refer to their base R counterparts. The operations that do not rely on
*ICU* services have been rewritten from scratch with speed and
portability in mind. For example, here are some timings of string
concatenation:



```r
x <- stri_rand_strings(length(LETTERS) * 1000, 1000)
microbenchmark::microbenchmark(
  join2=stri_join(LETTERS, x, sep="", collapse=", "),
  join3=stri_join(x, LETTERS, x, sep="", collapse=", "),
  r_paste2=paste(LETTERS, x, sep="", collapse=", "),
  r_paste3=paste(x, LETTERS, x, sep="", collapse=", ")
)
## Unit: milliseconds
##      expr     min      lq    mean  median      uq    max neval
##     join2  39.153  40.157  54.064  41.688  52.681 109.94   100
##     join3  84.818  88.149  92.345  90.330  94.587 138.78   100
##  r_paste2  83.995  87.088 104.517  90.834 105.171 183.10   100
##  r_paste3 176.490 182.296 228.608 243.960 258.631 343.04   100
```

Another example -- timings of fixed pattern searching:



```r
x <- stri_rand_strings(100, 100000, "[actg]")
y <- "acca"
microbenchmark::microbenchmark(
  fixed=stri_locate_all_fixed(x, y),
  regex=stri_locate_all_regex(x, y),
  coll=stri_locate_all_coll(x, y),
  r_tre=gregexpr(y, x),
  r_pcre=gregexpr(y, x, perl=TRUE),
  r_fixed=gregexpr(y, x, fixed=TRUE)
)
## Unit: milliseconds
##     expr      min       lq     mean  median       uq      max neval
##    fixed   4.9861   5.0658   5.1497   5.088   5.1666   5.4805   100
##    regex  98.5586  99.1162  99.5049  99.342  99.6874 109.1632   100
##     coll 261.6454 262.9504 263.4606 263.463 263.9660 265.3722   100
##    r_tre 117.0878 117.4128 117.8794 117.561 117.7429 127.0573   100
##   r_pcre  70.8115  71.2062  71.8814  71.410  71.5560  89.8478   100
##  r_fixed  23.7709  23.9305  24.0572  24.061  24.1899  24.3638   100
```


**Different Default Arguments and Greater Configurability.**
Some functions in *stringi* have different, more natural default
arguments, e.g., `paste()` has `sep=" "` but `stri_join()` has `sep=""`.
Also, as there is no one-fits-all solution to all problems, many
arguments have been introduced for more detailed tuning.



**Preserving Attributes.**
Generally, *stringi* preserves no object attributes whatsoever, but a
user can make sure themself that this is the case, e.g., by
calling "`x[] <- stri_...(x, ...)`" or
"\``attributes<-`\``(stri_...(x, ...), attributes(x))`".
