library("tinytest")
library("stringi")


expect_equivalent(stri_trans_general(character(0), "latin-ascii"), character(0))
expect_equivalent(stri_trans_general("", "latin-ascii"), "")
expect_equivalent(stri_trans_general("", NA), NA_character_)
expect_error(stri_trans_general("", "sagsgsdgsdhrherj48iur"))

expect_equivalent(stri_trans_general(c("groß", NA, ""), "latin-ascii"), c("gross",
    NA, ""))

expect_equivalent(stri_trans_general("ąĄ", "lower"), "ąą")


expect_true(is.character(stri_trans_list()))
expect_true(length(stri_trans_list()) > 0)
expect_true("ASCII-Latin" %in% stri_trans_list())
