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

x <- rep(stri_dup(c('\u0105', '\u0104'), 1000), 100)
print(microbenchmark(
   stri_flatten(x),
   paste(x, collapse="")
))

print(microbenchmark(
   stri_flatten(x, collapse=" "),
   paste(x, collapse=" ")
))


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


###############################################################################

print(microbenchmark(
   stri_join(LETTERS, letters, sep='!', collapse='?'),
   paste(LETTERS, letters, sep='!', collapse='?')
))


print(microbenchmark(
   stri_join(LETTERS, letters, sep=''),
   paste(LETTERS, letters, sep='')
))


x <- stri_dup("A", 1:1000)
y <- stri_dup("B", 1:1000)
print(microbenchmark(
   stri_join(x, y, sep=''),
   paste(x, y, sep='')
))


print(microbenchmark(
   stri_join(x, y, sep='', collapse='?'),
   paste(x, y, sep='', collapse='?')
))

z <- stri_dup('\u0105', 1000)
print(microbenchmark(
   stri_join(z, y, sep=''),
   paste(z, y, sep='')
))

print(microbenchmark(
   stri_join(y, z, sep=''),
   paste(y, z, sep='')
))
