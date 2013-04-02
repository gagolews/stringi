require(testthat)

test_that("stri_replace_fixed", {
   expect_identical(stri_replace_all_fixed(character(0),1,2),character(0))
   expect_identical(stri_replace_all_fixed("abab123 a","a",1),"1b1b123 1")
   expect_identical(stri_replace_all_fixed(NA,"A",1),NA_character_)
   expect_warning(stri_replace_all_fixed('fasgasgas',c(" ","o"),1:3))
})



test_that("stri_replace_regex", {
   expect_identical(stri_replace_all_regex(character(0),1,2),character(0))
   expect_identical(stri_replace_all_regex("abab123 a","a",1),"1b1b123 1")
   expect_identical(stri_replace_all_regex(NA,"A",1),NA_character_)
   expect_warning(stri_replace_all_regex('fasgasgas',c(" ","o"),1:3))
   
   expect_identical(stri_replace_all_regex(c('a', 'b', 'c', 'd'),
                                           c('[ac]', '[bd]'), '!'),
                                           rep('!', 4))
   
   origenc <- stri_enc_set("latin2")
   expect_identical(stri_replace_all_regex(iconv("ąść", "UTF-8", "latin2"), 
                                                 iconv("ąść", "UTF-8", "latin2"),
                                                 iconv("ęłź", "UTF-8", "latin2")), "ęłź") # output is always UTF-8
   stri_enc_set(origenc)
   
   origenc <- stri_enc_set("cp1250")
   expect_identical(stri_replace_all_regex(iconv("ąść", "UTF-8", "cp1250"), 
                                           iconv("ąść", "UTF-8", "cp1250"),
                                           iconv("ęłź", "UTF-8", "cp1250")), "ęłź") # output is always UTF-8
   stri_enc_set(origenc)
   
   x1 <- rawToChar(as.raw(198))
   x2 <- rawToChar(as.raw(230))
   Encoding(x1) <- 'latin1'
   Encoding(x2) <- 'latin1'
   expect_identical(stri_replace_all_regex(x1, x1, x2), 'æ')
   
   expect_identical(stri_replace_all_regex("X\U00024B62X",
             c("\U00024B62", "\U00024B63", "X"), ""),
                    c("XX", "X\U00024B62X", "\U00024B62"))
})
