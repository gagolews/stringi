# TO DO:


x <- stri_dup("A", 1:1000)
y <- stri_dup("B", 1:1000)

print(benchmark(
   z1 <- str_join(x, y),
   z2 <- x %+% y
))

expect_that(z2, is_identical_to(z1))

print(benchmark(
   z1 <- str_join(x, y, y),
   z2 <- x %+% y %+% y
))

expect_that(z2, is_identical_to(z1))


print(benchmark(
   z1 <- str_join(x[1], y),
   z2 <- x[1] %+% y
))

expect_that(z2, is_identical_to(z1))


print(benchmark(
   z1 <- str_join(x[length(x)], y),
   z2 <- x[length(x)] %+% y
))

expect_that(z2, is_identical_to(z1))


print(benchmark(
   z1 <- str_join(x, y[length(y)]),
   z2 <- x %+% y[length(y)]
))

expect_that(z2, is_identical_to(z1))

