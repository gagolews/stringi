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
   
   expect_equivalent(stri_tolower("\u0105\u0104", "pl_PL"), "\u0105\u0105")
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
   
   expect_equivalent(stri_toupper("\u0105\u0104", "pl_PL"), "\u0104\u0104")
   
   expect_equivalent(stri_toupper("\u00DF", "de_DE"), "SS")
   expect_equivalent(stri_toupper("i", "en_US"), "I")
   expect_equivalent(stri_toupper("i", "tr_TR"), "\u0130")
})




test_that("stri_totitle", {
   
   # basic tests (ASCII, border-line):
   expect_equivalent(stri_totitle(character(0)), character(0))
   expect_equivalent(stri_totitle(""), "")
   expect_equivalent(stri_totitle(NA), NA_character_)
   
   expect_equivalent(stri_totitle(c("!@#aAbBcC123", NA, "")), c("!@#Aabbcc123", NA, ""))
   
   ascii_non_letters <- rawToChar(as.raw(c(1:64, 91:96, 123:127)))
   expect_equivalent(stri_toupper(ascii_non_letters), ascii_non_letters)
   expect_equivalent(stri_totitle(letters), LETTERS)
   expect_equivalent(stri_totitle(stri_flatten(letters)), stri_flatten(c("A",letters[-1])))
   
   expect_equivalent(stri_totitle("\u0105\u0104", "pl_PL"), "\u0104\u0105")
   
   expect_equivalent(stri_totitle("ala   ma   kota"), "Ala   Ma   Kota")
})
