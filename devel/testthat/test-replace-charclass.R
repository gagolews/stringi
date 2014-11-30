require(testthat)
context("test-replace-charclass.R")

test_that("stri_replace_all_charclass-vectorize_all=FALSE", {
   expect_identical(stri_replace_all_charclass(character(0),c("\\p{Z}", "\\P{Z}"),"", vectorize_all=FALSE),character(0))
   expect_error(stri_replace_all_charclass("b",character(0),c("a", "b"), vectorize_all=FALSE))
   expect_error(stri_replace_all_charclass("b",c("", ""),"a", vectorize_all=FALSE))
   expect_identical(stri_replace_all_charclass(NA,c("\\p{WHITE_SPACE}", "[a]"),"?", vectorize_all=FALSE),NA_character_)
   expect_identical(stri_replace_all_charclass("X",c("\\p{WHITE_SPACE}", "[a]"),NA, vectorize_all=FALSE),NA_character_)
   expect_identical(stri_replace_all_charclass("X",NA,"?", vectorize_all=FALSE),NA_character_)
   expect_identical(stri_replace_all_charclass(NA,NA,"?", vectorize_all=FALSE),NA_character_)
   expect_identical(stri_replace_all_charclass(NA,NA,NA, vectorize_all=FALSE),NA_character_)
   expect_identical(stri_replace_all_charclass("","\\p{Wspace}","?", vectorize_all=FALSE),"")
   expect_identical(stri_replace_all_charclass(c("a a", " aa", "aa ", "aa"), "\\p{Wspace}", "X", vectorize_all=FALSE), c("aXa", "Xaa", "aaX", "aa"))
   expect_identical(stri_replace_all_charclass(c("a a ", " aa ", "aa  ", "aa"), "\\p{Wspace}", "X", vectorize_all=FALSE), c("aXaX", "XaaX", "aaXX", "aa"))
   expect_identical(stri_replace_all_charclass("a1 ", c("\\p{Z}", "\\p{Nd}", "\\p{Ll}", "\\p{P}"),
      c("x", "y", "z", "w"), vectorize_all=FALSE), "zzz")
   expect_identical(stri_replace_all_charclass("a1 ", c("\\p{Ll}", "\\p{Z}", "\\p{Nd}", "\\p{P}"),
      c("x", "y", "z", "w"), vectorize_all=FALSE), "xzy")
   expect_identical(stri_replace_all_charclass("aaa bbb   ccc", c("\\P{Z}", "\\p{Z}"),
      c("x", "y"), vectorize_all=FALSE), "xxxyxxxyyyxxx")
   expect_identical(stri_replace_all_charclass("aaa bbb   ccc", c("\\P{Z}", "\\p{Z}"), merge=TRUE,
      c("x", "y"), vectorize_all=FALSE), "xyxyx")
   expect_identical(stri_replace_all_charclass("aaa bbb,   ccc", c("\\p{L}", "\\p{Z}"), merge=TRUE,
      c("xxxxx", ""), vectorize_all=FALSE), "xxxxxxxxxx,xxxxx")

})

