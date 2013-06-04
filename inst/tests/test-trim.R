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
   expect_equivalent(stri_trim(" \t"),"")
   expect_equivalent(stri_trim("\n"),"")
   expect_equivalent(stri_trim(" \t ą \n "),"ą")
   
   expect_equivalent(stri_trim(LETTERS), LETTERS)
   
   expect_equivalent(stri_trim(stri_dup(" ", 1:100)), rep("", 100))
})

test_that("stri_ltrim", {
   
   # basic tests (ASCII, border-line):
   expect_equivalent(stri_ltrim(character(0)), character(0))
   expect_equivalent(stri_ltrim(NA), NA_character_)
   
   expect_equivalent(stri_ltrim("      "), "")
   expect_equivalent(stri_ltrim("   \n A  "), "A  ")
   expect_equivalent(stri_ltrim("A     "), "A     ")
   expect_equivalent(stri_ltrim("     A"), "A")
   expect_equivalent(stri_ltrim(" \t"), "")
   expect_equivalent(stri_ltrim("\n"), "")
   expect_equivalent(stri_ltrim(" \t ą \n "),"ą \n ")
   
   expect_equivalent(stri_ltrim(LETTERS), LETTERS)
   
   expect_equivalent(stri_ltrim(stri_dup(" ", 1:100)), rep("", 100))
})

test_that("stri_rtrim", {
   
   # basic tests (ASCII, border-line):
   expect_equivalent(stri_rtrim(character(0)), character(0))
   expect_equivalent(stri_rtrim(NA), NA_character_)
   
   expect_equivalent(stri_rtrim("      "), "")
   expect_equivalent(stri_rtrim("   A \t "), "   A")
   expect_equivalent(stri_rtrim("A  \n   "), "A")
   expect_equivalent(stri_rtrim("    \n A"), "    \n A")
   expect_equivalent(stri_rtrim("\t "), "")
   expect_equivalent(stri_rtrim("\n"), "")
   expect_equivalent(stri_rtrim(" \t ą \n ")," \t ą")
   
   expect_equivalent(stri_rtrim(LETTERS), LETTERS)
   
   expect_equivalent(stri_rtrim(stri_dup(" ", 1:100)), rep("", 100))
})

test_that("stri_trim_all", {
   
   # basic tests (ASCII, border-line):
   expect_equivalent(stri_trim_all(character(0)), character(0))
   expect_equivalent(stri_trim_all(NA), NA_character_)
   expect_equivalent(stri_trim_all(""),"")
   expect_equivalent(stri_trim_all("         "), "")
   expect_equivalent(stri_trim_all("  \t A \n "), "A")
   expect_equivalent(stri_trim_all(" A A  A  \t A  "), "A A A A")
   expect_equivalent(stri_trim(" \t ą \n "),"ą")
 
   expect_equivalent(stri_trim_all(LETTERS), LETTERS)
 
   expect_equivalent(stri_trim_all(stri_dup(" ", 1:100)), rep("", 100))
   s <- stri_flatten(LETTERS%+%stri_dup(" ",1:26))
   expect_equivalent(stri_trim_all(s),stri_flatten(LETTERS," "))
})


