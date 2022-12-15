# stri_opts_regex: Generate a List with Regex Matcher Settings

## Description

A convenience function to tune the <span class="pkg">ICU</span> regular expressions matcher\'s behavior, e.g., in [`stri_count_regex`](stri_count.md) and other [stringi-search-regex](about_search_regex.md) functions.

## Usage

``` r
stri_opts_regex(
  case_insensitive,
  comments,
  dotall,
  dot_all = dotall,
  literal,
  multiline,
  multi_line = multiline,
  unix_lines,
  uword,
  error_on_unknown_escapes,
  time_limit = 0L,
  stack_limit = 0L,
  ...
)
```

## Arguments

|                            |                                                                                                                                                                                                                                                                                  |
|----------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `case_insensitive`         | logical; enables case insensitive matching \[regex flag `(?i)`\]                                                                                                                                                                                                                 |
| `comments`                 | logical; allows white space and comments within patterns \[regex flag `(?x)`\]                                                                                                                                                                                                   |
| `dotall`                   | logical; if set, \'`.`\' matches line terminators, otherwise matching of \'`.`\' stops at a line end \[regex flag `(?s)`\]                                                                                                                                                       |
| `dot_all`                  | alias of `dotall`                                                                                                                                                                                                                                                                |
| `literal`                  | logical; if set, treat the entire pattern as a literal string: metacharacters or escape sequences in the input sequence will be given no special meaning; note that in most cases you would rather use the [stringi-search-fixed](about_search_fixed.md) facilities in this case |
| `multiline`                | logical; controls the behavior of \'`$`\' and \'`^`\'. If set, recognize line terminators within a string, otherwise, match only at start and end of input string \[regex flag `(?m)`\]                                                                                          |
| `multi_line`               | alias of `multiline`                                                                                                                                                                                                                                                             |
| `unix_lines`               | logical; Unix-only line endings; when enabled, only `U+000a` is recognized as a line ending by \'`.`\', \'`$`\', and \'`^`\'.                                                                                                                                                    |
| `uword`                    | logical; Unicode word boundaries; if set, uses the Unicode TR 29 definition of word boundaries; warning: Unicode word boundaries are quite different from traditional regex word boundaries. \[regex flag `(?w)`\] See <https://unicode.org/reports/tr29/#Word_Boundaries>       |
| `error_on_unknown_escapes` | logical; whether to generate an error on unrecognized backslash escapes; if set, fail with an error on patterns that contain backslash-escaped ASCII letters without a known special meaning; otherwise, these escaped letters represent themselves                              |
| `time_limit`               | integer; processing time limit, in \~milliseconds (but not precisely so, depends on the CPU speed), for match operations; setting a limit is desirable if poorly written regexes are expected on input; 0 for no limit                                                           |
| `stack_limit`              | integer; maximal size, in bytes, of the heap storage available for the match backtracking stack; setting a limit is desirable if poorly written regexes are expected on input; 0 for no limit                                                                                    |
| `...`                      | \[DEPRECATED\] any other arguments passed to this function generate a warning; this argument will be removed in the future                                                                                                                                                       |

## Details

Note that some regex settings may be changed using ICU regex flags inside regexes. For example, `'(?i)pattern'` performs a case-insensitive match of a given pattern, see the <span class="pkg">ICU</span> User Guide entry on Regular Expressions in the References section or [stringi-search-regex](about_search_regex.md).

## Value

Returns a named list object; missing settings are left with default values.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*`enum URegexpFlag`: Constants for Regular Expression Match Modes* -- ICU4C API Documentation, <https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/uregex_8h.html>

*Regular Expressions* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/strings/regexp.html>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other search_regex: [`about_search_regex`](about_search_regex.md), [`about_search`](about_search.md)

## Examples




```r
stri_detect_regex('ala', 'ALA') # case-sensitive by default
## [1] FALSE
stri_detect_regex('ala', 'ALA', opts_regex=stri_opts_regex(case_insensitive=TRUE))
## [1] TRUE
stri_detect_regex('ala', 'ALA', case_insensitive=TRUE) # equivalent
## [1] TRUE
stri_detect_regex('ala', '(?i)ALA') # equivalent
## [1] TRUE
```
