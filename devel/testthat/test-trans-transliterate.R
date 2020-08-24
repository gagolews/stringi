require(testthat)
context("test-trans-transliterate.R")

test_that("stri_trans_general", {
    
    expect_equivalent(stri_trans_general(character(0), "latin-ascii"), character(0))
    expect_equivalent(stri_trans_general("", "latin-ascii"), "")
    expect_equivalent(stri_trans_general("", NA), NA_character_)
    expect_error(str_trans_general("", "sagsgsdgsdhrherj48iur"))
    
    expect_equivalent(stri_trans_general(c("groß", NA, ""), "latin-ascii"), c("gross", 
        NA, ""))
    
    expect_equivalent(stri_trans_general("ąĄ", "lower"), "ąą")
})



test_that("stri_trans_list", {
    
    expect_true(is.character(stri_trans_list()))
    expect_true(length(stri_trans_list()) > 0)
    expect_true("ASCII-Latin" %in% stri_trans_list())
    
})
