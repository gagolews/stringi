# stri\_pad: Pad (Center/Left/Right Align) a String

## Description

Add multiple `pad` characters at the given `side`(s) of each string so that each output string is of total width of at least `width`. These functions may be used to center or left/right-align each string.

## Usage

```r
stri_pad_both(
  str,
  width = floor(0.9 * getOption("width")),
  pad = " ",
  use_length = FALSE
)

stri_pad_left(
  str,
  width = floor(0.9 * getOption("width")),
  pad = " ",
  use_length = FALSE
)

stri_pad_right(
  str,
  width = floor(0.9 * getOption("width")),
  pad = " ",
  use_length = FALSE
)

stri_pad(
  str,
  width = floor(0.9 * getOption("width")),
  side = c("left", "right", "both"),
  pad = " ",
  use_length = FALSE
)
```

## Arguments

|              |                                                                                                                                                                                 |
|--------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `str`        | character vector                                                                                                                                                                |
| `width`      | integer vector giving minimal output string lengths                                                                                                                             |
| `pad`        | character vector giving padding code points                                                                                                                                     |
| `use_length` | single logical value; should the number of code points be used instead of the total code point width (see [`stri_width`](https://stringi.gagolewski.com/rapi/stri_width.html))? |
| `side`       | \[`stri_pad` only\] single character string; sides on which padding character is added (`left`, `right`, or `both`)                                                             |

## Details

Vectorized over `str`, `width`, and `pad`. Each string in `pad` should consist of a code points of total width equal to 1 or, if `use_length` is `TRUE`, exactly one code point.

`stri_pad` is a convenience function, which dispatches to `stri_pad_*`.

Note that Unicode code points may have various widths when printed on the console and that, by default, the function takes that into account. By changing the state of the `use_length` argument, this function starts acting like each code point was of width 1. This feature should rather be used with text in Latin script.

See [`stri_trim_left`](https://stringi.gagolewski.com/rapi/stri_trim_left.html) (among others) for reverse operation. Also check out [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html) for line wrapping.

## Value

These functions return a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

## Examples




```r
stri_pad_left('stringi', 10, pad='#')
## [1] "###stringi"
stri_pad_both('stringi', 8:12, pad='*')
## [1] "stringi*"     "*stringi*"    "*stringi**"   "**stringi**"  "**stringi***"
# center on screen:
cat(stri_pad_both(c('the', 'string', 'processing', 'package'),
   getOption('width')*0.9), sep='\n')
##                                   the                                   
##                                  string                                 
##                                processing                               
##                                 package
cat(stri_pad_both(c('\ud6c8\ubbfc\uc815\uc74c', # takes width into account
   stri_trans_nfkd('\ud6c8\ubbfc\uc815\uc74c'), 'abcd'),
   width=10), sep='\n')
##  훈민정음 
##  훈민정음 
##    abcd
```
