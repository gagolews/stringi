ICU Unicode text transforms in the R package stringi
====================================================

The [ICU](http://site.icu-project.org/) (International Components for Unicode) library provides very powerful and flexible ways to apply various Unicode text transforms. These include:

* Full (language-specific) case mappings,
* Unicode normalization,
* Text transliteration (e.g. script-to-script conversion).

All of these are available to R programmers via our still maturing [`stringi`](http://stringi.rexamine.com) package.


### Case Mappings ###

Mapping of upper-, lower-, and title-case characters may seem to be a straightforward task, but just a quick glimpse at the latest [Unicode standard](http://www.unicode.org/versions/latest/) (Secs. 3.13, 4.2, and 5.18) will suffice to convince us that case mapping rules are very complex. In one of my [previous posts](http://www.rexamine.com/2014/05/stringi-0-2-3-released/) I've already mentioned that "base R" performs (at least on my machine) only a single-character case conversion:


```r
toupper("groß") # German: -> GROSS
```

```
## [1] "GROß"
```


Notably, the case conversion in R is language-dependent:


```r
toupper("ıi") # Polish locale is default here
```

```
## [1] "II"
```

```r
oldloc <- Sys.getlocale("LC_CTYPE")
Sys.setlocale("LC_CTYPE", "tr_TR.UTF-8")  # Turkish
```

```
## [1] "tr_TR.UTF-8"
```

```r
toupper("ıi") # dotless i and latin i -> latin I and I with dot above (OK)
```

```
## [1] "Iİ"
```

```r
Sys.setlocale("LC_CTYPE", oldloc)
```

```
## [1] "pl_PL.UTF-8"
```


This language-sensitivity is of course desirable when it comes to natural language processing. Unfortunately, a few more examples might be found for which `toupper()` and `tolower()` does not meet the Unicode guidelines. Generally, a proper case map can change the number of code points/units of a string, is language-sensitive and context-sensitive (character mapping may depend on its surrounding characters). Luckily, we have the [case mapping facilities](http://userguide.icu-project.org/transforms/casemappings) implemented in the ICU library, which provides us with all we need:



```r
library(stringi)
stri_trans_toupper("groß", locale = "de_DE") # German
```

```
## [1] "GROSS"
```

```r
stri_trans_totitle("ijsvrij yoghurt", locale = "nl_NL")  # Dutch
```

```
## [1] "IJsvrij Yoghurt"
```

```r
stri_trans_toupper("ıi", locale = "tr_TR")
```

```
## [1] "Iİ"
```

```r
stri_trans_tolower("İI", locale = "tr_TR")
```

```
## [1] "iı"
```


By the way, ICU [doesn't have](http://stackoverflow.com/questions/23174547/) any list of non-capitalized words for language-dependent title casing (e.g. *pining for the fjords* in English is most often mapped to *Pining for the Fjords*), so such tasks must be performed manually.




### Unicode Normalization ###

The following string:


```r
'\u01f1DZ'
```

```
## [1] "ǱDZ"
```


consists of 3 Unicode code points: a Unicode character *LATIN CAPITAL LETTER DZ (U+01F1)* and then Latin letters D and Z. Even though both DZs may look different in your Web browser, the appear as identical (well, almost) in RStudio (at least on my computer). Take a try yourself, that's really interesting.

A tricky question: how many \code{DZ}s are in the above string? 2 or 1? Considering raw code points (in a byte-wise manner) we'd answer 1. But for natural language processing a better answer is probably 2. This is one of a few cases in which the Unicode normalization (see [here](http://en.wikipedia.org/wiki/Unicode_equivalence) and [here](http://www.unicode.org/reports/tr15/) for more information) is of interest.

Without going into much detail let's just say that there are few normalization forms (NFC, NFD, NFKC, NFKD, NFKC_casefold); each one serves for different purposes. Unless you're an author of some string processing package, these won't interest you too much (it's the developer's responsibility to provide an on-the-fly normalization). Anyway, the Unicode normalization may be [performed with ICU](http://userguide.icu-project.org/transforms/normalization):


```r
stri_trans_nfkc('\u01f1DZ')
```

```
## [1] "DZDZ"
```

```r
stri_trans_nfc('a\u0328') # a and ogonek => a with ogonek
```

```
## [1] "ą"
```

```r
stri_trans_nfkc("\ufdfa") # 1 codepoint -> 18 codepoints
```

```
## [1] "صلى الله عليه وسلم"
```


Fortunately, an ordinary user may keep calm: many string processing tasks in `stringi` just take care of a proper transformation automatically. This includes string searching, sorting, and comparing functions:


```r
stri_count_coll('\u01f1DZ', 'DZ', stri_opts_collator(strength=2)) # how many DZs are there?
```

```
## [1] 2
```

```r
'ą' %==% 'a\u0328' # are they canonically equivalent?
```

```
## [1] TRUE
```



### General Text Transforms ###

If you were patient and persistent enough with reading this post and arrived at this very section, here's the frosting on the cake: ICU [general text transforms](http://userguide.icu-project.org/transforms/general).

First of all, general transforms allow us to perform all the above-mentioned operations (however, they are not locale-dependent). For example:


```r
stri_trans_general("ǱDZ", "nfkc")
```

```
## [1] "DZDZ"
```

```r
stri_trans_general("groß", "upper")
```

```
## [1] "GROSS"
```


Here, the 2nd argument of `stri_trans_general` denotes the transformation to apply. The list of available transforms is returned by a call to:


```r
head(stri_trans_list())
```

```
## [1] "ASCII-Latin"       "Accents-Any"       "Amharic-Latin/BGN"
## [4] "Any-Accents"       "Any-Publishing"    "Arabic-Latin"
```


General text transforms can perform:

* Hex and Character Name conversions (e.g. for escaping Unicode code points),
* Script to Script conversion (a.k.a. text transliteration),
* etc.

For more information on text transforms, refer to the [ICU documentation](http://userguide.icu-project.org/transforms/general). I admit that the user's guide is not easy to follow, but it may allow you to do some magic tricks with your text, so it's worth reading.

Notably, text transformations may be composed (so that many operations may be performed one by one in a single call) and we are able to tell ICU to restrict processing only to a fixed set of Unicode code points.

A bunch of examples: firstly, some script-to-script conversions (not to be confused with text translation):


```r
stri_trans_general("stringi", "latin-greek")  # script transliteration
```

```
## [1] "στριγγι"
```

```r
stri_trans_general("Пётр Ильич Чайковский", "cyrillic-latin")eration
```

```
## [1] "Pëtr Ilʹič Čajkovskij"
```

```r
stri_trans_general("Пётр Ильич Чайковский", "cyrillic-latin; nfd; [:nonspacing mark:] remove; nfc")nts
```

```
## [1] "Petr Ilʹic Cajkovskij"
```

```r
stri_trans_general("zażółć gęślą jaźń", "latin-ascii")e diacritic marks
```

```
## [1] "zazolc gesla jazn"
```


What I really love in the first example above is that from *ng* we obtain &gamma;&gamma; (gamma,gamma) and not &nu;&gamma; (nu, gamma). Cute, isn't it?

It's getting hotter with these:


```r
stri_trans_general("w szczebrzeszynie chrząszcz brzmi w trzcinie", "pl-pl_fonipa")
```

```
## [1] "v ʂt͡ʂɛbʐɛʂɨɲɛ xʂɔ̃ʂt͡ʂ bʐmi v tʂt͡ɕiɲɛ"
```

```r
# and now the same in the XSampa ASCII-range representation:
stri_trans_general("w szczebrzeszynie chrząszcz brzmi w trzcinie", "pl-pl_fonipa; ipa-xsampa")
```

```
## [1] "v s`t_s`Ebz`Es`1JE xs`O~s`t_s` bz`mi v ts`t_s\\iJE"
```


We've obtained the phonetic representation of a Polish text (in [IPA](http://en.wikipedia.org/wiki/International_Phonetic_Alphabet)) &ndash; try reading that tongue twister aloud (in case of any problems consult [this Wikipedia article](http://en.wikipedia.org/wiki/Chrz%C4%85szcz)).

We may also escape a selected set of code points (to hex representation as  well as e.g. to XML entities) or even completely remove them:


```r
stri_trans_general("zażółć gęślą jaźń", "[^\\u0000-\\u007f] any-hex")red
```

```
## [1] "za\\u017C\\u00F3\\u0142\\u0107 g\\u0119\\u015Bl\\u0105 ja\\u017A\\u0144"
```

```r
stri_trans_general("zażółć gęślą jaźń", "[^\\u0000-\\u007f] any-hex/xml")
```

```
## [1] "za&#x17C;&#xF3;&#x142;&#x107; g&#x119;&#x15B;l&#x105; ja&#x17A;&#x144;"
```

```r
stri_trans_general("zażółć gęślą jaźń", "[\\p{Z}] remove")
```

```
## [1] "zażółćgęśląjaźń"
```


...and play with code point names:


```r
stri_trans_general("ą1©,", "any-name")
```

```
## [1] "\\N{LATIN SMALL LETTER A WITH OGONEK}\\N{DIGIT ONE}\\N{COPYRIGHT SIGN}\\N{COMMA}"
```

```r
stri_trans_general("\\N{LATIN SMALL LETTER SHARP S}", "name-any")
```

```
## [1] "ß"
```



Last but not least:


```r
stri_trans_general("Let's go -- she said", "any-publishing")
```

```
## [1] "Let’s go — she said"
```


Did you note the differences?

### A Note on BiDi Text (Help Needed) ###

ICU also provides support for processing Bidirectional text (e.g. a text that consists of a mixture of Arabic/Hebrew and English). We would be very glad to implement such facilities, but, as we (developers of `stringi`) come from a "Latin" environment, we don't have good guidelines on how the BiDi/RTL (right-to-left) text processing functions should behave. We don't even know whether such a text displays properly in RStudio or R GUI on Windows. Therefore, we'll warmly welcome any volunteers that would like to help us with the mentioned issues (developers or just testers).


For **bug reports and feature requests** concerning the `stringi` package visit our [GitHub profile](https://github.com/Rexamine/stringi/) or contact me via email.


So...


```r
stri_trans_general("¡muy bueno mi amigo, hasta la vista! :-)", "es-es_FONIPA")
```

```
## [1] "¡muiβwenomiamiɣo,.astalaβista!:)"
```



--
[Marek Gagolewski](http://gagolewski.rexamine.com)
