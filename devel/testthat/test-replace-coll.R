require(testthat)

test_that("stri_replace_all_coll", {
   expect_identical(stri_replace_all_coll(character(0),1,2),character(0))
   expect_identical(stri_replace_all_coll("abab123 a","a",1),"1b1b123 1")
   expect_identical(stri_replace_all_coll("","\\p{Wspace}","?"),"")
   expect_identical(stri_replace_all_coll(NA,"A","1"),NA_character_)
   expect_identical(stri_replace_all_coll("ALA",NA,"1"),NA_character_)
   expect_identical(stri_replace_all_coll("ALA","A",NA),NA_character_)
   expect_identical(stri_replace_all_coll(NA,NA,"A"),NA_character_)
   expect_identical(stri_replace_all_coll(NA,"A",NA),NA_character_)
   expect_identical(stri_replace_all_coll("A",NA,NA),NA_character_)
   expect_identical(stri_replace_all_coll(NA,NA,NA),NA_character_)
   expect_warning(stri_replace_all_coll('fasgasgas',c(" ","o"),1:3))

   expect_identical(stri_replace_all_coll("ALA MA  KOTA",c(" ", "A", NA) ,""), c("ALAMAKOTA", "L M  KOT", NA))
   expect_identical(stri_replace_all_coll("ALA","BF","HA"),"ALA")
   expect_identical(stri_replace_all_coll("ALA","ALA", c("","RYBA")), c("", "RYBA"))
})


test_that("stri_replace_first_coll", {
   expect_identical(stri_replace_first_coll(character(0),1,2),character(0))
   expect_identical(stri_replace_first_coll("abab123 a","a",1),"1bab123 a")
   expect_identical(stri_replace_first_coll("","\\p{Wspace}","?"),"")
   expect_identical(stri_replace_first_coll(NA,"A",1),NA_character_)
   expect_identical(stri_replace_first_coll(NA,NA,"A"),NA_character_)
   expect_identical(stri_replace_first_coll(NA,"A",NA),NA_character_)
   expect_identical(stri_replace_first_coll("A",NA,NA),NA_character_)
   expect_identical(stri_replace_first_coll(NA,NA,NA),NA_character_)
   expect_warning(stri_replace_first_coll('fasgasgas',c(" ","o"),1:3))

   expect_identical(stri_replace_first_coll("ALA MA  KOTA",c(" ", "A", NA) ,""), c("ALAMA  KOTA", "LA MA  KOTA", NA))
   expect_identical(stri_replace_first_coll("ALA","BF","HA"),"ALA")
   expect_identical(stri_replace_first_coll("ALA","ALA", c("","RYBA")), c("", "RYBA"))
})


test_that("stri_replace_last_coll", {
   expect_identical(stri_replace_last_coll(character(0),1,2),character(0))
   expect_identical(stri_replace_last_coll("abab123 a","a",1),"abab123 1")
   expect_identical(stri_replace_last_coll("","\\p{Wspace}","?"),"")
   expect_identical(stri_replace_last_coll(NA,"A",1),NA_character_)
   expect_identical(stri_replace_last_coll(NA,NA,"A"),NA_character_)
   expect_identical(stri_replace_last_coll(NA,"A",NA),NA_character_)
   expect_identical(stri_replace_last_coll("A",NA,NA),NA_character_)
   expect_identical(stri_replace_last_coll(NA,NA,NA),NA_character_)

   expect_warning(stri_replace_last_coll('fasgasgas',c(" ","o"),1:3))

   expect_identical(stri_replace_last_coll("ALA MA  KOTA",c(" ", "A", NA) ,""), c("ALA MA KOTA", "ALA MA  KOT", NA))
   expect_identical(stri_replace_last_coll("ALA","BF","HA"),"ALA")
   expect_identical(stri_replace_last_coll("ALA","ALA", c("","RYBA")), c("", "RYBA"))
})
