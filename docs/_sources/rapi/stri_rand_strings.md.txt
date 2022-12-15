# stri_rand_strings: Generate Random Strings

## Description

Generates (pseudo)random strings of desired lengths.

## Usage

``` r
stri_rand_strings(n, length, pattern = "[A-Za-z0-9]")
```

## Arguments

|           |                                                                                                                                |
|-----------|--------------------------------------------------------------------------------------------------------------------------------|
| `n`       | single integer, number of observations                                                                                         |
| `length`  | integer vector, desired string lengths                                                                                         |
| `pattern` | character vector specifying character classes to draw elements from, see [stringi-search-charclass](about_search_charclass.md) |

## Details

Vectorized over `length` and `pattern`. If length of `length` or `pattern` is greater than `n`, then redundant elements are ignored. Otherwise, these vectors are recycled if necessary.

This operation may result in non-Unicode-normalized strings and may give peculiar outputs for bidirectional strings.

Sampling of code points from the set specified by `pattern` is always done with replacement and each code point appears with equal probability.

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other random: [`stri_rand_lipsum()`](stri_rand_lipsum.md), [`stri_rand_shuffle()`](stri_rand_shuffle.md)

## Examples




```r
stri_rand_strings(5, 10) # 5 strings of length 10
## [1] "HmPsw2WtYS" "xSgZ6tF2Kx" "tgdzehXaH9" "xtgn1TlDJE" "8PPM98ESGr"
stri_rand_strings(5, sample(1:10, 5, replace=TRUE)) # 5 strings of random lengths
## [1] "tNf5N"     "HoRoonR"   "kdi0T"     "DNbL6F"    "fPm6QztsA"
stri_rand_strings(10, 5, '[\\p{script=latin}&\\p{Ll}]') # small letters from the Latin script
##  [1] "ņẇɪẍɚ"  "ƞꜷđᴓᵹ"  "ḻɢᴣﬀᴟ"  "ꬵꭆṉʛŝ"  "ꭕɉðꭣỡ"  "ŕᶔﬀḧʗ"  "ẁəɑǖɽ"  "ｏŧďŕẵ"
##  [9] "ṗꬶẝỹᶀ"  "ẑꝯꜽｌᴀ"
# generate n random passwords of length in [8, 14]
# consisting of at least one digit, small and big ASCII letter:
n <- 10
stri_rand_shuffle(stri_paste(
   stri_rand_strings(n, 1, '[0-9]'),
   stri_rand_strings(n, 1, '[a-z]'),
   stri_rand_strings(n, 1, '[A-Z]'),
   stri_rand_strings(n, sample(5:11, 5, replace=TRUE), '[a-zA-Z0-9]')
))
##  [1] "3hGsaJNqZTaGw"  "wJGmtzJcuPS4"   "k0MsQHEx9bOZeV" "FTAJ1Dgf2A"    
##  [5] "8LxJPujoHhc"    "uNkX3Ygc2QThO"  "O9oTfpCn3X2G"   "aidxJ0jyFFDfOA"
##  [9] "TKGrmAlP2W"     "sffGLWZ7vKw"
```
