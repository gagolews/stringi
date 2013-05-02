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


x <- stri_dup("A", 100)

print(microbenchmark(
   stri_dup(x, 1:100),
   str_dup(x, 1:100)
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

