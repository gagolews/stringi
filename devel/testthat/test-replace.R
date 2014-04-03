require(testthat)


test_that("stri_replace_all_charclass", {
   expect_identical(stri_replace_all_charclass(character(0),"Z",""),character(0))
   expect_identical(stri_replace_all_charclass("b",character(0),"a"),character(0))
   suppressWarnings(expect_identical(stri_replace_all_charclass("b","","a"), NA_character_))
   expect_identical(stri_replace_all_charclass(NA,"WHITE_SPACE","?"),NA_character_)
   expect_identical(stri_replace_all_charclass("X","WHITE_SPACE",NA),NA_character_)
   expect_identical(stri_replace_all_charclass("X",NA,"?"),NA_character_)
   expect_identical(stri_replace_all_charclass(NA,NA,"?"),NA_character_)
   expect_identical(stri_replace_all_charclass(NA,NA,NA),NA_character_)
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
   expect_identical(stri_replace_first_charclass(NA,NA,"?"),NA_character_)
   expect_identical(stri_replace_first_charclass(NA,NA,NA),NA_character_)
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
   expect_identical(stri_replace_last_charclass(NA,NA,"?"),NA_character_)
   expect_identical(stri_replace_last_charclass(NA,NA,NA),NA_character_)
   expect_identical(stri_replace_last_charclass("","WHITE_SPACE","?"),"")
   expect_identical(stri_replace_last_charclass(c("a a", " aa", "aa ", "aa"), "WHITE_SPACE", "X"), c("aXa", "Xaa", "aaX", "aa"))
   expect_identical(stri_replace_last_charclass(c("a a ", " aa ", "aa  ", "aa", " aa"), "WHITE_SPACE", "X"), c("a aX", " aaX", "aa X", "aa", "Xaa"))
   expect_identical(stri_replace_last_charclass("a1 ", c("Z", "Nd", "Ll", "P"), "X"), c("a1X", "aX ", "X1 ", "a1 "))
   expect_identical(stri_replace_last_charclass("a1 ", "^Z", c("X", "Y")), c("aX ", "aY "))
})



test_that("stri_replace_all_fixed", {
   expect_identical(stri_replace_all_fixed(character(0),1,2),character(0))
   expect_identical(stri_replace_all_fixed("abab123 a","a",1),"1b1b123 1")
   expect_identical(stri_replace_all_fixed("","WHITE_SPACE","?"),"")
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
   expect_identical(stri_replace_first_fixed(character(0),1,2),character(0))
   expect_identical(stri_replace_first_fixed("abab123 a","a",1),"1bab123 a")
   expect_identical(stri_replace_first_fixed("","WHITE_SPACE","?"),"")
   expect_identical(stri_replace_first_fixed(NA,"A",1),NA_character_)
   expect_identical(stri_replace_first_fixed(NA,NA,"A"),NA_character_)
   expect_identical(stri_replace_first_fixed(NA,"A",NA),NA_character_)
   expect_identical(stri_replace_first_fixed("A",NA,NA),NA_character_)
   expect_identical(stri_replace_first_fixed(NA,NA,NA),NA_character_)
   expect_warning(stri_replace_first_fixed('fasgasgas',c(" ","o"),1:3))

   expect_identical(stri_replace_first_fixed("ALA MA  KOTA",c(" ", "A", NA) ,""), c("ALAMA  KOTA", "LA MA  KOTA", NA))
   expect_identical(stri_replace_first_fixed("ALA","BF","HA"),"ALA")
   expect_identical(stri_replace_first_fixed("ALA","ALA", c("","RYBA")), c("", "RYBA"))
})


test_that("stri_replace_last_fixed", {
   expect_identical(stri_replace_last_fixed(character(0),1,2),character(0))
   expect_identical(stri_replace_last_fixed("abab123 a","a",1),"abab123 1")
   expect_identical(stri_replace_last_fixed("","WHITE_SPACE","?"),"")
   expect_identical(stri_replace_last_fixed(NA,"A",1),NA_character_)
   expect_identical(stri_replace_last_fixed(NA,NA,"A"),NA_character_)
   expect_identical(stri_replace_last_fixed(NA,"A",NA),NA_character_)
   expect_identical(stri_replace_last_fixed("A",NA,NA),NA_character_)
   expect_identical(stri_replace_last_fixed(NA,NA,NA),NA_character_)

   expect_warning(stri_replace_last_fixed('fasgasgas',c(" ","o"),1:3))

   expect_identical(stri_replace_last_fixed("ALA MA  KOTA",c(" ", "A", NA) ,""), c("ALA MA KOTA", "ALA MA  KOT", NA))
   expect_identical(stri_replace_last_fixed("ALA","BF","HA"),"ALA")
   expect_identical(stri_replace_last_fixed("ALA","ALA", c("","RYBA")), c("", "RYBA"))
})

