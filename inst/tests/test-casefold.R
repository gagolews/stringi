require("testthat")
require("rbenchmark")

x <- stri_dup("AaBbCc", 1:1000)

benchmark(
   y1 <- tolower(x),
   y2 <- stri_tolower(x)
)

expect_that(y2, is_identical_to(y1))


benchmark(
   y1 <- toupper(x),
   y2 <- stri_toupper(x)
)

expect_that(y2, is_identical_to(y1))
