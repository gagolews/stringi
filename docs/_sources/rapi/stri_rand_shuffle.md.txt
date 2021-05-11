# stri\_rand\_shuffle: Randomly Shuffle Code Points in Each String

## Description

Generates a (pseudo)random permutation of the code points in each string.

## Usage

```r
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

## See Also

Other random: [`stri_rand_lipsum()`,](stri_rand_lipsum.md) `stri_rand_strings()`

## Examples




```r
stri_rand_shuffle(c('abcdefghi', '0123456789'))
## [1] "caifdhegb"  "6179543028"
# you can do better than this with stri_rand_strings:
stri_rand_shuffle(rep(stri_paste(letters, collapse=''), 10))
##  [1] "nhtzxvgkiorwmulajsdcqpfbye" "gkviptjbfohnslxuzyqmrwecda"
##  [3] "vjbryfkgcsewuitphqdxozmnal" "kizcwaqrnlufymxdbtospevjhg"
##  [5] "fqtrnehczpkgdmwbijovxluyas" "onrchfamlipwzjgdyxsevtkubq"
##  [7] "amxswgntefjzyviukrpqodbhcl" "nlvfrxeipgudsakzqtyjowhcmb"
##  [9] "grvuhbpimydwzqkxloasctejnf" "hlpvfqwjmbonyzrseuikgadxct"
```
