require(testthat)

test_that("stri_escape_unicode", {

   # basic tests (ASCII, border-line):

   expect_equivalent(stri_escape_unicode(character(0)), character(0))
   expect_equivalent(stri_escape_unicode(""), "")
   expect_equivalent(stri_escape_unicode(NA), NA_character_)

   expect_equivalent(stri_escape_unicode(letters), letters)
   #expect_equivalent(stri_escape_unicode("abc\u0105\U00100000"), "abc\\u0105\\U00100000")
   expect_equivalent(stri_escape_unicode("abc'\a\n\\n"), "abc\\'\\a\\n\\\\n")
   expect_error(stri_escape_unicode("\Ufffffff"))
})


test_that("stri_unescape_unicode", {

   # basic tests (ASCII, border-line):

   expect_equivalent(stri_unescape_unicode(character(0)), character(0))
   expect_equivalent(stri_unescape_unicode(""), "")
   expect_equivalent(stri_unescape_unicode(NA), NA_character_)

   expect_equivalent(stri_unescape_unicode(letters), letters)
   
   expect_warning(stri_unescape_unicode("\\Uffffffff"))

   s <- c("abc\u0105\U00100000", "abc'\a\n\\n")
   expect_equivalent(stri_unescape_unicode(stri_escape_unicode(s)), s)

   expect_warning(stri_unescape_unicode("\\ugisdo"))
   suppressWarnings(expect_equivalent(stri_unescape_unicode("\\ugisdo"), NA_character_))
})
