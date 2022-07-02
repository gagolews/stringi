# about_search_regex: Regular Expressions in <span class="pkg">stringi</span>

## Description

A regular expression is a pattern describing, possibly in a very abstract way, a text fragment. With so many regex functions in <span class="pkg">stringi</span>, regular expressions may be a very powerful tool to perform string searching, substring extraction, string splitting, etc., tasks.

## Details

All `stri_*_regex` functions in <span class="pkg">stringi</span> use the <span class="pkg">ICU</span> regex engine. Its settings may be tuned up (for example to perform case-insensitive search) via the [`stri_opts_regex`](stri_opts_regex.md) function.

Regular expression patterns in <span class="pkg">ICU</span> are quite similar in form and behavior to Perl\'s regexes. Their implementation is loosely inspired by JDK 1.4 `java.util.regex`. <span class="pkg">ICU</span> Regular Expressions conform to the Unicode Technical Standard #18 (see References section) and its features are summarized in the ICU User Guide (see below). A good general introduction to regexes is (Friedl, 2002). Some general topics are also covered in the <span style="font-family: Courier New, Courier; color: #666666;">**R**</span> manual, see [regex](https://stat.ethz.ch/R-manual/R-devel/library/base/html/regex.html).

## <span class="pkg">ICU</span> Regex Operators at a Glance

Here is a list of operators provided by the ICU User Guide on regexes.

`|`

:   Alternation. `A|B` matches either A or B.

`*`

:   Match 0 or more times. Match as many times as possible.

`+`

:   Match 1 or more times. Match as many times as possible.

`?`

:   Match zero or one times. Prefer one.

`{n}`

:   Match exactly n times.

`{n,}`

:   Match at least n times. Match as many times as possible.

`{n,m}`

:   Match between n and m times. Match as many times as possible, but not more than m.

`*?`

:   Match 0 or more times. Match as few times as possible.

`+?`

:   Match 1 or more times. Match as few times as possible.

`??`

:   Match zero or one times. Prefer zero.

`{n}?`

:   Match exactly n times.

`{n,}?`

:   Match at least n times, but no more than required for an overall pattern match.

`{n,m}?`

:   Match between n and m times. Match as few times as possible, but not less than n.

`*+`

:   Match 0 or more times. Match as many times as possible when first encountered, do not retry with fewer even if overall match fails (Possessive Match).

`++`

:   Match 1 or more times. Possessive match.

`?+`

:   Match zero or one times. Possessive match.

`{n}+`

:   Match exactly n times.

`{n,}+`

:   Match at least n times. Possessive Match.

`{n,m}+`

:   Match between n and m times. Possessive Match.

`(...)`

:   Capturing parentheses. Range of input that matched the parenthesized sub-expression is available after the match, see [`stri_match`](stri_match.md).

`(?:...)`

:   Non-capturing parentheses. Groups the included pattern, but does not provide capturing of matching text. Somewhat more efficient than capturing parentheses.

`(?>...)`

:   Atomic-match parentheses. First match of the parenthesized sub-expression is the only one tried; if it does not lead to an overall pattern match, back up the search for a match to a position before the `(?>`.

`(?#...)`

:   Free-format comment `(?# comment )`.

`(?=...)`

:   Look-ahead assertion. True if the parenthesized pattern matches at the current input position, but does not advance the input position.

`(?!...)`

:   Negative look-ahead assertion. True if the parenthesized pattern does not match at the current input position. Does not advance the input position.

`(?<=...)`

:   Look-behind assertion. True if the parenthesized pattern matches text preceding the current input position, with the last character of the match being the input character just before the current position. Does not alter the input position. The length of possible strings matched by the look-behind pattern must not be unbounded (no `*` or `+` operators.)

`(?<!...)`

:   Negative Look-behind assertion. True if the parenthesized pattern does not match text preceding the current input position, with the last character of the match being the input character just before the current position. Does not alter the input position. The length of possible strings matched by the look-behind pattern must not be unbounded (no `*` or `+` operators.)

`(?<name>...)`

:   Named capture group, where `name` (enclosed within the angle brackets) is a sequence like `[A-Za-z][A-Za-z0-9]*`

`(?ismwx-ismwx:...)`

:   Flag settings. Evaluate the parenthesized expression with the specified flags enabled or `-`disabled, see also [`stri_opts_regex`](stri_opts_regex.md).

`(?ismwx-ismwx)`

:   Flag settings. Change the flag settings. Changes apply to the portion of the pattern following the setting. For example, `(?i)` changes to a case insensitive match, see also [`stri_opts_regex`](stri_opts_regex.md).

## <span class="pkg">ICU</span> Regex Meta-characters at a Glance

Here is a list of meta-characters provided by the ICU User Guide on regexes.

`\a`

:   Match a BELL, `\u0007`.

`\A`

:   Match at the beginning of the input. Differs from `^`. in that `\A` will not match after a new line within the input.

`\b`

:   Match if the current position is a word boundary. Boundaries occur at the transitions between word (`\w`) and non-word (`\W`) characters, with combining marks ignored. For better word boundaries, see <span class="pkg">ICU</span> Boundary Analysis, e.g., [`stri_extract_all_words`](stri_extract_boundaries.md).

`\B`

:   Match if the current position is not a word boundary.

`\cX`

:   Match a control-`X` character.

`\d`

:   Match any character with the Unicode General Category of `Nd` (Number, Decimal Digit.).

`\D`

:   Match any character that is not a decimal digit.

`\e`

:   Match an ESCAPE, `\u001B`.

