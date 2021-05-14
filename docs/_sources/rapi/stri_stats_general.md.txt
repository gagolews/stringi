# stri\_stats\_general: General Statistics for a Character Vector

## Description

This function gives general statistics for a character vector, e.g., obtained by loading a text file with the [`readLines`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/readLines.html) or [`stri_read_lines`](stri_read_lines.md) function, where each text line\' is represented by a separate string.

## Usage

```r
stri_stats_general(str)
```

## Arguments

|       |                                   |
|-------|-----------------------------------|
| `str` | character vector to be aggregated |

## Details

None of the strings may contain `\r` or `\n` characters, otherwise you will get at error.

Below by \'white space\' we mean the Unicode binary property `WHITE_SPACE`, see `stringi-search-charclass`.

## Value

Returns an integer vector with the following named elements:

1.  `Lines` - number of lines (number of non-missing strings in the vector);

2.  `LinesNEmpty` - number of lines with at least one non-`WHITE_SPACE` character;

3.  `Chars` - total number of Unicode code points detected;

4.  `CharsNWhite` - number of Unicode code points that are not `WHITE_SPACE`s;

5.  \... (Other stuff that may appear in future releases of <span class="pkg">stringi</span>).

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other stats: `stri_stats_latex()`

## Examples




```r
s <- c('Lorem ipsum dolor sit amet, consectetur adipisicing elit.',
       'nibh augue, suscipit a, scelerisque sed, lacinia in, mi.',
       'Cras vel lorem. Etiam pellentesque aliquet tellus.',
       '')
stri_stats_general(s)
##       Lines LinesNEmpty       Chars CharsNWhite 
##           4           3         163         142
```
