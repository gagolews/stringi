require(testthat)

test_that("stri_tolower", {

   # basic tests (ASCII, border-line):
   
   expect_equivalent(stri_tolower(character(0)), character(0))
   expect_equivalent(stri_tolower(""), "")
   expect_equivalent(stri_tolower(NA), NA_character_)
      
   expect_equivalent(stri_tolower(c("!@#aAbBcC123", NA, "")), c("!@#aabbcc123", NA, ""))
   expect_equivalent(stri_flatten(stri_tolower(LETTERS)), stri_flatten(letters))
   expect_equivalent(stri_tolower(LETTERS), letters) # vectors of length 26
   expect_equivalent(stri_tolower(letters), letters) # vectors of length 26
   
   ascii_non_letters <- rawToChar(as.raw(c(1:64, 91:96, 123:127)))
   expect_equivalent(stri_tolower(ascii_non_letters), ascii_non_letters)
})



test_that("stri_toupper", {

   # basic tests (ASCII, border-line):
   expect_equivalent(stri_toupper(character(0)), character(0))
   expect_equivalent(stri_toupper(""), "")
   expect_equivalent(stri_toupper(NA), NA_character_)
   
   expect_equivalent(stri_toupper(c("!@#aAbBcC123", NA, "")), c("!@#AABBCC123", NA, ""))
   expect_equivalent(stri_flatten(stri_toupper(letters)), stri_flatten(LETTERS))
   expect_equivalent(stri_toupper(LETTERS), LETTERS) # vectors of length 26
   expect_equivalent(stri_toupper(letters), LETTERS) # vectors of length 26
   
   ascii_non_letters <- rawToChar(as.raw(c(1:64, 91:96, 123:127)))
   expect_equivalent(stri_toupper(ascii_non_letters), ascii_non_letters)
})