`\E`

:   Terminates a `\Q` \... `\E` quoted sequence.

`\f`

:   Match a FORM FEED, `\u000C`.

`\G`

:   Match if the current position is at the end of the previous match.

`\h`

:   Match a Horizontal White Space character. They are characters with Unicode General Category of Space_Separator plus the ASCII tab, `\u0009`. \[Since ICU 55\]

`\H`

:   Match a non-Horizontal White Space character. \[Since ICU 55\]

`\k<name>`

:   Named Capture Back Reference. \[Since ICU 55\]

`\n`

:   Match a LINE FEED, `\u000A`.

`\N{UNICODE CHARACTER NAME}`

:   Match the named character.

`\p{UNICODE PROPERTY NAME}`

:   Match any character with the specified Unicode Property.

`\P{UNICODE PROPERTY NAME}`

:   Match any character not having the specified Unicode Property.

`\Q`

:   Quotes all following characters until `\E`.

`\r`

:   Match a CARRIAGE RETURN, `\u000D`.

`\s`

:   Match a white space character. White space is defined as `[\t\n\f\r\p{Z}]`.

`\S`

:   Match a non-white space character.

`\t`

:   Match a HORIZONTAL TABULATION, `\u0009`.

`\uhhhh`

:   Match the character with the hex value `hhhh`.

`\Uhhhhhhhh`

:   Match the character with the hex value `hhhhhhhh`. Exactly eight hex digits must be provided, even though the largest Unicode code point is `\U0010ffff`.

`\w`

:   Match a word character. Word characters are `[\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\u200c\u200d]`.

`\W`

:   Match a non-word character.

`\x{hhhh}`

:   Match the character with hex value hhhh. From one to six hex digits may be supplied.

`\xhh`

:   Match the character with two digit hex value hh

`\X`

:   Match a Grapheme Cluster.

`\Z`

:   Match if the current position is at the end of input, but before the final line terminator, if one exists.

`\z`

:   Match if the current position is at the end of input.

`\n`

:   Back Reference. Match whatever the nth capturing group matched. n must be a number \> 1 and \< total number of capture groups in the pattern.

`\0ooo`

:   Match an Octal character. `'ooo'` is from one to three octal digits. 0377 is the largest allowed Octal character. The leading zero is required; it distinguishes Octal constants from back references.

`[pattern]`

:   Match any one character from the set.

`.`

:   Match any character except for - by default - newline, compare [`stri_opts_regex`](stri_opts_regex.md).

`^`

:   Match at the beginning of a line.

`$`

:   Match at the end of a line.

`\`

:   \[outside of sets\] Quotes the following character. Characters that must be quoted to be treated as literals are `* ? + [ ( ) { } ^ $ | \ .`.

`\`

:   \[inside sets\] Quotes the following character. Characters that must be quoted to be treated as literals are `[ ] \`; Characters that may need to be quoted, depending on the context are `- &`.

## Character Classes

The syntax is similar, but not 100% compatible with the one described in [about_search_charclass](about_search_charclass.md). In particular, whitespaces are not ignored and set-theoretic operations are denoted slightly differently. However, other than this [about_search_charclass](about_search_charclass.md) is a good reference on the capabilities offered.

The ICU User Guide on regexes lists what follows.

`[abc]`

:   Match any of the characters a, b, or c

`[^abc]`

:   Negation -- match any character except a, b, or c

`[A-M]`

:   Range -- match any character from A to M (based on Unicode code point ordering)

`[\p{L}]`, `[\p{Letter}]`, `[\p{General_Category=Letter}]`, `[:letter:]`

:   Characters with Unicode Category = Letter (4 equivalent forms)

`[\P{Letter}]`

:   Negated property -- natch everything except Letters

`[\p{numeric_value=9}]`

:   Match all numbers with a numeric value of 9

`[\p{Letter}&&\p{script=cyrillic}]`

:   Intersection; match the set of all Cyrillic letters

`[\p{Letter}--\p{script=latin}]`

:   Set difference; match all non-Latin letters

`[[a-z][A-Z][0-9]]`, `[a-zA-Z0-9]`

:   Union; match ASCII letters and digits (2 equivalent forms)

## Regex Functions in <span class="pkg">stringi</span>

Note that if a given regex `pattern` is empty, then all the functions in <span class="pkg">stringi</span> give `NA` in result and generate a warning. On a syntax error, a quite informative failure message is shown.

If you wish to search for a fixed pattern, refer to [about_search_coll](about_search_coll.md) or [about_search_fixed](about_search_fixed.md). They allow to perform a locale-aware text lookup, or a very fast exact-byte search, respectively.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Regular expressions* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/strings/regexp.html>

J.E.F. Friedl, *Mastering Regular Expressions*, O\'Reilly, 2002

*Unicode Regular Expressions* -- Unicode Technical Standard #18, <https://www.unicode.org/reports/tr18/>

*Unicode Regular Expressions* -- Regex tutorial, <https://www.regular-expressions.info/unicode.html>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi:<https://dx.doi.org/10.18637/jss.v103.i02>

Other search_regex: [`about_search`](about_search.md), [`stri_opts_regex()`](stri_opts_regex.md)

Other stringi_general_topics: [`about_arguments`](about_arguments.md), [`about_encoding`](about_encoding.md), [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_charclass`](about_search_charclass.md), [`about_search_coll`](about_search_coll.md), [`about_search_fixed`](about_search_fixed.md), [`about_search`](about_search.md), [`about_stringi`](about_stringi.md)
