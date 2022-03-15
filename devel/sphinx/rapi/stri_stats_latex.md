# stri_stats_latex: Statistics for a Character Vector Containing LaTeX Commands

## Description

This function gives LaTeX-oriented statistics for a character vector, e.g., obtained by loading a text file with the [`readLines`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/readLines.html) function, where each text line is represented by a separate string.

## Usage

``` r
stri_stats_latex(str)
```

## Arguments

|       |                                   |
|-------|-----------------------------------|
| `str` | character vector to be aggregated |

## Details

We use a slightly modified LaTeX Word Count algorithm implemented in Kile 2.1.3, see <https://kile.sourceforge.io/team.php> for the original contributors.

## Value

Returns an integer vector with the following named elements:

1.  `CharsWord` - number of word characters;

2.  `CharsCmdEnvir` - command and words characters;

3.  `CharsWhite` - LaTeX white spaces, including { and } in some contexts;

4.  `Words` - number of words;

5.  `Cmds` - number of commands;

6.  `Envirs` - number of environments;

7.  \... (Other stuff that may appear in future releases of <span class="pkg">stringi</span>).

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other stats: [`stri_stats_general()`](stri_stats_general.md)

## Examples




```r
s <- c('Lorem \\textbf{ipsum} dolor sit \\textit{amet}, consectetur adipisicing elit.',
       '\\begin{small}Proin nibh augue,\\end{small} suscipit a, scelerisque sed, lacinia in, mi.',
       '')
stri_stats_latex(s)
##     CharsWord CharsCmdEnvir    CharsWhite         Words          Cmds 
##            96            38            27            18             2 
##        Envirs 
##             1
```
