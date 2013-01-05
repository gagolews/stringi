require("testthat")
require("stringr")
require("rbenchmark")

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

test_that("%+%", {
   expect_that("A" %+% NA, is_equivalent_to(NA_character_))
   expect_that(NA %+% "B", is_equivalent_to(NA_character_))
   expect_that("A" %+% "B", is_equivalent_to("AB"))
   expect_that("A" %+% character(0), is_equivalent_to("A"))
   expect_that("A" %+% c("A", "B", "C"), is_equivalent_to(c("AA", "AB", "AC")))
})