test_that("stri_replace_all_charclass", {
   expect_identical(stri_replace_all_charclass(character(0),"\\p{Z}",""),character(0))
   expect_identical(stri_replace_all_charclass("b",character(0),"a"),character(0))
   expect_error(stri_replace_all_charclass("b","","a"))
   expect_identical(stri_replace_all_charclass(NA,"\\p{WHITE_SPACE}","?"),NA_character_)
   expect_identical(stri_replace_all_charclass("X","\\p{WHITE_SPACE}",NA),NA_character_)
   expect_identical(stri_replace_all_charclass("X",NA,"?"),NA_character_)
   expect_identical(stri_replace_all_charclass(NA,NA,"?"),NA_character_)
   expect_identical(stri_replace_all_charclass(NA,NA,NA),NA_character_)
   expect_identical(stri_replace_all_charclass("","\\p{Wspace}","?"),"")
   expect_identical(stri_replace_all_charclass(c("a a", " aa", "aa ", "aa"), "\\p{Wspace}", "X"), c("aXa", "Xaa", "aaX", "aa"))
   expect_identical(stri_replace_all_charclass(c("a a ", " aa ", "aa  ", "aa"), "\\p{Wspace}", "X"), c("aXaX", "XaaX", "aaXX", "aa"))
   expect_identical(stri_replace_all_charclass("a1 ", c("\\p{Z}", "\\p{Nd}", "\\p{Ll}", "\\p{P}"), "X"), c("a1X", "aX ", "X1 ", "a1 "))
   expect_identical(stri_replace_all_charclass("a1 ", "\\P{Z}", c("X", "Y")), c("XX ", "YY "))
   expect_identical(stri_replace_all_charclass(c(stri_dup(" ", 0:1500)), "\\p{Wspace}", "X"), stri_dup("X", 0:1500))
   expect_identical(stri_replace_all_charclass(c(stri_dup(" Y", 0:1500)), "\\p{Wspace}", "X"), stri_dup("XY", 0:1500))
   expect_identical(stri_replace_all_charclass(c(stri_dup("Y ", 0:1500)), "\\p{Wspace}", "X"), stri_dup("YX", 0:1500))
   expect_identical(stri_replace_all_charclass("ala   ma \t    \n kota      ", "\\p{WHITESPACE}", " ", merge=TRUE),
         "ala ma kota ")
})


test_that("stri_replace_first_charclass", {
   expect_identical(stri_replace_first_charclass(character(0),"\\p{Z}",""),character(0))
   expect_identical(stri_replace_first_charclass(NA,"\\p{Wspace}","?"),NA_character_)
   expect_identical(stri_replace_first_charclass("X","\\p{Wspace}",NA),NA_character_)
   expect_identical(stri_replace_first_charclass("X",NA,"?"),NA_character_)
   expect_identical(stri_replace_first_charclass(NA,NA,"?"),NA_character_)
   expect_identical(stri_replace_first_charclass(NA,NA,NA),NA_character_)
   expect_identical(stri_replace_first_charclass("","\\p{Wspace}","?"),"")
   expect_identical(stri_replace_first_charclass(c("a a", " aa", "aa ", "aa"), "\\p{Wspace}", "X"), c("aXa", "Xaa", "aaX", "aa"))
   expect_identical(stri_replace_first_charclass(c("a a ", " aa ", "aa  ", "aa"), "\\p{Wspace}", "X"), c("aXa ", "Xaa ", "aaX ", "aa"))
   expect_identical(stri_replace_first_charclass("a1 ", c("\\p{Z}", "\\p{Nd}", "\\p{Ll}", "\\p{P}"), "X"), c("a1X", "aX ", "X1 ", "a1 "))
   expect_identical(stri_replace_first_charclass("a1 ", "\\P{Z}", c("X", "Y")), c("X1 ", "Y1 "))
})


test_that("stri_replace_last_charclass", {
   expect_identical(stri_replace_last_charclass(character(0),"\\p{Z}",""),character(0))
   expect_identical(stri_replace_last_charclass(NA,"\\p{Wspace}","?"),NA_character_)
   expect_identical(stri_replace_last_charclass("X","\\p{Wspace}",NA),NA_character_)
   expect_identical(stri_replace_last_charclass("X",NA,"?"),NA_character_)
   expect_identical(stri_replace_last_charclass(NA,NA,"?"),NA_character_)
   expect_identical(stri_replace_last_charclass(NA,NA,NA),NA_character_)
   expect_identical(stri_replace_last_charclass("","\\p{Wspace}","?"),"")
   expect_identical(stri_replace_last_charclass(c("a a", " aa", "aa ", "aa"), "\\p{Wspace}", "X"), c("aXa", "Xaa", "aaX", "aa"))
   expect_identical(stri_replace_last_charclass(c("a a ", " aa ", "aa  ", "aa", " aa"), "\\p{Wspace}", "X"), c("a aX", " aaX", "aa X", "aa", "Xaa"))
   expect_identical(stri_replace_last_charclass("a1 ", c("\\p{Z}", "\\p{Nd}", "\\p{Ll}", "\\p{P}"), "X"), c("a1X", "aX ", "X1 ", "a1 "))
   expect_identical(stri_replace_last_charclass("a1 ", "\\P{Z}", c("X", "Y")), c("aX ", "aY "))
})
