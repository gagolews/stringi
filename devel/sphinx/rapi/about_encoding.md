# about\_encoding: Character Encodings and <span class="pkg">stringi</span>

## Description

This manual page explains how <span class="pkg">stringi</span> deals with character strings in various encodings.

In particular we should note that:

-   <span style="font-family: Courier New, Courier; color: #666666;">**R**</span> lets strings in ASCII, UTF-8, and your platform\'s native encoding coexist. A character vector printed on the console by calling [`print`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/print.html) or [`cat`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/cat.html) is silently re-encoded to the native encoding.

-   Functions in <span class="pkg">stringi</span> process each string internally in Unicode, the most universal character encoding ever. Even if a string is given in the native encoding, i.e., your platform\'s default one, it will be converted to Unicode (precisely: UTF-8 or UTF-16).

-   Most <span class="pkg">stringi</span> functions always return UTF-8 encoded strings, regardless of the input encoding. What is more, the functions have been optimized for UTF-8/ASCII input (they have competitive, if not better performance, especially when performing more complex operations like string comparison, sorting, and even concatenation). Thus, it is best to rely on cascading calls to <span class="pkg">stringi</span> operations solely.

## Details

Quoting the ICU User Guide, \'Hundreds of encodings have been developed over the years, each for small groups of languages and for special purposes. As a result, the interpretation of text, input, sorting, display, and storage depends on the knowledge of all the different types of character sets and their encodings. Programs have been written to handle either one single encoding at a time and switch between them, or to convert between external and internal encodings.\'

\'Unicode provides a single character set that covers the major languages of the world, and a small number of machine-friendly encoding forms and schemes to fit the needs of existing applications and protocols. It is designed for best interoperability with both ASCII and ISO-8859-1 (the most widely used character sets) to make it easier for Unicode to be used in almost all applications and protocols\' (see the ICU User Guide).

The Unicode Standard determines the way to map any possible character to a numeric value -- a so-called code point. Such code points, however, have to be stored somehow in computer\'s memory. The Unicode Standard encodes characters in the range U+0000..U+10FFFF, which amounts to a 21-bit code space. Depending on the encoding form (UTF-8, UTF-16, or UTF-32), each character will then be represented either as a sequence of one to four 8-bit bytes, one or two 16-bit code units, or a single 32-bit integer (compare the ICU FAQ).

Unicode can be thought of as a superset of the spectrum of characters supported by any given code page.

## UTF-8 and UTF-16

For portability reasons, the UTF-8 encoding is the most natural choice for representing Unicode character strings in <span style="font-family: Courier New, Courier; color: #666666;">**R**</span>. UTF-8 has ASCII as its subset (code points 1--127 represent the same characters in both of them). Code points larger than 127 are represented by multi-byte sequences (from 2 to 4 bytes: Please note that not all sequences of bytes are valid UTF-8, compare [`stri_enc_isutf8`](stri_enc_isutf8.md)).

Most of the computations in <span class="pkg">stringi</span> are performed internally using either UTF-8 or UTF-16 encodings (this depends on type of service you request: some <span class="pkg">ICU</span> services are designed only to work with UTF-16). Due to such a choice, with <span class="pkg">stringi</span> you get the same result on each platform, which is -- unfortunately -- not the case of base <span style="font-family: Courier New, Courier; color: #666666;">**R**</span>\'s functions (for instance, it is known that performing a regular expression search under Linux on some texts may give you a different result to those obtained under Windows). We really had portability in our minds while developing our package!

We have observed that <span style="font-family: Courier New, Courier; color: #666666;">**R**</span> correctly handles UTF-8 strings regardless of your platform\'s native encoding (see below). Therefore, we decided that most functions in <span class="pkg">stringi</span> will output its results in UTF-8 -- this speeds ups computations on cascading calls to our functions: the strings does not have to be re-encoded each time.

Note that some Unicode characters may have an ambiguous representation. For example, "a with ogonek" (one character) and "a"+"ogonek" (two graphemes) are semantically the same. <span class="pkg">stringi</span> provides functions to normalize character sequences, see [`stri_trans_nfc`](stri_trans_nf.md) for discussion. However, it is observed that denormalized strings do appear very rarely in typical string processing activities.

Additionally, do note that <span class="pkg">stringi</span> silently removes byte order marks (BOMs - they may incidentally appear in a string read from a text file) from UTF8-encoded strings, see [`stri_enc_toutf8`](stri_enc_toutf8.md).

## Character Encodings in <span style="font-family: Courier New, Courier; color: #666666;">**R**</span>

Data in memory are just bytes (small integer values) -- an en*coding* is a way to represent characters with such numbers, it is a semantic \'key\' to understand a given byte sequence. For example, in ISO-8859-2 (Central European), the value 177 represents Polish "a with ogonek", and in ISO-8859-1 (Western European), the same value denotes the "plus-minus" sign. Thus, a character encoding is a translation scheme: we need to communicate with <span style="font-family: Courier New, Courier; color: #666666;">**R**</span> somehow, relying on how it represents strings.

Overall, <span style="font-family: Courier New, Courier; color: #666666;">**R**</span> has a very simple encoding marking mechanism, see [`stri_enc_mark`](stri_enc_mark.md). There is an implicit assumption that your platform\'s default (native) encoding always extends ASCII -- <span class="pkg">stringi</span> checks that whenever your native encoding is being detected automatically on <span class="pkg">ICU</span>\'s initialization and each time when you change it manually by calling [`stri_enc_set`](stri_enc_set.md).

