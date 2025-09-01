library("tinytest")
library("stringi")

# From https://github.com/tidyverse/stringr/issues/575

x <- c(A = "3", B = "2", C = "1")
expect_equal(stri_sort(x), c(C = "1", B = "2", A = "3"))
expect_equal(stri_replace_all_fixed(x, "2", "0"), c(A = "3", B = "0", C = "1"))

