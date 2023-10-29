

(Sec:other)=
Other Operations
================


> This tutorial is based on the [paper on *stringi*](https://dx.doi.org/10.18637/jss.v103.i02) that was published in the *Journal of Statistical Software*; see {cite}`stringi`. To learn more about R, check out Marek's open-access (free!) textbook [*Deep R Programming*](https://deepr.gagolewski.com/) {cite}`deepr`.


In the sequel, we cover the functions that deal with text boundary
detection, random string generation, date/time formatting and parsing,
amongst others.



(Sec:BoundaryAnalysis)=
Analysing Text Boundaries
-------------------------

Text boundary analysis aims at locating linguistic delimiters for the
purpose of splitting text into lines, word-wrapping, counting characters
or words, locating particular text units (e.g., the 3rd sentence), etc.

Generally, text boundary analysis is a locale-sensitive operation
(see the [Unicode Standard Annex \#29: Unicode Text Segmentation](https://unicode.org/reports/tr29/)). For example, in Japanese and Chinese, spaces are
not used for the separation of words -- a line break can occur even in the
middle of a word. Nevertheless, these languages have punctuation and
diacritical marks that cannot start or end a line, so this must also be
considered.

The *ICU* Break Iterator
(see the [*ICU* User Guide on Boundary Analysis](https://unicode-org.github.io/icu/userguide/boundaryanalysis/))
comes in four flavours (see the `type`
option in `stri_opts_brkiter()`): `character`, `work`, `line_break`, and
`sentence`.

We have access to functions such as `stri_count_boundaries()`,
`stri_split_boundaries()`, `stri_extract__boundaries()`, and
`stri_locate__boundaries()`, as well as their specialised versions:
`stri_count_words()`, `stri_extract__words()`, and `stri_split_lines()`,
amongst others. For example:



```r
x <- "The\u00a0above-mentioned    features are useful. " %s+%
  "My hovercraft is full of eels, eggs, and spam."
```

Number of sentences:



```r
stri_count_boundaries(x, type="sentence")
## [1] 2
```

The list of all the words:



```r
stri_extract_all_words(x)
## [[1]]
##  [1] "The"        "above"      "mentioned"  "features"   "are"       
##  [6] "useful"     "My"         "hovercraft" "is"         "full"      
## [11] "of"         "eels"       "eggs"       "and"        "spam"
```

Trimming, Padding, and Other Formatting
---------------------------------------

The following functions can be used for pretty-printing character
strings or text on the console, dynamically generating reports (e.g.,
with `Sweave()` or [*knitr*](https://yihui.org/knitr/)
{cite}`knitr`), or creating text files
(e.g., with `stri_write_lines()`; see {ref}`Sec:read_lines`).

### Padding

`stri_pad()` pads strings with some character so that they reach the
desired widths (as in `stri_width()`). This can be used to centre,
left-, or right-align a message when printed with, e.g., `cat()`.



```r
cat(stri_pad("SPAMITY SPAM", width=77, side="both", pad="."))
## ................................SPAMITY SPAM.................................
```

### Trimming

A dual operation is that of trimming from the left or right side of
strings:



```r
x <- "      spam, eggs, and lovely spam.\n"
stri_trim(x)  # side="both"
## [1] "spam, eggs, and lovely spam."
```

### Word Wrapping

The `stri_wrap()` function splits each (possibly long) string in a
character vector into chunks of at most a given width. By default, the
dynamic word wrap algorithm {cite}`Knuth:wrap` that minimises the raggedness
of the formatted text is used. However, there's also an option
(`cost_exponent=0`) to use the greedy alignment, for compatibility with
the built-in `strwrap()`.



```r
x <- stri_rand_lipsum(1)  # random text paragraph
cat(stri_wrap(x, width=74, indent=8, exdent=4, prefix="> "), sep="\n")
## >         Lorem ipsum dolor sit amet, quis donec pretium auctor, quis id.
## >     Mauris rhoncus donec amet egestas sagittis ipsum per. Sed, sociis
## >     amet. Aliquam fusce dictumst sed vehicula ultrices arcu. Eros,
## >     netus et. Amet amet mi vestibulum vitae dapibus ut felis. Magnis
## >     in vestibulum egestas massa curabitur a ut, eget in in facilisis.
## >     Etiam odio fermentum sit ante ridiculus sit elit. Sapien torquent
## >     fermentum tortor gravida ornare sapien consequat et sem turpis. Hac
## >     vel lacus habitasse et id non. Metus habitasse sed lacinia nibh ex
## >     metus. Amet nam vestibulum ornare tincidunt massa sed ullamcorper.
```

### Applying String Templates

`stri_sprintf()` is a Unicode-aware rewrite of the built-in `sprintf()`
function. In particular, it enables formatting and padding based on
character width, not just the number of code points. The function is
also available as a binary operator `%s$%`, which is similar to Python's
`%` overloaded for objects of type `str`.



```r
cat(stri_sprintf("[%6s]", c("abcd", "\u200b\u200b\u200bąß²€")), sep="\n")
## [  abcd]
## [  ​​​ąß²€]
```

The above guarantees that the two output strings are of at least width
of 6 (plus the square brackets).



```r
"value='%.4f'" %s$% pi  # equivalently: "value='%.4f'" %s$% list(pi)
## [1] "value='3.1416'"
"%s='%.*3$f'" %s$% list("pi", pi, 1:4)
## [1] "pi='3.1'"    "pi='3.14'"   "pi='3.142'"  "pi='3.1416'"
```

Generating Random Strings
-------------------------

Apart from `stri_rand_lipsum()`, which produces random-ish text
paragraphs ("placeholders" for real text), we have access to a function
that generates sequences of characters uniformly sampled (with
replacement) from a given set.

For example, here are 5 random ACTG strings of lengths from 2 to 6:



```r
stri_rand_strings(5, 2:6, "[ACTG]")
## [1] "CT"     "CTT"    "AGTG"   "CTCGG"  "ATAACT"
```

Moreover:



```r
stri_rand_strings(1, 8, "[\\p{script=Katakana}&\\p{L}]")
## [1] "ﾐｮㇿ𛅧ｧｱヾㇷ"
```

See {ref}`Sec:RegexIndividualChars` and
`help("stringi-search-charclass")` for different ways to specify
character sets.

Transliterating
---------------

Transliteration, in its broad sense, deals with the substitution of
characters or their groups for different ones, according to some
well-defined, possibly context-aware, rules. It may be utile, amongst
others, when "normalising" pieces of strings or identifiers so that
they can be more easily compared.

### Case Mapping

Mapping to upper, lower, or title case is a language- and
context-sensitive operation that can change the total number of code
points in a string.



```r
stri_trans_toupper("groß")
## [1] "GROSS"
stri_trans_tolower("Iİ", locale="tr_TR")               # Turkish
## [1] "ıi"
stri_trans_totitle("ijsvrij yoghurt", locale="nl_NL")  # Dutch
## [1] "IJsvrij Yoghurt"
```

### Mapping Between Specific Characters

When a fast 1-to-1 code point translation is required, we can call:



```r
stri_trans_char("GATAAATCTGGTCTTATTTCC", "ACGT", "tgca")
## [1] "ctatttagaccagaataaagg"
```

Here, "`A`", "`C`", "`G`", and "`T`" is replaced with "`t`", "`g`",
"`c`", and "`a`", respectively.

### General Transforms

`stri_trans_general()` gives access to a wide range of text
transforms defined by *ICU*, whose catalogue can be browsed by calling
`stri_trans_list()`.



```r
sample(stri_trans_list(), 9)  # a few random entries
## [1] "Any-und_FONIPA" "Any-FCD"        "Deva-Guru"      "yo-yo_BJ"      
## [5] "Taml-Orya"      "Tamil-Arabic"   "hy-ar"          "de-ASCII"      
## [9] "Any-Kana"
```

In the example below, we apply a transliteration chain: we first convert
to upper case, and then convert characters in the Latin script to
ASCII.



```r
stri_trans_general("groß© żółć La Niña köszönöm", "upper; latin-ascii")
## [1] "GROSS(C) ZOLC LA NINA KOSZONOM"
```

Custom rule-based transliteration is also supported
(see the [*ICU* User Guide on General Transforms](https://unicode-org.github.io/icu/userguide/transforms/general/)). It can be
used, for instance, to generate different romanisations of non-Latin
alphabets.




(Sec:datetime)=
Parsing and Formatting Date and Time
------------------------------------

In base R, dealing with temporal data in regional settings other than
the current locale is somewhat difficult. For instance, many will find
the task of parsing the following Polish date problematic:



```r
x <- "28 września 2021 r., godz. 17:17:32"
```

*stringi* connects to the *ICU* date and time services so that this
becomes an easy exercise:



```r
stri_datetime_parse(x, "dd MMMM yyyy 'r., godz.' HH:mm:ss",
  locale="pl_PL", tz="Europe/Warsaw")
## [1] "2021-09-28 17:17:32 CEST"
```

This function returns an object of class `POSIXct`, for compatibility
with base R. Note, however, that *ICU* uses its own format patterns
(see the [*ICU* User Guide on Formatting Dates and Times](https://unicode-org.github.io/icu/userguide/format_parse/datetime/)).
For convenience, `strftime()`- and `strptime()`-like
templates can be converted with `stri_datetime_fstr()`:



```r
stri_datetime_parse(x,
  stri_datetime_fstr("%d %B %Y r., godz. %H:%M:%S"),
  locale="pl_PL", tz="Europe/Warsaw")
## [1] "2021-09-28 17:17:32 CEST"
```


Relative dates are also supported:



```r
stri_datetime_format(
  stri_datetime_add(stri_datetime_now(), 1, "day"), # add 1 day to 'now'
  "datetime_relative_long",              # full format, relative to 'now'
  locale="en_NZ", tz="NZ")
## [1] "tomorrow at 5:14:20 pm NZDT"
```

For example, here's how we can access different calendars:



```r
stri_datetime_format(
  stri_datetime_create(2020, 1:12, 1),
  "date_long",
  locale="@calendar=hebrew")
##  [1] "4 Tevet 5780"    "6 Shevat 5780"   "5 Adar 5780"     "7 Nisan 5780"   
##  [5] "7 Iyar 5780"     "9 Sivan 5780"    "9 Tamuz 5780"    "11 Av 5780"     
##  [9] "12 Elul 5780"    "13 Tishri 5781"  "14 Heshvan 5781" "15 Kislev 5781"
stri_datetime_format(
  stri_datetime_create(2020, c(2, 8), c(4, 7)),
  "date_full",
  locale="ja_JP@calendar=japanese")
## [1] "令和2年2月4日火曜日" "令和2年8月7日金曜日"
```

We have selected the Hebrew calendar within the English locale and
the Japanese calendar in the Japanese locale.
