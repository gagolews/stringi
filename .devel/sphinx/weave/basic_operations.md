

(Sec:basic)=
Basic String Operations
=======================


> This tutorial is based on the [paper on *stringi*](https://dx.doi.org/10.18637/jss.v103.i02) that was published in the *Journal of Statistical Software*; see {cite}`stringi`. To learn more about R, check out Marek's open-access (free!) textbook [*Deep R Programming*](https://deepr.gagolewski.com/) {cite}`deepr`.



Computing Length and Width
--------------------------

First, we shall review the functions related to determining the number of
entities in each string.

Let's consider the following character vector:



```r
x <- c("spam", "你好", "\u200b\u200b\u200b", NA_character_, "")
```

The `x` object consists of 5 character strings:



```r
length(x)
## [1] 5
```

`stri_length()` computes the length of each string. More precisely, the
function gives the number of Unicode code points in each string, see
{ref}`Sec:codepoints` for more details.



```r
stri_length(x)
## [1]  4  2  3 NA  0
```

The first string carries 4 ASCII (English) letters, the second consists
of 2 Chinese characters (U+4F60, U+597D; a greeting), and the third one
is comprised of 3 zero-width spaces (U+200B). Note that the 5th element
in `x` is an empty string, `""`. Hence, its length is 0. Moreover, there
is a missing (`NA`) value at index 4. Therefore, the corresponding length
is undefined as well.

When formatting strings for display (e.g., in a report dynamically
generated with `Sweave()` or
[*knitr*](https://yihui.org/knitr/) {cite}`knitr`), a string's width
estimate may be more informative -- an approximate number of text
columns it will occupy when printed using a monospaced font. In
particular, many Chinese, Japanese, Korean, and most emoji characters
take up two text cells. On the other hand,
some code points might be of width 0 (e.g., the said ZERO WIDTH SPACE, U+200B).



```r
stri_width(x)
## [1]  4  4  0 NA  0
```

Joining
-------

Below we describe the functions that are related to string
concatenation.


### Operator `%s+%`

To join the corresponding strings in two character vectors, we may use
the binary `%s+%` operator:



```r
x <- c("tasty", "delicious", "yummy", NA)
x %s+% " " %s+% c("spam", "bacon")
## [1] "tasty spam"      "delicious bacon" "yummy spam"      NA
```



### Flattening

The elements in a character vector can be joined ("aggregated") to form
a single string via a call to `stri_flatten()`:



```r
stri_flatten(stri_omit_na(x), collapse=", ")
## [1] "tasty, delicious, yummy"
```

Note that the token separator, given by the `collapse` argument,
defaults to the empty string.


### Generalisation

Both the `%s+%` operator and the `stri_flatten()` function are
generalised by `stri_join()` (alias: `stri_paste()`, `stri_c()`):



```r
stri_join(c("X", "Y", "Z"), 1:6, "a")  # sep="", collapse=NULL
## [1] "X1a" "Y2a" "Z3a" "X4a" "Y5a" "Z6a"
```

By default, the `sep` argument, which controls how corresponding strings
are delimited, is set to the empty string (like in the base `paste0()`
but unlike in `paste()`). Moreover, `collapse` is `NULL`, which means
that the resulting outputs will not be joined to form a single string.
This can be changed if need be:



```r
stri_join(c("X", "Y", "Z"), 1:6, "a", sep="_", collapse=", ")
## [1] "X_1_a, Y_2_a, Z_3_a, X_4_a, Y_5_a, Z_6_a"
```

Note how the two (1st, 3rd) shorter vectors were recycled to match the
longest (2nd) vector's length. The latter was of numeric type, but it
was implicitly coerced via a call to `as.character()`.

More examples:



```r
pythons <- c("Graham Chapman", "John Cleese", "Terry Gilliam",
  "Eric Idle", "Terry Jones", "Michael Palin")
(pythons <- stri_split_fixed(pythons, " ", simplify=TRUE))
##      [,1]      [,2]     
## [1,] "Graham"  "Chapman"
## [2,] "John"    "Cleese" 
## [3,] "Terry"   "Gilliam"
## [4,] "Eric"    "Idle"   
## [5,] "Terry"   "Jones"  
## [6,] "Michael" "Palin"
stri_join(pythons[, 2], pythons[, 1], sep=", ")
## [1] "Chapman, Graham" "Cleese, John"    "Gilliam, Terry"  "Idle, Eric"     
## [5] "Jones, Terry"    "Palin, Michael"
outer(LETTERS[1:3], 1:5, stri_join, sep=".")  # outer product
##      [,1]  [,2]  [,3]  [,4]  [,5] 
## [1,] "A.1" "A.2" "A.3" "A.4" "A.5"
## [2,] "B.1" "B.2" "B.3" "B.4" "B.5"
## [3,] "C.1" "C.2" "C.3" "C.4" "C.5"
```


### Duplicating

To duplicate given strings, we call `stri_dup()` or the `%s*%` operator:



```r
stri_dup(letters[1:5], 1:5)
## [1] "a"     "bb"    "ccc"   "dddd"  "eeeee"
```

The above is synonymous with `letters[1:5] %s*% 1:5`.


### Within-List Joining

There is also a convenience function that applies `stri_flatten()` on
each character vector in a given list:



```r
words <- list(c("spam", "bacon", "sausage", "spam"), c("eggs", "spam"))
stri_join_list(words, sep=", ")  # collapse=NULL
## [1] "spam, bacon, sausage, spam" "eggs, spam"
stri_join_list(words, sep=", ", collapse=";\n")
## [1] "spam, bacon, sausage, spam;\neggs, spam"
```

This way, a list of character vectors can be converted to a character
vector. Such sequences of variable length sequences of strings are
generated by, amongst others, `stri_sub_all()` and `stri_extract_all()`.



Extracting and Replacing Substrings
-----------------------------------

The next group of functions deals with the extraction and replacement of
particular sequences of code points in given strings.


### Indexing Vectors

To select a subsequence from any R vector, we use
the square-bracket operator[^footsubset] with an index vector consisting of
either non-negative integers, negative integers, or logical values[^footnames].

[^footsubset]: More precisely, `x[i]` is a syntactic sugar for a call to
    `‘[‘(x, i)`. Moreover, if `x` is a list, `x[[i]]` can be used to
    extract its `i`-th element (alias `‘[[‘(x, i)`). Knowing the
    "functional" form of the operators allows us to, for instance,
    extract all first elements from each vector in a list by simply
    calling `sapply(x, "[[", 1)`.

[^footnames]: If an object's `names` attribute is set, indexing with a character
    vector is also possible.

For example, here is how to select specific elements in a vector:



```r
x <- c("spam", "buckwheat", "", NA, "bacon")
x[1:3]                           # from 1st to 3rd string
## [1] "spam"      "buckwheat" ""
x[c(1, length(x))]               # 1st and last
## [1] "spam"  "bacon"
```

Exclusion of elements at specific positions can be performed like:



```r
x[-1]                            # all but 1st
## [1] "buckwheat" ""          NA          "bacon"
```

Filtering based on a logical vector can be used to extract strings
fulfilling desired criteria:



```r
x[!stri_isempty(x) & !is.na(x)]
## [1] "spam"      "buckwheat" "bacon"
```


### Extracting Substrings

A character vector is, in its very essence, a sequence of sequences
of code points. To extract specific substrings from each string in a
collection, we can use the `stri_sub()` function.



```r
y <- "spam, egg, spam, spam, bacon, and spam"
stri_sub(y, 18)             # from 18th code point to end
## [1] "spam, bacon, and spam"
stri_sub(y, 12, to=15)      # from 12th to 15th code point (inclusive)
## [1] "spam"
```

Negative indices count from the end of a string.



```r
stri_sub(y, -15, length=5)  # 5 code points from 15th last
## [1] "bacon"
```



### `stri_sub_all()` Function

If some deeper vectorisation level is necessary, `stri_sub_all()` comes
in handy. It extracts multiple (possibly different) substrings from all
the strings provided:



```r
(z <- stri_sub_all(
              c("spam",     "bacon", "sorghum"),
  from   = list(c(1, 3, 4), -3,      c(2, 4)),
  length = list(1,           3,      c(4, 3))))
## [[1]]
## [1] "s" "a" "m"
## 
## [[2]]
## [1] "con"
## 
## [[3]]
## [1] "orgh" "ghu"
```

As the number of substrings to extract from each string might vary, the
result is a list of character strings. We have obtained: substrings of
length 1 starting at positions 1, 3, and 4 in `x[1]`, then a length-3
substring that starts at the 3rd code point from the end of `x[2]`, and
length-4 and -3 substrings starting at, respectively, the 2nd and 4th
code point of `x[3]` (where `x` denotes the subsetted vector).

Recall that the strings may all be concatenated by means of the
aforementioned `stri_join_list()` function.



```r
stri_join_list(z, sep=", ")
## [1] "s, a, m"   "con"       "orgh, ghu"
```

There is also a more flexible version of the built-in `simplify2array()`
function whose aim is to convert such lists to matrices.



```r
stri_list2matrix(z, by_row=TRUE, fill="", n_min=5)
##      [,1]   [,2]  [,3] [,4] [,5]
## [1,] "s"    "a"   "m"  ""   ""  
## [2,] "con"  ""    ""   ""   ""  
## [3,] "orgh" "ghu" ""   ""   ""
```



### "From--To" and "From--Length" Matrices

The second parameter of both `stri_sub()` and `stri_sub_list()` can also
be fed with a two-column matrix of the form `cbind(from, to)`. Here, the
first column gives the start indices, and the second column defines the
end ones. Such matrices are generated, amongst others, by the
`stri_locate_()` functions (see below for details).



```r
(from_to <- cbind(from=c(1, 12, 18), to=c(4, 15, 21))) # +optional labels
##      from to
## [1,]    1  4
## [2,]   12 15
## [3,]   18 21
stri_sub(y, from_to)
## [1] "spam" "spam" "spam"
```

Another example (the recycling rule):



```r
(from_to <- matrix(1:8, ncol=2, byrow=TRUE))
##      [,1] [,2]
## [1,]    1    2
## [2,]    3    4
## [3,]    5    6
## [4,]    7    8
stri_sub(c("abcdefgh", "ijklmnop"), from_to)
## [1] "ab" "kl" "ef" "op"
```

Due to recycling, this has extracted elements at positions 1:2 from the
1st string, at 3:4 from the 2nd one, 5:6 from the 1st, and 7:8 from the
2nd again.

Note the difference between the above output and the following one:



```r
stri_sub_all(c("abcdefgh", "ijklmnop"), from_to)
## [[1]]
## [1] "ab" "cd" "ef" "gh"
## 
## [[2]]
## [1] "ij" "kl" "mn" "op"
```

This time, we extract four identical sections from the two
inputs.

Moreover, if the second column of the index matrix is named `"length"`
(and only if this is the case), i.e., the indexer is of the form
`cbind(from, length=length)`, extraction will be based on the extracted
chunk size.


### Permuting Code Points

Somewhat related to the above are different ways to construct various
permutations (possibly with replacement) of code points in a string:



```r
stri_join_list(stri_sub_all("spam", c(4, 3, 2, 3, 1), length=1))
## [1] "mapas"
stri_rand_shuffle("bacon")  # random order
## [1] "anobc"
stri_reverse("spam")        # reverse order
## [1] "maps"
```


### Replacing Substrings

`stri_sub_replace()` returns a version of a character vector with some
chunks replaced by other strings:



```r
stri_sub_replace(c("abcde", "ABCDE"),
  from=c(2, 4), length=c(1, 2), replacement=c("X", "uvw"))
## [1] "aXcde"  "ABCuvw"
```

The above replaced "`b`" (the length-1 substring starting at index 2 of
the 1st string) with "`X`" and "`DE`" (the length-2 substring at index 4
of the 2nd string) with "`uvw`".

Similarly, `stri_sub_replace_all()` replaces multiple substrings within
each string in a character vector:



```r
stri_sub_replace_all(
                   c("abcde",  "ABCDE"),
  from        = list(c(2, 4),  c(0,    3,   6)),
  length      = list(  1,      c(0,    2,   0)),
  replacement = list(  "Z",    c("uu", "v", "wwww")))
## [1] "aZcZe"      "uuABvEwwww"
```

Note how we have obtained the insertion of new content at the start and
the end of the 2nd input.



### Replacing Substrings In-Place

The corresponding replacement functions modify a character vector
in-place:



```r
y <- "spam, egg, spam, spam, bacon, and spam"
stri_sub(y, 7, length=3) <- "spam"  # in-place replacement, egg → spam
print(y)                            # y has changed
## [1] "spam, spam, spam, spam, bacon, and spam"
```

Note that the state of `y` has changed so that the substring
of length 3 starting at the 7th code point was replaced by a length-4
content.

Many replacements within a single string are also possible:



```r
y <- "aa bb cc"
stri_sub_all(y, c(1, 4, 7), length=2) <- c("A", "BB", "CCC")
print(y)                            # y has changed
## [1] "A BB CCC"
```

This has replaced 3 length-2 chunks within `y` with new content.