test_that("stri_replace_all_fixed [byte]", {
   expect_identical(stri_replace_all_fixed(character(0),1,2, opts_collator=NA),character(0))
   expect_identical(stri_replace_all_fixed("abab123 a","a",1, opts_collator=NA),"1b1b123 1")
   expect_identical(stri_replace_all_fixed("","WHITE_SPACE","?", opts_collator=NA),"")
   expect_identical(stri_replace_all_fixed(NA,"A","1", opts_collator=NA),NA_character_)
   expect_identical(stri_replace_all_fixed("ALA",NA,"1", opts_collator=NA),NA_character_)
   expect_identical(stri_replace_all_fixed("ALA","A",NA, opts_collator=NA),NA_character_)
   expect_identical(stri_replace_all_fixed(NA,NA,"A", opts_collator=NA),NA_character_)
   expect_identical(stri_replace_all_fixed(NA,"A",NA, opts_collator=NA),NA_character_)
   expect_identical(stri_replace_all_fixed("A",NA,NA, opts_collator=NA),NA_character_)
   expect_identical(stri_replace_all_fixed(NA,NA,NA, opts_collator=NA),NA_character_)
   expect_warning(stri_replace_all_fixed('fasgasgas',c(" ","o"),1:3, opts_collator=NA))

   expect_identical(stri_replace_all_fixed("ALA MA  KOTA",c(" ", "A", NA) ,"", opts_collator=NA), c("ALAMAKOTA", "L M  KOT", NA))
   expect_identical(stri_replace_all_fixed("ALA","BF","HA", opts_collator=NA),"ALA")
   expect_identical(stri_replace_all_fixed("ALA","ALA", c("","RYBA"), opts_collator=NA), c("", "RYBA"))
})


test_that("stri_replace_first_fixed [byte]", {
   expect_identical(stri_replace_first_fixed(character(0),1,2, opts_collator=NA),character(0))
   expect_identical(stri_replace_first_fixed("abab123 a","a",1, opts_collator=NA),"1bab123 a")
   expect_identical(stri_replace_first_fixed("","WHITE_SPACE","?", opts_collator=NA),"")
   expect_identical(stri_replace_first_fixed(NA,"A",1, opts_collator=NA),NA_character_)
   expect_identical(stri_replace_first_fixed("ALA",NA,"1", opts_collator=NA),NA_character_)
   expect_identical(stri_replace_first_fixed("ALA","A",NA, opts_collator=NA),NA_character_)
   expect_identical(stri_replace_first_fixed(NA,NA,"A", opts_collator=NA),NA_character_)
   expect_identical(stri_replace_first_fixed(NA,"A",NA, opts_collator=NA),NA_character_)
   expect_identical(stri_replace_first_fixed("A",NA,NA, opts_collator=NA),NA_character_)
   expect_identical(stri_replace_first_fixed(NA,NA,NA, opts_collator=NA),NA_character_)
   expect_warning(stri_replace_first_fixed('fasgasgas',c(" ","o"),1:3, opts_collator=NA))

   expect_identical(stri_replace_first_fixed("ALA MA  KOTA",c(" ", "A", NA) ,"", opts_collator=NA), c("ALAMA  KOTA", "LA MA  KOTA", NA))
   expect_identical(stri_replace_first_fixed("ALA","BF","HA", opts_collator=NA),"ALA")
   expect_identical(stri_replace_first_fixed("ALA","ALA", c("","RYBA"), opts_collator=NA), c("", "RYBA"))
})


test_that("stri_replace_last_fixed [byte]", {
   expect_identical(stri_replace_last_fixed(character(0),1,2, opts_collator=NA),character(0))
   expect_identical(stri_replace_last_fixed("abab123 a","a",1, opts_collator=NA),"abab123 1")
   expect_identical(stri_replace_last_fixed("","WHITE_SPACE","?", opts_collator=NA),"")
   expect_identical(stri_replace_last_fixed(NA,"A",1, opts_collator=NA),NA_character_)
   expect_identical(stri_replace_last_fixed("ALA",NA,"1", opts_collator=NA),NA_character_)
   expect_identical(stri_replace_last_fixed("ALA","A",NA, opts_collator=NA),NA_character_)
   expect_identical(stri_replace_last_fixed(NA,NA,"A", opts_collator=NA),NA_character_)
   expect_identical(stri_replace_last_fixed(NA,"A",NA, opts_collator=NA),NA_character_)
   expect_identical(stri_replace_last_fixed("A",NA,NA, opts_collator=NA),NA_character_)
   expect_identical(stri_replace_last_fixed(NA,NA,NA, opts_collator=NA),NA_character_)

   expect_warning(stri_replace_last_fixed('fasgasgas',c(" ","o"),1:3, opts_collator=NA))

   expect_identical(stri_replace_last_fixed("ALA MA  KOTA",c(" ", "A", NA) ,"", opts_collator=NA), c("ALA MA KOTA", "ALA MA  KOT", NA))
   expect_identical(stri_replace_last_fixed("ALA","BF","HA", opts_collator=NA),"ALA")
   expect_identical(stri_replace_last_fixed("ALA","ALA", c("","RYBA"), opts_collator=NA), c("", "RYBA"))
})


