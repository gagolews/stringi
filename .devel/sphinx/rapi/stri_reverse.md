# stri_reverse: Reverse Each String

## Description

Reverses the order of the code points in every string.

## Usage

``` r
stri_reverse(str)
```

## Arguments

|       |                  |
|-------|------------------|
| `str` | character vector |

## Details

Note that this operation may result in non-Unicode-normalized strings and may give peculiar outputs for bidirectional strings.

See also [`stri_rand_shuffle`](stri_rand_shuffle.md) for a random permutation of code points.

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

## Examples




```r
stri_reverse(c('123', 'abc d e f'))
```

```
## [1] "321"       "f e d cba"
```

```r
stri_reverse('ZXY (\u0105\u0104123$^).')
```

```
## [1] ".)^$321Ąą( YXZ"
```

```r
stri_reverse(stri_trans_nfd('\u0105')) == stri_trans_nfd('\u0105') # A, ogonek -> agonek, A
```

```
## [1] FALSE
```
