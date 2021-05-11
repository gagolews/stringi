# stri\_opts\_brkiter: Generate a List with BreakIterator Settings

## Description

A convenience function to tune the <span class="pkg">ICU</span> `BreakIterator`\'s behavior in some text boundary analysis functions, see [stringi-search-boundaries](about_search_boundaries.md).

## Usage

```r
stri_opts_brkiter(
  type,
  locale,
  skip_word_none,
  skip_word_number,
  skip_word_letter,
  skip_word_kana,
  skip_word_ideo,
  skip_line_soft,
  skip_line_hard,
  skip_sentence_term,
  skip_sentence_sep,
  ...
)
```

## Arguments

|                      |                                                                                                                                                                                                                |
|----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `type`               | single string; either the break iterator type, one of `character`, `line_break`, `sentence`, `word`, or a custom set of ICU break iteration rules; see [stringi-search-boundaries](about_search_boundaries.md) |
| `locale`             | single string, `NULL` or `''` for default locale                                                                                                                                                               |
| `skip_word_none`     | logical; perform no action for \'words\' that do not fit into any other categories                                                                                                                             |
| `skip_word_number`   | logical; perform no action for words that appear to be numbers                                                                                                                                                 |
| `skip_word_letter`   | logical; perform no action for words that contain letters, excluding hiragana, katakana, or ideographic characters                                                                                             |
| `skip_word_kana`     | logical; perform no action for words containing kana characters                                                                                                                                                |
| `skip_word_ideo`     | logical; perform no action for words containing ideographic characters                                                                                                                                         |
| `skip_line_soft`     | logical; perform no action for soft line breaks, i.e., positions where a line break is acceptable but not required                                                                                             |
| `skip_line_hard`     | logical; perform no action for hard, or mandatory line breaks                                                                                                                                                  |
| `skip_sentence_term` | logical; perform no action for sentences ending with a sentence terminator (\'`.`\', \'`,`\', \'`?`\', \'`!`\'), possibly followed by a hard separator (`CR`, `LF`, `PS`, etc.)                                |
| `skip_sentence_sep`  | logical; perform no action for sentences that do not contain an ending sentence terminator, but are ended by a hard separator or end of input                                                                  |
| `...`                | \[DEPRECATED\] any other arguments passed to this function generate a warning; this argument will be removed in the future                                                                                     |

## Details

The `skip_*` family of settings may be used to prevent performing any special actions on particular types of text boundaries, e.g., in case of the [`stri_locate_all_boundaries`](stri_locate_boundaries.md) and [`stri_split_boundaries`](stri_split_boundaries.md) functions.

Note that custom break iterator rules (advanced users only) should be specified as a single string. For a detailed description of the syntax of RBBI rules, please refer to the ICU User Guide on Boundary Analysis.

## Value

Returns a named list object. Omitted `skip_*` values act as they have been set to `FALSE`.

## References

*`ubrk.h` File Reference* -- ICU4C API Documentation, <https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/ubrk_8h.html>

*Boundary Analysis* -- ICU User Guide, <http://userguide.icu-project.org/boundaryanalysis>

## See Also

Other text\_boundaries: [`about_search_boundaries`](about_search_boundaries.md), [`about_search`](about_search.md), [`stri_count_boundaries()`,](stri_count_boundaries.md) [`stri_extract_all_boundaries()`,](stri_extract_boundaries.md) [`stri_locate_all_boundaries()`,](stri_locate_boundaries.md) [`stri_split_boundaries()`,](stri_split_boundaries.md) [`stri_split_lines()`,](stri_split_lines.md) [`stri_trans_tolower()`,](stri_trans_casemap.md) `stri_wrap()`
