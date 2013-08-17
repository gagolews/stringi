require(testthat)

test_that("stri_escape_unicode", {

   # basic tests (ASCII, border-line):

   expect_equivalent(stri_escape_unicode(character(0)), character(0))
   expect_equivalent(stri_escape_unicode(""), "")
   expect_equivalent(stri_escape_unicode(NA), NA_character_)

   expect_equivalent(stri_escape_unicode(letters), letters)
   expect_equivalent(stri_escape_unicode("abc\u0105\U00100000"), "abc\\u0105\\U00100000")
   expect_equivalent(stri_escape_unicode("abc'\a\n\\n"), "abc\\'\\a\\n\\\\n")

})
