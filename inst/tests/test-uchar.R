# require(testthat)
# 
# test_that("stri_chartype", {
#    expect_equivalent(stri_chartype(character(0)), NULL)
#    expect_equivalent(stri_chartype(c("", NA_character_)),
#                      list(integer(0), NA_integer_))
#    expect_equivalent(stri_chartype("aA0")[[1]],
#                      c(2L, 1L, 9L))
#    expect_equivalent(stri_chartype("ABC123abc\u104\u105\n")[[1]],
#                      c(1L, 1L, 1L, 9L, 9L, 9L, 2L, 2L, 2L, 1L, 2L, 15))
# })
# 
# 
# 
# test_that("stri_charcategories", {
#    categories <- stri_charcategories()
#    expect_equivalent(nrow(categories), 29)
#    expect_equivalent(ncol(categories), 2)
#    expect_equivalent(categories$Category[1], "Lu")
#    expect_equivalent(categories$Category[2], "Ll")
# })
