# about_search: String Searching

## Description

This man page explains how to perform string search-based operations in <span class="pkg">stringi</span>.

## Details

The following independent string searching engines are available in <span class="pkg">stringi</span>.

-   `stri_*_regex` -- <span class="pkg">ICU</span>\'s regular expressions (regexes), see [about_search_regex](about_search_regex.md),

-   `stri_*_fixed` -- locale-independent byte-wise pattern matching, see [about_search_fixed](about_search_fixed.md),

-   `stri_*_coll` -- <span class="pkg">ICU</span>\'s `StringSearch`, locale-sensitive, Collator-based pattern search, useful for natural language processing tasks, see [about_search_coll](about_search_coll.md),

-   `stri_*_charclass` -- character classes search, e.g., Unicode General Categories or Binary Properties, see [about_search_charclass](about_search_charclass.md),

-   `stri_*_boundaries` -- text boundary analysis, see [about_search_boundaries](about_search_boundaries.md)

Each search engine is able to perform many search-based operations. These may include:

-   `stri_detect_*` - detect if a pattern occurs in a string, see, e.g., [`stri_detect`](stri_detect.md),

-   `stri_count_*` - count the number of pattern occurrences, see, e.g., [`stri_count`](stri_count.md),

-   `stri_locate_*` - locate all, first, or last occurrences of a pattern, see, e.g., [`stri_locate`](stri_locate.md),

-   `stri_extract_*` - extract all, first, or last occurrences of a pattern, see, e.g., [`stri_extract`](stri_extract.md) and, in case of regexes, [`stri_match`](stri_match.md),

-   `stri_replace_*` - replace all, first, or last occurrences of a pattern, see, e.g., [`stri_replace`](stri_replace.md) and also [`stri_trim`](stri_trim.md),

-   `stri_split_*` - split a string into chunks indicated by occurrences of a pattern, see, e.g., [`stri_split`](stri_split.md),

-   `stri_startswith_*` and `stri_endswith_*` detect if a string starts or ends with a pattern match, see, e.g., [`stri_startswith`](stri_startsendswith.md),

-   `stri_subset_*` - return a subset of a character vector with strings that match a given pattern, see, e.g., [`stri_subset`](stri_subset.md).

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi: [10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other text_boundaries: [`about_search_boundaries`](about_search_boundaries.md), [`stri_count_boundaries()`](stri_count_boundaries.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_opts_brkiter()`](stri_opts_brkiter.md), [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_split_lines()`](stri_split_lines.md), [`stri_trans_tolower()`](stri_trans_casemap.md), [`stri_wrap()`](stri_wrap.md)

Other search_regex: [`about_search_regex`](about_search_regex.md), [`stri_opts_regex()`](stri_opts_regex.md)

Other search_fixed: [`about_search_fixed`](about_search_fixed.md), [`stri_opts_fixed()`](stri_opts_fixed.md)

Other search_coll: [`about_search_coll`](about_search_coll.md), [`stri_opts_collator()`](stri_opts_collator.md)

Other search_charclass: [`about_search_charclass`](about_search_charclass.md), [`stri_trim_both()`](stri_trim.md)

Other search_detect: [`stri_detect()`](stri_detect.md), [`stri_startswith()`](stri_startsendswith.md)

Other search_count: [`stri_count_boundaries()`](stri_count_boundaries.md), [`stri_count()`](stri_count.md)

Other search_locate: [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_locate_all()`](stri_locate.md)

Other search_replace: [`stri_replace_all()`](stri_replace.md), [`stri_replace_rstr()`](stri_replace_rstr.md), [`stri_trim_both()`](stri_trim.md)

Other search_split: [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_split_lines()`](stri_split_lines.md), [`stri_split()`](stri_split.md)

Other search_subset: [`stri_subset()`](stri_subset.md)

Other search_extract: [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_extract_all()`](stri_extract.md), [`stri_match_all()`](stri_match.md)

Other stringi_general_topics: [`about_arguments`](about_arguments.md), [`about_encoding`](about_encoding.md), [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_charclass`](about_search_charclass.md), [`about_search_coll`](about_search_coll.md), [`about_search_fixed`](about_search_fixed.md), [`about_search_regex`](about_search_regex.md), [`about_stringi`](about_stringi.md)
