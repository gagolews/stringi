require("microbenchmark")
require("rbenchmark")
require("stringr")


#########################################################################

print(microbenchmark(
   stri_dup("A", 1:100),
   str_dup("A", 1:100)
))

print(microbenchmark(
   stri_dup(LETTERS, 100),
   str_dup(LETTERS, 100)
))

x <- stri_dup("\u0105\u0104", 100)
print(microbenchmark(
   stri_dup(x, 1:100),
   str_dup(x, 1:100)
))

x <- "\u0105\u0104"
print(microbenchmark(
   stri_dup(x, 500:1), # linear time!
   str_dup(x, 500:1)   # quadratic time!
))

#########################################################################

print(microbenchmark(
   stri_flatten(LETTERS),
   paste(LETTERS, collapse="")
))

x <- stri_dup(LETTERS, 100)
print(microbenchmark(
   stri_flatten(x),
   paste(x, collapse="")
))

x <- rep(stri_dup(c('\u0105', '\u0104'), 100), 100)
print(microbenchmark(
   stri_flatten(x),
   paste(x, collapse="")
))

print(microbenchmark(
   stri_flatten(LETTERS, sep=" "),
   paste(LETTERS, collapse=" ")
))



# TEMP: 2013-05-17 results [MG]

# Unit: microseconds
# expr   min     lq median    uq    max neval
# stri_flatten(LETTERS) 2.513 2.8320 3.0385 3.291 31.987   100
# paste(LETTERS, collapse = "") 7.541 8.0055 8.3435 8.674 33.085   100

# Unit: microseconds
# expr    min      lq  median      uq    max neval
# stri_flatten(x) 10.163 10.8305 11.1175 11.4000 39.497   100
# paste(x, collapse = "") 31.025 31.6255 32.1350 32.6245 61.201   100

# Unit: microseconds
# expr     min      lq   median       uq      max neval
# stri_flatten(x) 122.578 123.713 124.4225 128.0375 1693.094   100
# paste(x, collapse = "") 313.440 317.124 319.8070 343.7260  678.916   100

# Unit: microseconds
# expr   min     lq median     uq    max neval
# stri_flatten(LETTERS, sep = " ") 2.668 3.0065 3.2645 3.5430 28.031   100
# paste(LETTERS, collapse = " ") 7.577 8.2895 8.6340 8.9975 32.143   100

#########################################################################



x <- stri_dup("A", 1:1000)
y <- stri_dup("B", 1:1000)

print(microbenchmark(
   z1 <- paste(x, y, sep=""),
   z2 <- x %+% y
))

expect_that(z2, is_identical_to(z1))

print(benchmark(
   z1 <- paste(x, y, y, sep=""),
   z2 <- x %+% y %+% y
))

expect_that(z2, is_identical_to(z1))


print(microbenchmark(
   z1 <- paste(x[1], y, sep=""),
   z2 <- x[1] %+% y
))

expect_that(z2, is_identical_to(z1))


print(microbenchmark(
   z1 <- paste(x[length(x)], y, sep=""),
   z2 <- x[length(x)] %+% y
))

expect_that(z2, is_identical_to(z1))


print(microbenchmark(
   z1 <- paste(x, y[length(y)], sep=""),
   z2 <- x %+% y[length(y)]
))

expect_that(z2, is_identical_to(z1))

