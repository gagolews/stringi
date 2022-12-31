# stri_stats_general: General Statistics for a Character Vector

## Description

This function gives general statistics for a character vector, e.g., obtained by loading a text file with the [`readLines`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/readLines.html) or [`stri_read_lines`](stri_read_lines.md) function, where each text line\' is represented by a separate string.

## Usage

``` r
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

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other stats: [`stri_stats_latex()`](stri_stats_latex.md)

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
