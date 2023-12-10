# stri_rand_shuffle: Randomly Shuffle Code Points in Each String

## Description

Generates a (pseudo)random permutation of the code points in each string.

## Usage

``` r
stri_rand_shuffle(str)
```

## Arguments

|       |                  |
|-------|------------------|
| `str` | character vector |

## Details

This operation may result in non-Unicode-normalized strings and may give peculiar outputs in case of bidirectional strings.

See also [`stri_reverse`](stri_reverse.md) for reversing the order of code points.

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other random: [`stri_rand_lipsum()`](stri_rand_lipsum.md), [`stri_rand_strings()`](stri_rand_strings.md)

## Examples




```r
stri_rand_shuffle(c('abcdefghi', '0123456789'))
```

```
## [1] "cheidfbag"  "5096873241"
```

```r
# you can do better than this with stri_rand_strings:
stri_rand_shuffle(rep(stri_paste(letters, collapse=''), 10))
```

```
##  [1] "bjyxtszeufhpogcwdrvmaliqkn" "kafgjolxiqwmtpnhyucdbrzevs"
##  [3] "vumbrtgqlpfhniwkxeazjdocsy" "irjhvgpqsobzayneumlfdkcxtw"
##  [5] "yplrcekozfjnvmawxgqhtisbud" "afwijgkuxrqonshelmcvdpbyzt"
##  [7] "flircxuthpsygadwkjvmnzqebo" "zqynmsjreatfhcloipvubdwgkx"
##  [9] "kvyjzutiprsbclgfqonhmaedwx" "eqjtmzfuaidpkxbchygsrlownv"
```
