# about\_search: String Searching

## Description

This man page explains how to perform string search-based operations in <span class="pkg">stringi</span>.

## Details

The following independent string searching engines are available in <span class="pkg">stringi</span>.

-   `stri_*_regex` -- <span class="pkg">ICU</span>\'s regular expressions (regexes), see [about\_search\_regex](https://stringi.gagolewski.com/rapi/about_search_regex.html),

-   `stri_*_fixed` -- locale-independent byte-wise pattern matching, see [about\_search\_fixed](https://stringi.gagolewski.com/rapi/about_search_fixed.html),

-   `stri_*_coll` -- <span class="pkg">ICU</span>\'s `StringSearch`, locale-sensitive, Collator-based pattern search, useful for natural language processing tasks, see [about\_search\_coll](https://stringi.gagolewski.com/rapi/about_search_coll.html),

-   `stri_*_charclass` -- character classes search, e.g., Unicode General Categories or Binary Properties, see [about\_search\_charclass](https://stringi.gagolewski.com/rapi/about_search_charclass.html),

-   `stri_*_boundaries` -- text boundary analysis, see [about\_search\_boundaries](https://stringi.gagolewski.com/rapi/about_search_boundaries.html)

Each search engine is able to perform many search-based operations. These may include:

-   `stri_detect_*` - detect if a pattern occurs in a string, see, e.g., [`stri_detect`](https://stringi.gagolewski.com/rapi/stri_detect.html),

-   `stri_count_*` - count the number of pattern occurrences, see, e.g., [`stri_count`](https://stringi.gagolewski.com/rapi/stri_count.html),

-   `stri_locate_*` - locate all, first, or last occurrences of a pattern, see, e.g., [`stri_locate`](https://stringi.gagolewski.com/rapi/stri_locate.html),

-   `stri_extract_*` - extract all, first, or last occurrences of a pattern, see, e.g., [`stri_extract`](https://stringi.gagolewski.com/rapi/stri_extract.html) and, in case of regexes, [`stri_match`](https://stringi.gagolewski.com/rapi/stri_match.html),

-   `stri_replace_*` - replace all, first, or last occurrences of a pattern, see, e.g., [`stri_replace`](https://stringi.gagolewski.com/rapi/stri_replace.html) and also [`stri_trim`](https://stringi.gagolewski.com/rapi/stri_trim.html),

-   `stri_split_*` - split a string into chunks indicated by occurrences of a pattern, see, e.g., [`stri_split`](https://stringi.gagolewski.com/rapi/stri_split.html),

-   `stri_startswith_*` and `stri_endswith_*` detect if a string starts or ends with a pattern match, see, e.g., [`stri_startswith`](https://stringi.gagolewski.com/rapi/stri_startswith.html),

-   `stri_subset_*` - return a subset of a character vector with strings that match a given pattern, see, e.g., [`stri_subset`](https://stringi.gagolewski.com/rapi/stri_subset.html).

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other text\_boundaries: [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_brkiter`](https://stringi.gagolewski.com/rapi/stri_opts_brkiter.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_split_lines`](https://stringi.gagolewski.com/rapi/stri_split_lines.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

Other search\_regex: [`about_search_regex`](https://stringi.gagolewski.com/rapi/about_search_regex.html), [`stri_opts_regex`](https://stringi.gagolewski.com/rapi/stri_opts_regex.html)()

Other search\_fixed: [`about_search_fixed`](https://stringi.gagolewski.com/rapi/about_search_fixed.html), [`stri_opts_fixed`](https://stringi.gagolewski.com/rapi/stri_opts_fixed.html)()

Other search\_coll: [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)()

Other search\_charclass: [`about_search_charclass`](https://stringi.gagolewski.com/rapi/about_search_charclass.html), [`stri_trim_both`](https://stringi.gagolewski.com/rapi/stri_trim_both.html)()

Other search\_detect: [`stri_detect`](https://stringi.gagolewski.com/rapi/stri_detect.html)(), [`stri_startswith`](https://stringi.gagolewski.com/rapi/stri_startswith.html)()

Other search\_count: [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_count`](https://stringi.gagolewski.com/rapi/stri_count.html)()

Other search\_locate: [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_locate_all`](https://stringi.gagolewski.com/rapi/stri_locate_all.html)()

Other search\_replace: [`stri_replace_all`](https://stringi.gagolewski.com/rapi/stri_replace_all.html)(), [`stri_trim_both`](https://stringi.gagolewski.com/rapi/stri_trim_both.html)()

Other search\_split: [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_split_lines`](https://stringi.gagolewski.com/rapi/stri_split_lines.html)(), [`stri_split`](https://stringi.gagolewski.com/rapi/stri_split.html)()

Other search\_subset: [`stri_subset`](https://stringi.gagolewski.com/rapi/stri_subset.html)()

Other search\_extract: [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_extract_all`](https://stringi.gagolewski.com/rapi/stri_extract_all.html)(), [`stri_match_all`](https://stringi.gagolewski.com/rapi/stri_match_all.html)()

Other stringi\_general\_topics: [`about_arguments`](https://stringi.gagolewski.com/rapi/about_arguments.html), [`about_encoding`](https://stringi.gagolewski.com/rapi/about_encoding.html), [`about_locale`](https://stringi.gagolewski.com/rapi/about_locale.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_charclass`](https://stringi.gagolewski.com/rapi/about_search_charclass.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`about_search_fixed`](https://stringi.gagolewski.com/rapi/about_search_fixed.html), [`about_search_regex`](https://stringi.gagolewski.com/rapi/about_search_regex.html), [`about_stringi`](https://stringi.gagolewski.com/rapi/about_stringi.html)
