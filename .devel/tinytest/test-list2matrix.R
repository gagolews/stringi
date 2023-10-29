library("tinytest")
library("stringi")



expect_identical(stri_list2matrix(list(c("a", "b"), c("c", "d"), c("e", "f"))),
    simplify2array(list(c("a", "b"), c("c", "d"), c("e", "f"))))

expect_identical(stri_list2matrix(list(c("a", "b"), c("c", "d"), c("e", "f")),
    n_min = 1), simplify2array(list(c("a", "b"), c("c", "d"), c("e", "f"))))

expect_identical(stri_list2matrix(list(c("a", "b"), c("c", "d"), c("e", "f")),
    byrow = TRUE), t(simplify2array(list(c("a", "b"), c("c", "d"), c("e", "f")))))

expect_identical(stri_list2matrix(list("a", c("b", "c"))), matrix(c("a", NA,
    "b", "c"), ncol = 2))

expect_identical(stri_list2matrix(list("a", c("b", "c")), fill = ""), matrix(c("a",
    "", "b", "c"), ncol = 2))

expect_identical(stri_list2matrix(list("a", c("b", "c")), fill = "", n_min = 3),
    matrix(c("a", "", "", "b", "c", ""), ncol = 2))

expect_identical(stri_list2matrix(list()), structure(character(0), dim = c(0,
    0)))
expect_identical(stri_list2matrix(list(character(0), character(0))), structure(character(0),
    dim = c(0, 2)))
expect_error(stri_list2matrix(list(LETTERS, mean, letters)))
