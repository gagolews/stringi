# operator\_add: Concatenate Two Character Vectors

## Description

Binary operators for joining (concatenating) two character vectors, with a typical R look-and-feel.

## Usage

```r
e1 %s+% e2

e1 %stri+% e2
```

## Arguments

|      |                                                                 |
|------|-----------------------------------------------------------------|
| `e1` | a character vector or an object coercible to a character vector |
| `e2` | a character vector or an object coercible to a character vector |

## Details

Vectorized over `e1` and `e2`.

These operators act like a call to [`stri_join(e1, e2, sep='')`](stri_join.md). However, note that joining 3 vectors, e.g., `e1 %s+% e2 %s+% e3` is slower than [`stri_join(e1, e2, e3, sep='')`](stri_join.md), because it creates a new (temporary) result vector each time the operator is applied.

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other join: [`stri_dup()`](stri_dup.md), [`stri_flatten()`](stri_flatten.md), [`stri_join_list()`](stri_join_list.md), [`stri_join()`](stri_join.md)

## Examples




```r
c('abc', '123', 'xy') %s+% letters[1:6]
## [1] "abca" "123b" "xyc"  "abcd" "123e" "xyf"
'ID_' %s+% 1:5
## [1] "ID_1" "ID_2" "ID_3" "ID_4" "ID_5"
```
