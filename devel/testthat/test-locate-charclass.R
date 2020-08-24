require(testthat)
context("test-locate-charclass.R")

test_that("stri_locate_all_charclass", {
    
    expect_is(stri_locate_all_charclass(character(0), "\\p{Z}"), "list")
    expect_error(stri_locate_all_charclass(c("", ""), 1))
    
    expect_equivalent(stri_locate_all_charclass(character(0), "\\p{Z}"), list())
    expect_equivalent(stri_locate_all_charclass(LETTERS, character(0)), list())
    
    expect_equivalent(as.integer(stri_locate_all_charclass("", "\\P{WHITE_SPACE}")[[1]]), 
        c(NA_integer_, NA_integer_))
    
    expect_equivalent(as.integer(stri_locate_all_charclass("", NA)[[1]]), c(NA_integer_, 
        NA_integer_))
    
    expect_equivalent(as.integer(stri_locate_all_charclass(NA, "[a-z]")[[1]]), c(NA_integer_, 
        NA_integer_))
    expect_equivalent(as.integer(stri_locate_all_charclass("?", "[a-z]")[[1]]), c(NA_integer_, 
        NA_integer_))
    expect_equivalent(as.integer(stri_locate_all_charclass("?", "[a-z]", omit_no_match = TRUE)[[1]]), 
        integer(0))
    
    expect_error(stri_locate_all_charclass("", "\\P{WHITE_SPACE}", NA))
    
    expect_equivalent(as.integer(stri_locate_all_charclass(NA, "\\P{WHITE_SPACE}")[[1]]), 
        c(NA_integer_, NA_integer_))
    
    expect_equivalent(lapply(stri_locate_all_charclass(c("abc", "aąb", "a1B2c3", 
        "1ą2b3C", "123"), "\\p{L}", merge = TRUE), as.integer), list(c(1L, 3L), 
        c(1L, 3L), c(1L, 3L, 5L, 1L, 3L, 5L), c(2L, 4L, 6L, 2L, 4L, 6L), c(NA_integer_, 
            NA_integer_)))
    
    expect_equivalent(lapply(stri_locate_all_charclass(c("abc", "aąb", "a1B2c3", 
        "1ą2b3C", "123"), "\\p{L}", merge = FALSE), function(x) as.integer(x[, 1])), 
        list(c(1L, 2L, 3L), c(1L, 2L, 3L), c(1L, 3L, 5L), c(2L, 4L, 6L), c(NA_integer_)))
    
    expect_equivalent(lapply(stri_locate_all_charclass(c("abc", "aąb", "a1B2c3", 
        "1ą2b3C", "123"), ("\\P{L}"), merge = TRUE), as.integer), list(c(NA_integer_, 
        NA_integer_), c(NA_integer_, NA_integer_), c(2L, 4L, 6L, 2L, 4L, 6L), c(1L, 
        3L, 5L, 1L, 3L, 5L), c(1L, 3L)))
    
    expect_equivalent(as.integer(stri_locate_all_charclass("    xxx\n\t \v   \n", 
        ("\\p{WHITE_SPACE}"), merge = TRUE)[[1]]), c(1L, 8L, 4L, 15L))
    
    expect_equivalent(as.integer(stri_locate_all_charclass("    xxx\n\t \v   \n", 
        ("\\P{WHITE_SPACE}"), merge = TRUE)[[1]]), c(5, 7))
})



test_that("stri_locate_first_charclass", {
    
    expect_is(stri_locate_first_charclass(character(0), "\\P{WHITE_SPACE}"), "matrix")
    
    expect_equivalent(as.integer(stri_locate_first_charclass("", ("\\P{WHITE_SPACE}"))), 
        c(NA_integer_, NA_integer_))
    expect_equivalent(as.integer(stri_locate_first_charclass(NA, ("\\P{WHITE_SPACE}"))), 
        c(NA_integer_, NA_integer_))
    
    expect_equivalent(stri_locate_first_charclass(c("abc", "5ąbc", "a1B2c3", "1ą2b3C", 
        "123"), ("\\p{L}"))[, 1], c(1L, 2L, 1L, 2L, NA_integer_))
    
    expect_equivalent(stri_locate_first_charclass("abc", c("\\p{L}", "\\p{Z}", "\\p{P}"))[, 
        1], c(1L, NA_integer_, NA_integer_))
    
    expect_equivalent(stri_locate_first_charclass("    xxx\n\t \v   \n", c(("\\p{WHITE_SPACE}"), 
        ("\\P{WHITE_SPACE}")))[, 2], c(1L, 5L))
})


test_that("stri_locate_last_charclass", {
    
    expect_is(stri_locate_last_charclass(character(0), ("\\P{WHITE_SPACE}")), "matrix")
    
    expect_equivalent(stri_locate_last_charclass("", ("\\P{WHITE_SPACE}"))[, 2], 
        NA_integer_)
    expect_equivalent(stri_locate_last_charclass(NA, ("\\P{WHITE_SPACE}"))[, 2], 
        NA_integer_)
    
    expect_equivalent(stri_locate_last_charclass("abc", c("\\p{L}", "\\p{Z}", "\\p{P}"))[, 
        1], c(3L, NA_integer_, NA_integer_))
    
    expect_equivalent(stri_locate_last_charclass(c("abc", "5ąbc", "a1B2c3", "1ą2b3C", 
        "123"), ("\\p{L}"))[, 2], c(3L, 4L, 5L, 6L, NA_integer_))
    
    expect_equivalent(stri_locate_last_charclass("    xxx\n\t \v   \n", c(("\\p{WHITE_SPACE}"), 
        ("\\P{WHITE_SPACE}")))[, 2], c(15L, 7L))
})
