require(testthat)


test_that("stri_replace_all_charclass", {
   expect_identical(stri_replace_all_charclass(character(0),"Z",""),character(0))
   expect_identical(stri_replace_all_charclass(NA,"WHITE_SPACE","?"),NA_character_)
   expect_identical(stri_replace_all_charclass("X","WHITE_SPACE",NA),NA_character_)
   expect_identical(stri_replace_all_charclass("X",NA,"?"),NA_character_)
   expect_identical(stri_replace_all_charclass("","WHITE_SPACE","?"),"")
   expect_identical(stri_replace_all_charclass(c("a a", " aa", "aa ", "aa"), "WHITE_SPACE", "X"), c("aXa", "Xaa", "aaX", "aa"))
   expect_identical(stri_replace_all_charclass(c("a a ", " aa ", "aa  ", "aa"), "WHITE_SPACE", "X"), c("aXaX", "XaaX", "aaXX", "aa"))
   expect_identical(stri_replace_all_charclass("a1 ", c("Z", "Nd", "Ll", "P"), "X"), c("a1X", "aX ", "X1 ", "a1 "))
   expect_identical(stri_replace_all_charclass("a1 ", "^Z", c("X", "Y")), c("XX ", "YY "))
   expect_identical(stri_replace_all_charclass(c(stri_dup(" ", 0:1500)), "WHITE_SPACE", "X"), stri_dup("X", 0:1500))
   expect_identical(stri_replace_all_charclass(c(stri_dup(" Y", 0:1500)), "WHITE_SPACE", "X"), stri_dup("XY", 0:1500))
   expect_identical(stri_replace_all_charclass(c(stri_dup("Y ", 0:1500)), "WHITE_SPACE", "X"), stri_dup("YX", 0:1500))
})



test_that("stri_replace_first_charclass", {
   expect_identical(stri_replace_first_charclass(character(0),"Z",""),character(0))
   expect_identical(stri_replace_first_charclass(NA,"WHITE_SPACE","?"),NA_character_)
   expect_identical(stri_replace_first_charclass("X","WHITE_SPACE",NA),NA_character_)
   expect_identical(stri_replace_first_charclass("X",NA,"?"),NA_character_)
   expect_identical(stri_replace_first_charclass("","WHITE_SPACE","?"),"")
   expect_identical(stri_replace_first_charclass(c("a a", " aa", "aa ", "aa"), "WHITE_SPACE", "X"), c("aXa", "Xaa", "aaX", "aa"))
   expect_identical(stri_replace_first_charclass(c("a a ", " aa ", "aa  ", "aa"), "WHITE_SPACE", "X"), c("aXa ", "Xaa ", "aaX ", "aa"))
   expect_identical(stri_replace_first_charclass("a1 ", c("Z", "Nd", "Ll", "P"), "X"), c("a1X", "aX ", "X1 ", "a1 "))
   expect_identical(stri_replace_first_charclass("a1 ", "^Z", c("X", "Y")), c("X1 ", "Y1 "))
})


test_that("stri_replace_last_charclass", {
   expect_identical(stri_replace_last_charclass(character(0),"Z",""),character(0))
   expect_identical(stri_replace_last_charclass(NA,"WHITE_SPACE","?"),NA_character_)
   expect_identical(stri_replace_last_charclass("X","WHITE_SPACE",NA),NA_character_)
   expect_identical(stri_replace_last_charclass("X",NA,"?"),NA_character_)
   expect_identical(stri_replace_last_charclass("","WHITE_SPACE","?"),"")
   expect_identical(stri_replace_last_charclass(c("a a", " aa", "aa ", "aa"), "WHITE_SPACE", "X"), c("aXa", "Xaa", "aaX", "aa"))
   expect_identical(stri_replace_last_charclass(c("a a ", " aa ", "aa  ", "aa", " aa"), "WHITE_SPACE", "X"), c("a aX", " aaX", "aa X", "aa", "Xaa"))
   expect_identical(stri_replace_last_charclass("a1 ", c("Z", "Nd", "Ll", "P"), "X"), c("a1X", "aX ", "X1 ", "a1 "))
   expect_identical(stri_replace_last_charclass("a1 ", "^Z", c("X", "Y")), c("aX ", "aY "))
})



# test_that("stri_replace_fixed", {
#    expect_identical(stri_replace_all_fixed(character(0),1,2),character(0))
#    expect_identical(stri_replace_all_fixed("abab123 a","a",1),"1b1b123 1")
#    expect_identical(stri_replace_all_fixed(NA,"A",1),NA_character_)
#    expect_warning(stri_replace_all_fixed('fasgasgas',c(" ","o"),1:3))
# })



test_that("stri_replace_all_regex", {
   expect_identical(stri_replace_all_regex(character(0),1,2),character(0))
   expect_identical(stri_replace_all_regex(1,character(0),2),character(0))
   expect_identical(stri_replace_all_regex(1,2,character(0)),character(0))
   expect_identical(stri_replace_all_regex("abab123 a","a",1),"1b1b123 1")
   expect_identical(stri_replace_all_regex(NA,"A",1),NA_character_)
   expect_warning(stri_replace_all_regex('fasgasgas',c(" ","o"),1:3))
   
   expect_identical(stri_replace_all_regex("abc!def!ghi","(\\p{L})\\p{L}{2}","$1"),"a!d!g")
   expect_identical(stri_replace_all_regex("abc!def!ghi","(\\p{L}{3})","@$1@"),"@abc@!@def@!@ghi@")
   
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



test_that("stri_replace_first_regex", {

   expect_identical(stri_replace_first_regex("abc!def!ghi","(\\p{L})\\p{L}{2}","$1"),"a!def!ghi")
   expect_identical(stri_replace_first_regex("abc!def!ghi","(\\p{L}{3})","@$1@"),"@abc@!def!ghi")
   expect_identical(stri_replace_first_regex("123!345!456","(\\p{L}{3})","@$1@"),"123!345!456")
   expect_identical(stri_replace_first_regex("abc","a","2"),"2bc")
   expect_identical(stri_replace_first_regex("abc","d","2"),"abc")

})


test_that("stri_replace_last_regex", {
   
   expect_identical(stri_replace_last_regex("abc!def!ghi","(\\p{L})\\p{L}{2}","$1"),"abc!def!g")
   expect_identical(stri_replace_last_regex("abc!def!ghi!","(\\p{L}{3})","@$1@"),"abc!def!@ghi@!")
   expect_identical(stri_replace_last_regex("123!345!456","(\\p{L}{3})","@$1@"),"123!345!456")
   expect_identical(stri_replace_last_regex("abc","c","2"),"ab2")
   expect_identical(stri_replace_last_regex("abc","d","2"),"abc")
   
})
