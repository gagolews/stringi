# stri\_replace\_na: Replace Missing Values in a Character Vector

## Description

This function gives a convenient way to replace each missing (`NA`) value with a given string.

## Usage

```r
stri_replace_na(str, replacement = "NA")
```

## Arguments

|               |                                            |
|---------------|--------------------------------------------|
| `str`         | character vector or an object coercible to |
| `replacement` | single string                              |

## Details

This function is roughly equivalent to `str2 <- stri_enc_toutf8(str); str2[is.na(str2)] <- stri_enc_toutf8(replacement); str2`. It may be used, e.g., wherever the \'plain R\' `NA` handling is desired, see Examples.

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other utils: [`stri_list2matrix()`,](stri_list2matrix.md) [`stri_na2empty()`,](stri_na2empty.md) `stri_remove_empty()`

## Examples




```r
x <- c('test', NA)
stri_paste(x, 1:2)                           # 'test1' NA
## [1] "test1" NA
paste(x, 1:2)                                # 'test 1' 'NA 2'
## [1] "test 1" "NA 2"
stri_paste(stri_replace_na(x), 1:2, sep=' ') # 'test 1' 'NA 2'
## [1] "test 1" "NA 2"
```
