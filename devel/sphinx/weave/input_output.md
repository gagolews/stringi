Input and Output
================



> This tutorial is based on the [paper on *stringi*](https://stringi.gagolewski.com/_static/vignette/stringi.pdf) that will appear in the *Journal of Statistical Software*.


This section deals with some more advanced topics related to the
operability of text processing applications between different platforms.
In particular, we discuss how to assure that data read from various
input connections are interpreted in the correct manner.

Dealing with Unicode code points {#Sec:codepoints}
--------------------------------

The Unicode Standard (as well as the Universal Coded Character Set,
i.e., ISO/IEC 10646) currently defines over 140,000 abstract characters
together with their corresponding code points -- integers between 0 and
1,114,111 (or 0000${}_{16}$ and 10FFFF${}_{16}$ in hexadecimal notation,
see <https://www.unicode.org/charts/>). In particular, here is the
number of the code points in some popular categories (compare
Section [6.1](#Sec:RegexIndividualChars){reference-type="ref"
reference="Sec:RegexIndividualChars"}), such as letters, numbers, and
the like.


```r
z <- c("\\p{L}", "\\p{Ll}", "\\p{Lu}", "\\p{N}", "\\p{P}", "\\p{S}",
  "\\w", "\\d", "\\s")
structure(stri_count_regex(stri_enc_fromutf32(
  setdiff(1:0x10ffff, c(0xd800:0xf8ff))), z), names=z)
##  \\p{L} \\p{Ll} \\p{Lu}  \\p{N}  \\p{P}  \\p{S}     \\w     \\d     \\s 
##  131241    2155    1791    1781     798    7564  134564     650      25
```

Yet, most of the code points are still unallocated. The Unicode standard
is occasionally updated, e.g., the most recent versions were
supplemented with over 1,000 emojis.

The first 255 code points are identical to the ones defined by ISO/IEC
8859-1 (ISO Latin-1; "Western European"), which itself extends US-ASCII
(codes $\le 127=\text{7F}{}_{16}$). For instance, the code point that we
are used to denoting as U+007A (the "U+" prefix is followed by a
sequence of hexadecimal digits; 7A${}_{16}$ corresponds to decimal 122)
encodes the lower case letter "z". To input such a code point in R, we
write:


```r
"\u007A"  # or "\U0000007A"
## [1] "z"
```

For communicating with *ICU* and other libraries, we may need to escape
a given string, for example, as follows (recall that to input a
backslash in R, we must escape it with another backslash).


```r
x <- "zß你好"
stri_escape_unicode(x)
## [1] "z\\u00df\\u4f60\\u597d"
```

It is worth noting that despite the fact that some output devices might
be unable to display certain code points correctly (due to, e.g.,
missing fonts), the correctness of their processing with *stringi* is
still guaranteed by *ICU*.

Character encodings {#Sec:encoding}
-------------------

When storing strings in RAM or on the disk, we need to decide upon the
actual way of representing the code points as sequences of bytes. The
two most popular encodings in the Unicode family are UTF-8 and UTF-16:


```r
x <- "abz0ąß你好!"
stri_encode(x, to="UTF-8", to_raw=TRUE)[[1]]
##  [1] 61 62 7a 30 c4 85 c3 9f e4 bd a0 e5 a5 bd 21
stri_encode(x, to="UTF-16LE", to_raw=TRUE)[[1]]  # little-endian
##  [1] 61 00 62 00 7a 00 30 00 05 01 df 00 60 4f 7d 59 21 00
```

R's current platform-default encoding, which we shall refer to as the
native encoding, is defined via the `LC_CTYPE` locale category in
`Sys.getlocale()`. This is the representation assumed, e.g., when
reading data from the standard input or from files (e.g., when `scan()`
is called). For instance, Central European versions of Windows will
assume the "`windows-1250`" code page. MacOS as well as most Linux boxes
work with UTF-8 by default[^17]

All strings in R have an associated encoding mark which can be read by
calling `Encoding()` or, more conveniently, `stri_enc_mark()`. Most
importantly, strings in ASCII, ISO-8859-1 ("`latin1`"), UTF-8, and the
native encoding can coexist. Whenever a non-Unicode string is passed to
a function in *stringi*, it is silently converted to UTF-8 or UTF-16,
depending on the requested operation (some *ICU* services are only
available for UTF-16 data). Over the years, this has proven a robust,
efficient, and maximally portable design choice -- Unicode can be
thought of as a superset of every other encoding. Moreover, in order to
guarantee the correctness and high performance of the string processing
pipelines, *stringi* always[^18] outputs UTF-8 data.

[^17]: It is expected that future R releases will support UTF-8 natively
    thanks to the Universal C Runtime (UCRT) that is available for
    Windows 10.

[^18]: With a few obvious exceptions, such as `stri_encode()`.



Reading and writing text files and converting between encodings {#Sec:read_lines}
---------------------------------------------------------------

According to a report by W3Techs[^19], as of 2021--09--28, 97.3% of
websites use UTF-8. Nevertheless, other encodings can still be
encountered.

[^19]: See
    <https://w3techs.com/technologies/cross/character_encoding/ranking>.

#### Reading and writing text files.

If we know the encoding of a text file in advance, `stri_read_lines()`
can be used to read the data in a manner similar to the built-in
`readLines()` function (but with a much easier access to encoding
conversion):

For instance, below we read a text file encoded in ISO-8859-1:


```r
x <- stri_read_lines("ES_latin1.txt", encoding="ISO-8859-1")
head(x, 4)  # x is in UTF-8 now
## [1] "CANTO DE CALÍOPE - Miguel de Cervantes"
## [2] ""                                      
## [3] "Al dulce son de mi templada lira,"     
## [4] "prestad, pastores, el oído atento:"
```

We can call `stri_write_lines()` to write the contents of a character
vector to a file (each string will constitute a separate text line),
with any output encoding.

#### Detecting encoding.

However, if a file's encoding is not known in advance, there are a
certain functions that can aid in encoding detection. First, we can read
the resource in form of a raw-type vector:


```r
x <- stri_read_raw("ES_latin1.txt")
head(x, 24)  # vector of type raw
##  [1] 43 41 4e 54 4f 20 44 45 20 43 41 4c cd 4f 50 45 20 2d 20 4d 69 67 75 65
```

Then, to guess the encoding, we can call, e.g.:


```r
stri_enc_isascii(x)
## [1] FALSE
stri_enc_isutf8(x)   # false positives are possible
## [1] FALSE
```

Alternatively, we can use:


```r
stri_enc_detect(x)  # based on heuristics
## [[1]]
##     Encoding Language Confidence
## 1 ISO-8859-1       es       0.81
## 2 ISO-8859-2       ro       0.36
## 3 ISO-8859-9       tr       0.20
## 4   UTF-16BE                0.10
## 5   UTF-16LE                0.10
```

Nevertheless, encoding detection is an operation that relies on
heuristics, therefore there is a chance that the output might be
imprecise or even misleading.

#### Converting encodings.

Knowing the desired source and destination encoding precisely,
`stri_encode()` can be called to perform the conversion. Contrary to the
built-in `iconv()`, which relies on different underlying libraries, the
current function is portable across operating systems.


```r
y <- stri_encode(x, from="ISO-8859-1", to="UTF-8")
```

`stri_enc_list()` provides a list of supported encodings and their
aliases in many different forms. Encoding specifiers are normalised
automatically, e.g., `"utf8"` is a synonym for `"UTF-8"`.

Splitting the output into text lines gives:


```r
tail(stri_split_lines1(y), 4)  # spoiler alert!
## [1] "A Homero iguala si a escrebir intenta," 
## [2] "y a tanto llega de su pluma el vuelo,"  
## [3] "cuanto es verdad que a todos es notorio"
## [4] "el alto ingenio de don DIEGO OSORIO."
```

Normalising strings {#Sec:normalisation}
-------------------

In Section [7.2](#Sec:Equivalence){reference-type="ref"
reference="Sec:Equivalence"} we have provided some examples of
canonically equivalent strings whose code point representation was
different. Unicode normalisation forms C (Canonical composition, NFC)
and D (Canonical decomposition, NFD) can be applied so that they will
compare equal using bytewise matching {cite}`usa15:normalization`.


```r
x <- "a\u0328 ą"   # a, combining ogonek, space, a with ogonek
stri_enc_toutf32(  # code points as decimals
  c(x, stri_trans_nfc(x), stri_trans_nfd(x)))
## [[1]]
## [1]  97 808  32 261
## 
## [[2]]
## [1] 261  32 261
## 
## [[3]]
## [1]  97 808  32  97 808
```

Above we see some example code points before, after NFC, and after NFD
normalisation, respectively.

It might be a good idea to always normalise all the strings read from
external sources (files, URLs) with NFC.

Compatibility composition and decomposition normalisation forms (NFKC
and NFKD, respectively) are also available if the removal of the
formatting distinctions (font variants, subscripts, superscripts, etc.)
is desired. For example:


```r
stri_trans_nfkd("r²︷")
## [1] "r2{"
```

Such text might be much easier to process or analyse statistically.
