require(testthat)


test_that("stri_replace_all_fixed", {
   expect_identical(stri_replace_all("abcde", fixed="bcd", replacement=""), "ae")
   expect_identical(stri_replace("abcde", mode="all", fixed="bcd", replacement=""), "ae")
   expect_identical(stri_replace_all_fixed(character(0),1,2),character(0))
   expect_identical(stri_replace_all_fixed("abab123 a","a",1),"1b1b123 1")
   expect_identical(stri_replace_all_fixed("","\\p{Wspace}","?"),"")
   expect_identical(stri_replace_all_fixed(NA,"A","1"),NA_character_)
   expect_identical(stri_replace_all_fixed("ALA",NA,"1"),NA_character_)
   expect_identical(stri_replace_all_fixed("ALA","A",NA),NA_character_)
   expect_identical(stri_replace_all_fixed(NA,NA,"A"),NA_character_)
   expect_identical(stri_replace_all_fixed(NA,"A",NA),NA_character_)
   expect_identical(stri_replace_all_fixed("A",NA,NA),NA_character_)
   expect_identical(stri_replace_all_fixed(NA,NA,NA),NA_character_)
   expect_warning(stri_replace_all_fixed('fasgasgas',c(" ","o"),1:3))

   expect_identical(stri_replace_all_fixed("ALA MA  KOTA",c(" ", "A", NA) ,""), c("ALAMAKOTA", "L M  KOT", NA))
   expect_identical(stri_replace_all_fixed("ALA","BF","HA"),"ALA")
   expect_identical(stri_replace_all_fixed("ALA","ALA", c("","RYBA")), c("", "RYBA"))
})


test_that("stri_replace_first_fixed", {
   expect_identical(stri_replace_first("abcde", fixed="bcd", replacement=""), "ae")
   expect_identical(stri_replace_first_fixed(character(0),1,2),character(0))
   expect_identical(stri_replace_first_fixed("abab123 a","a",1),"1bab123 a")
   expect_identical(stri_replace_first_fixed("","\\p{Wspace}","?"),"")
   expect_identical(stri_replace_first_fixed(NA,"A",1),NA_character_)
   expect_identical(stri_replace_first_fixed("ALA",NA,"1"),NA_character_)
   expect_identical(stri_replace_first_fixed("ALA","A",NA),NA_character_)
   expect_identical(stri_replace_first_fixed(NA,NA,"A"),NA_character_)
   expect_identical(stri_replace_first_fixed(NA,"A",NA),NA_character_)
   expect_identical(stri_replace_first_fixed("A",NA,NA),NA_character_)
   expect_identical(stri_replace_first_fixed(NA,NA,NA),NA_character_)
   expect_warning(stri_replace_first_fixed('fasgasgas',c(" ","o"),1:3))

   expect_identical(stri_replace_first_fixed("ALA MA  KOTA",c(" ", "A", NA) ,""), c("ALAMA  KOTA", "LA MA  KOTA", NA))
   expect_identical(stri_replace_first_fixed("ALA","BF","HA"),"ALA")
   expect_identical(stri_replace_first_fixed("A","A", c("","RYBA")), c("", "RYBA"))
   expect_identical(stri_replace_first_fixed("AB","AB", c("","RYBA")), c("", "RYBA"))
   expect_identical(stri_replace_first_fixed("ABC","ABC", c("","RYBA")), c("", "RYBA"))
   expect_identical(stri_replace_first_fixed("ABCD","ABCD", c("","RYBA")), c("", "RYBA"))
   expect_identical(stri_replace_first_fixed("ABCDE","ABCDE", c("","RYBA")), c("", "RYBA"))
})


test_that("stri_replace_last_fixed", {
   expect_identical(stri_replace_last("abcde", fixed="bcd", replacement=""), "ae")
   expect_identical(stri_replace_last_fixed(character(0),1,2),character(0))
   expect_identical(stri_replace_last_fixed("abab123 a","a",1),"abab123 1")
   expect_identical(stri_replace_last_fixed("","\\p{Wspace}","?"),"")
   expect_identical(stri_replace_last_fixed(NA,"A",1),NA_character_)
   expect_identical(stri_replace_last_fixed("ALA",NA,"1"),NA_character_)
   expect_identical(stri_replace_last_fixed("ALA","A",NA),NA_character_)
   expect_identical(stri_replace_last_fixed(NA,NA,"A"),NA_character_)
   expect_identical(stri_replace_last_fixed(NA,"A",NA),NA_character_)
   expect_identical(stri_replace_last_fixed("A",NA,NA),NA_character_)
   expect_identical(stri_replace_last_fixed(NA,NA,NA),NA_character_)

   expect_warning(stri_replace_last_fixed('fasgasgas',c(" ","o"),1:3))

   expect_identical(stri_replace_last_fixed("ALA MA  KOTA",c(" ", "A", NA) ,""), c("ALA MA KOTA", "ALA MA  KOT", NA))
   expect_identical(stri_replace_last_fixed("ALA","BF","HA"),"ALA")
   expect_identical(stri_replace_last_fixed("ALA","ALA", c("","RYBA")), c("", "RYBA"))

   expect_identical(stri_replace_last_fixed("A","A", c("","RYBA")), c("", "RYBA"))
   expect_identical(stri_replace_last_fixed("AB","AB", c("","RYBA")), c("", "RYBA"))
   expect_identical(stri_replace_last_fixed("ABC","ABC", c("","RYBA")), c("", "RYBA"))
   expect_identical(stri_replace_last_fixed("ABCD","ABCD", c("","RYBA")), c("", "RYBA"))
   expect_identical(stri_replace_last_fixed("ABCDE","ABCDE", c("","RYBA")), c("", "RYBA"))
})