test_that("stri_replace_all_regex", {
   expect_identical(stri_replace_all_regex(character(0),1,2),character(0))
   expect_identical(stri_replace_all_regex(1,character(0),2),character(0))
   expect_identical(stri_replace_all_regex(1,2,character(0)),character(0))
   expect_identical(stri_replace_all_regex("abab123 a","a",1),"1b1b123 1")
   expect_identical(stri_replace_all_regex(NA,"A",1),NA_character_)
   expect_identical(stri_replace_all_regex("ALA",NA,"1"),NA_character_)
   expect_identical(stri_replace_all_regex("ALA","A",NA),NA_character_)
   expect_identical(stri_replace_all_regex(NA,NA,"A"),NA_character_)
   expect_identical(stri_replace_all_regex(NA,"A",NA),NA_character_)
   expect_identical(stri_replace_all_regex("A",NA,NA),NA_character_)
   expect_identical(stri_replace_all_regex(NA,NA,NA),NA_character_)
   expect_warning(stri_replace_all_regex('fasgasgas',c(" ","o"),1:3))

   expect_identical(stri_replace_all_regex("abc!def!ghi","(\\p{L})\\p{L}{2}","$1"),"a!d!g")
   expect_identical(stri_replace_all_regex("abc!def!ghi","(\\p{L}{3})","@$1@"),"@abc@!@def@!@ghi@")

   expect_identical(stri_replace_all_regex(c('a', 'b', 'c', 'd'),
                                           c('[ac]', '[bd]'), '!'),
                                           rep('!', 4))

   origenc <- stri_enc_set("latin2")
   expect_identical(stri_replace_all_regex(iconv("\u0105\u015b\u0107", "UTF-8", "latin2"),
                                                 iconv("\u0105\u015b\u0107", "UTF-8", "latin2"),
                                                 iconv("\u0119\u0142\u017a", "UTF-8", "latin2")), "\u0119\u0142\u017a") # output is always UTF-8
   stri_enc_set(origenc)

   origenc <- stri_enc_set("cp1250")
   expect_identical(stri_replace_all_regex(iconv("\u0105\u015b\u0107", "UTF-8", "cp1250"),
                                           iconv("\u0105\u015b\u0107", "UTF-8", "cp1250"),
                                           iconv("\u0119\u0142\u017a", "UTF-8", "cp1250")), "\u0119\u0142\u017a") # output is always UTF-8
   stri_enc_set(origenc)

   x1 <- rawToChar(as.raw(198))
   x2 <- rawToChar(as.raw(230))
   Encoding(x1) <- 'latin1'
   Encoding(x2) <- 'latin1'
   expect_identical(stri_replace_all_regex(x1, x1, x2), '\u00e6')

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

   expect_identical(stri_replace_first_regex(NA,"A",1),NA_character_)
   expect_identical(stri_replace_first_regex("ALA",NA,"1"),NA_character_)
   expect_identical(stri_replace_first_regex("ALA","A",NA),NA_character_)
   expect_identical(stri_replace_first_regex(NA,NA,"A"),NA_character_)
   expect_identical(stri_replace_first_regex(NA,"A",NA),NA_character_)
   expect_identical(stri_replace_first_regex("A",NA,NA),NA_character_)
   expect_identical(stri_replace_first_regex(NA,NA,NA),NA_character_)

})


test_that("stri_replace_last_regex", {

   expect_identical(stri_replace_last_regex("abc!def!ghi","(\\p{L})\\p{L}{2}","$1"),"abc!def!g")
   expect_identical(stri_replace_last_regex("abc!def!ghi!","(\\p{L}{3})","@$1@"),"abc!def!@ghi@!")
   expect_identical(stri_replace_last_regex("123!345!456","(\\p{L}{3})","@$1@"),"123!345!456")
   expect_identical(stri_replace_last_regex("abc","c","2"),"ab2")
   expect_identical(stri_replace_last_regex("abc","d","2"),"abc")

   expect_identical(stri_replace_last_regex(NA,"A",1),NA_character_)
   expect_identical(stri_replace_last_regex("ALA",NA,"1"),NA_character_)
   expect_identical(stri_replace_last_regex("ALA","A",NA),NA_character_)
   expect_identical(stri_replace_last_regex(NA,NA,"A"),NA_character_)
   expect_identical(stri_replace_last_regex(NA,"A",NA),NA_character_)
   expect_identical(stri_replace_last_regex("A",NA,NA),NA_character_)
   expect_identical(stri_replace_last_regex(NA,NA,NA),NA_character_)

})



test_that("stri_replace_na", {
   s <- c("ala",NA,"kota")
   expect_identical(stri_replace_na(s,"brak"),c("ala","brak","kota"))
   expect_identical(stri_replace_na(s,""),c("ala","","kota"))
   expect_identical(stri_replace_na(s,NA),c("ala",NA,"kota"))
   expect_warning(stri_replace_na(s,character(3)))
   expect_error(stri_replace_na(s,character(0)))

   x <- stri_enc_tonative(stri_dup("\u0105", 1:100))
   x[sample(seq_along(x), 20)] <- NA_character_
   expect_equivalent(stri_replace_na(x, "???"), {
      x2 <- stri_enc_toutf8(x); x2[is.na(x2)] <- "???"; x2
   })
})
