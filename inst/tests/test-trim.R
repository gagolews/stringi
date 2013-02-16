require(testthat)
require(stringr)

test_that("stri_trim", {
  
   # basic tests (ASCII, border-line):
   expect_equivalent(stri_trim(character(0)), character(0))
   expect_equivalent(stri_trim(NA), NA_character_)
   
   expect_equivalent(stri_trim("      "), "")
   expect_equivalent(stri_trim(" \tA  "), "A")
   expect_equivalent(stri_trim("A \t\n"), "A")
   expect_equivalent(stri_trim("     A"), "A")
   
   expect_equivalent(stri_trim(LETTERS), LETTERS)
   
   expect_equivalent(stri_trim(stri_dup(" ", 1:100)), rep("", 100))
})

test_that("stri_ltrim", {
   
   # basic tests (ASCII, border-line):
   expect_equivalent(stri_ltrim(character(0)), character(0))
   expect_equivalent(stri_ltrim(NA), NA_character_)
   
   expect_equivalent(stri_ltrim("      "), "")
   expect_equivalent(stri_ltrim("   A  "), "A  ")
   expect_equivalent(stri_ltrim("A     "), "A     ")
   expect_equivalent(stri_ltrim("     A"), "A")
   
   expect_equivalent(stri_ltrim(LETTERS), LETTERS)
   
   expect_equivalent(stri_ltrim(stri_dup(" ", 1:100)), rep("", 100))
})

test_that("stri_rtrim", {
   
   # basic tests (ASCII, border-line):
   expect_equivalent(stri_rtrim(character(0)), character(0))
   expect_equivalent(stri_rtrim(NA), NA_character_)
   
   expect_equivalent(stri_rtrim("      "), "")
   expect_equivalent(stri_rtrim("   A  "), "   A")
   expect_equivalent(stri_rtrim("A     "), "A")
   expect_equivalent(stri_rtrim("     A"), "     A")
   
   expect_equivalent(stri_rtrim(LETTERS), LETTERS)
   
   expect_equivalent(stri_rtrim(stri_dup(" ", 1:100)), rep("", 100))
})

test_that("stri_trim_all", {
   
   # basic tests (ASCII, border-line):
   expect_equivalent(stri_trim_all(character(0)), character(0))
   expect_equivalent(stri_trim_all(NA), NA_character_)
   expect_equivalent(stri_trim_all(""),"")
   expect_equivalent(stri_trim_all("      "), "")
   expect_equivalent(stri_trim_all("   A  "), "A")
   expect_equivalent(stri_trim_all(" A A  A   A  "), "A A A A")
 
   expect_equivalent(stri_trim_all(LETTERS), LETTERS)
 
   expect_equivalent(stri_trim_all(stri_dup(" ", 1:100)), rep("", 100))
   s <- stri_flatten(LETTERS%+%stri_dup(" ",1:26))
   expect_equivalent(stri_trim_all(s),stri_flatten(LETTERS," "))
})

test_that("stri_pad", {
   #vectorized over str
   expect_identical(stri_pad(letters,20),str_pad(letters,20))
   #vectorized over side
   expect_identical(stri_pad("ala",9,c("l","r","b")),
                    c(str_pad("ala",9,"l"),str_pad("ala",9,"r"),str_pad("ala",9,"b")))
   #vectorized over width
   expect_identical(stri_pad("ala",6:8),
                    c(str_pad("ala",6),str_pad("ala",7),str_pad("ala",8)))
   expect_identical(stri_pad(c("abc",NA),5),c("  abc",NA))   
   
   test <- paste(stri_dup(letters, 1:2600), "A", stri_dup(" ", 1:2600), sep="")
   
   expect_identical(str_pad(test,150), stri_pad(test,150))
})
