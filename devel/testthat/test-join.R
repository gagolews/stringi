require(testthat)
context("test-join.R")

test_that("stri_join", {

   # we have many specialized functions for join, e.g.
   # flatten with sep
   # flatten with no sep
   # join2 with sep and no collapse
   # join2 with sep and collapse
   # join - general, with collapse
   # join - general, no collapse


   #stringr tests:
   test <- c("a", "b", "c")
   expect_that(stri_c(test, ignore_null=TRUE), equals(test))
   expect_that(stri_c(test, sep = " ", ignore_null=TRUE), equals(test))
   expect_that(stri_c(test, collapse = "", ignore_null=TRUE), equals("abc"))
   test <- letters[1:3]
   expect_that(stri_c(test, c(), ignore_null=TRUE), equals(test))
   expect_that(stri_c(test, NULL, ignore_null=TRUE), equals(test))
   expect_that(
      stri_c(test, NULL, "a", sep = " ", ignore_null=TRUE),
      equals(c("a a", "b a", "c a")))

   expect_equal(stri_flatten(as.Date(ISOdate(2015, 01, 12))), "2015-01-12")
   expect_equal(stri_flatten(as.factor("aaa")), "aaa")

   expect_equal(stri_c("a", c("x", "y"), "b"), c("axb", "ayb"))

   expect_equal(stri_join(LETTERS, LETTERS, sep=NA), rep(NA_character_, length(LETTERS)))
   expect_equal(stri_join(LETTERS, LETTERS, sep=NA, collapse=NA), NA_character_)
   expect_equal(stri_join(LETTERS, sep=NA), rep(NA_character_, length(LETTERS)))
   expect_equal(stri_join(character(0), character(0)), character(0))
   expect_error(stri_join(LETTERS, LETTERS, sep=character(0)))
   expect_warning(stri_join(LETTERS, LETTERS, sep=LETTERS))
   expect_error(stri_join(LETTERS, LETTERS, sep=mean))

   expect_identical(stri_paste(1:4, 1:2, 1:4, 1:2, 1:4, 1:2, sep="!"), paste(1:4, 1:2, 1:4, 1:2, 1:4, 1:2, sep="!"))
   expect_identical(stri_paste(1:4, 11:12, 21:24, 31:32, 41:44, 51:52, 61, 71, sep="!"), paste(1:4, 11:12, 21:24, 31:32, 41:44, 51:52, 61, 71, sep="!"))

   expect_identical(stri_join(), character(0))
   expect_warning(stri_paste(1:3, 1:2, sep=""))
   expect_warning(stri_paste(1:3, 1:2, sep="!"))
   expect_warning(stri_paste(1:3, 1:2, sep="", collapse=""))
   expect_warning(stri_paste(1:3, 1:2, sep="!", collapse=""))
   expect_identical(stri_join(character(0), "a", "b"), character(0))
   expect_identical(stri_join("a", "b", character(0)), character(0))
   expect_identical(stri_join("a", character(0)), character(0))
   expect_identical(stri_join(character(0), "a"), character(0))
   expect_identical(stri_join(character(0)), character(0))
   expect_identical(stri_join(NULL), character(0))
   expect_identical(stri_join("a", "b", NULL), character(0))
   expect_identical(stri_join(character(0), "a", "b", collapse=""), character(0))
   expect_identical(stri_join(character(0), rep("a", 2), collapse=""), character(0))

   expect_identical(stri_join(character(0), "a", "b", ignore_null=TRUE), "ab")
   expect_identical(stri_join(character(0), "a", rep("b",2), ignore_null=TRUE), c("ab", "ab"))
   expect_identical(stri_join("a", "b", character(0), ignore_null=TRUE), "ab")
   expect_identical(stri_join("a", character(0), ignore_null=TRUE), "a")
   expect_identical(stri_join(character(0), "a", ignore_null=TRUE), "a")
   expect_identical(stri_join(character(0), ignore_null=TRUE), character(0))
   expect_identical(stri_join(NULL, ignore_null=TRUE), character(0))
   expect_identical(stri_join("a", "b", NULL, ignore_null=TRUE), "ab")
   expect_identical(stri_join(character(0), rep("a", 2), "b", collapse="", ignore_null=TRUE), "abab")
   expect_identical(stri_join(character(0), rep("a", 2), collapse="", ignore_null=TRUE), "aa")

   expect_identical(stri_paste(NULL, c("a", "b"), sep=" ", ignore_null = TRUE), paste(c("a", "b")))

   expect_identical(stri_join(NA_character_, LETTERS), rep(NA_character_, length(LETTERS)))
   expect_identical(stri_join(LETTERS, NA_character_), rep(NA_character_, length(LETTERS)))
   expect_identical(stri_join(c('\u0105', '\u0104')), c('\u0105', '\u0104'))
   expect_identical(stri_join(c('\u0105', '\u0104'), collapse=''), c('\u0105\u0104'))
   expect_identical(stri_join(c('\u0105', '\u0104'), collapse='!!!!!'), c('\u0105!!!!!\u0104'))
   expect_identical(stri_join(enc2native(c('\u0105', '\u0104'))), c('\u0105', '\u0104'))
   expect_identical(stri_join(enc2native(c('\u0105', '\u0104'))), enc2native(c('\u0105', '\u0104')))
   expect_identical(stri_join(LETTERS, letters, collapse=''), paste(LETTERS, letters, sep='', collapse=''))
   expect_identical(stri_join(LETTERS, letters, collapse='!'), paste(LETTERS, letters, sep='', collapse='!'))
   expect_identical(stri_join(LETTERS, letters, LETTERS), paste(LETTERS, letters, LETTERS, sep=''))
   expect_identical(stri_join(LETTERS, letters, LETTERS, collapse=''), paste(LETTERS, letters, LETTERS, sep='', collapse=''))
   expect_identical(stri_join(LETTERS, letters, LETTERS, collapse='!'), paste(LETTERS, letters, LETTERS, sep='', collapse='!'))
   expect_identical(stri_join(LETTERS, letters, LETTERS, letters[1]), paste(LETTERS, letters, LETTERS, letters[1], sep=''))
   expect_identical(stri_join(LETTERS, letters, '???'), paste(LETTERS, letters, '???', sep=''))
   expect_identical(stri_join(LETTERS, letters, sep='!'), paste(LETTERS, letters, sep='!'))
   expect_identical(stri_join(LETTERS, letters, '???', sep='!'), paste(LETTERS, letters, '???', sep='!'))
   expect_identical(stri_join(LETTERS, letters, "a", sep='!', collapse='???'), paste(LETTERS, letters, "a", sep='!', collapse='???'))
   expect_identical(stri_join(LETTERS, letters, sep='!', collapse='???'), paste(LETTERS, letters, sep='!', collapse='???'))
   expect_identical(stri_paste(stri_dup("aaaa",1000),"kot",NA), NA_character_)
   expect_identical(stri_paste(stri_dup("aaaa",1000),NA), NA_character_)
   expect_identical(stri_join(stri_dup(LETTERS, 1000), stri_dup(letters, 1000), stri_dup(LETTERS,100), NA),
      rep(NA_character_, 26))

   expect_identical(stri_paste(letters[1:3],1:6,collapse = " "), paste(letters[1:3],1:6,collapse = " ", sep=""))
   expect_identical(stri_paste(letters[1:3],1:6,collapse = ""), stri_paste(letters[1:3],1:6,"",collapse = ""))
   expect_identical(stri_paste(1:6,letters[1:3],collapse = " "), paste(1:6,letters[1:3],collapse = " ", sep=""))
   expect_identical(stri_paste(1:6,letters[1:3],collapse = ""), paste(1:6,letters[1:3],collapse = "", sep=""))
   expect_identical(stri_paste(letters[1:3],1:6,collapse = " ",sep=" "), paste(letters[1:3],1:6,collapse = " ", sep=" "))
   expect_identical(stri_paste(letters[1:3],1:6,collapse = NULL), paste(letters[1:3],1:6,collapse = NULL, sep=""))
   expect_identical(stri_paste(letters[1:3],1:6,"a",collapse = " "), paste(letters[1:3],1:6,"a", collapse = " ", sep=""))
   expect_identical(stri_paste(letters[1:3],1:6,"a",collapse = " "), paste(letters[1:3],1:6,"a",collapse = " ", sep=""))
   expect_identical(stri_paste(letters[1:3],1:6,LETTERS[1:2],collapse = " "), paste(letters[1:3],1:6,LETTERS[1:2],collapse = " ", sep=""))
})