Character strings in <span style="font-family: Courier New, Courier; color: #666666;">**R**</span> (internally) can be declared to be in:

-   `UTF-8`;

-   `latin1`, i.e., either ISO-8859-1 (Western European on Linux, OS X, and other Unixes) or WINDOWS-1252 (Windows);

-   `bytes` -- for strings that should be manipulated as sequences of bytes.

Moreover, there are two other cases:

-   ASCII -- for strings consisting only of byte codes not greater than 127;

-   `native` (a.k.a. `unknown` in [`Encoding`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/Encoding.html); quite a misleading name: no explicit encoding mark) -- for strings that are assumed to be in your platform\'s native (default) encoding. This can represent UTF-8 if you are an OS X user, or some 8-bit Windows code page, for example. The native encoding used by <span style="font-family: Courier New, Courier; color: #666666;">**R**</span> may be determined by examining the LC\_CTYPE category, see [`Sys.getlocale`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/locales.html).

Intuitively, "native" strings result from reading a string from stdin (e.g., keyboard input). This makes sense: your operating system works in some encoding and provides <span style="font-family: Courier New, Courier; color: #666666;">**R**</span> with some data.

Each time when a <span class="pkg">stringi</span> function encounters a string declared in native encoding, it assumes that the input data should be translated from the default encoding, i.e., the one returned by [`stri_enc_get`](stri_enc_set.md) (unless you know what you are doing, the default encoding should only be changed if the automatic encoding detection process fails on <span class="pkg">stringi</span> load).

Functions which allow `'bytes'` encoding markings are very rare in <span class="pkg">stringi</span>, and were carefully selected. These are: [`stri_enc_toutf8`](stri_enc_toutf8.md) (with argument `is_unknown_8bit=TRUE`), [`stri_enc_toascii`](stri_enc_toascii.md), and [`stri_encode`](stri_encode.md).

Finally, note that <span style="font-family: Courier New, Courier; color: #666666;">**R**</span> lets strings in ASCII, UTF-8, and your platform\'s native encoding coexist. A character vector printed with [`print`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/print.html), [`cat`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/cat.html), etc., is silently re-encoded so that it can be properly shown, e.g., on the console.

## Encoding Conversion

Apart from automatic conversion from the native encoding, you may re-encode a string manually, for example when you read it from a file created on a different platform. Call [`stri_enc_list`](stri_enc_list.md) for the list of encodings supported by <span class="pkg">ICU</span>. Note that converter names are case-insensitive and <span class="pkg">ICU</span> tries to normalize the encoding specifiers. Leading zeroes are ignored in sequences of digits (if further digits follow), and all non-alphanumeric characters are ignored. Thus the strings \'UTF-8\', \'utf\_8\', \'u\*Tf08\' and \'Utf 8\' are equivalent.

The [`stri_encode`](stri_encode.md) function allows you to convert between any given encodings (in some cases you will obtain `bytes`-marked strings, or even lists of raw vectors (i.e., for UTF-16). There are also some useful more specialized functions, like [`stri_enc_toutf32`](stri_enc_toutf32.md) (converts a character vector to a list of integers, where one code point is exactly one numeric value) or [`stri_enc_toascii`](stri_enc_toascii.md) (substitutes all non-ASCII bytes with the SUBSTITUTE CHARACTER, which plays a similar role as <span style="font-family: Courier New, Courier; color: #666666;">**R**</span>\'s `NA` value).

There are also some routines for automated encoding detection, see, e.g., [`stri_enc_detect`](stri_enc_detect.md).

## Encoding Detection

Given a text file, one has to know how to interpret (encode) raw data in order to obtain meaningful information.

Encoding detection is always an imprecise operation and needs a considerable amount of data. However, in case of some encodings (like UTF-8, ASCII, or UTF-32) a "false positive" byte sequence is quite rare (statistically speaking).

Check out [`stri_enc_detect`](stri_enc_detect.md) (among others) for a useful function in this category.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Unicode Basics* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/icu/unicode.html>

*Conversion* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/conversion/>

*Converters* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/conversion/converters.html> (technical details)

*UTF-8, UTF-16, UTF-32 & BOM* -- ICU FAQ, <https://www.unicode.org/faq/utf_bom.html>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other stringi\_general\_topics: [`about_arguments`](about_arguments.md), [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_charclass`](about_search_charclass.md), [`about_search_coll`](about_search_coll.md), [`about_search_fixed`](about_search_fixed.md), [`about_search_regex`](about_search_regex.md), [`about_search`](about_search.md), [`about_stringi`](about_stringi.md)

Other encoding\_management: [`stri_enc_info()`,](stri_enc_info.md) [`stri_enc_list()`,](stri_enc_list.md) [`stri_enc_mark()`,](stri_enc_mark.md) `stri_enc_set()`

Other encoding\_detection: [`stri_enc_detect2()`,](stri_enc_detect2.md) [`stri_enc_detect()`,](stri_enc_detect.md) [`stri_enc_isascii()`,](stri_enc_isascii.md) [`stri_enc_isutf16be()`,](stri_enc_isutf16.md) `stri_enc_isutf8()`

Other encoding\_conversion: [`stri_enc_fromutf32()`,](stri_enc_fromutf32.md) [`stri_enc_toascii()`,](stri_enc_toascii.md) [`stri_enc_tonative()`,](stri_enc_tonative.md) [`stri_enc_toutf32()`,](stri_enc_toutf32.md) [`stri_enc_toutf8()`,](stri_enc_toutf8.md) `stri_encode()`
