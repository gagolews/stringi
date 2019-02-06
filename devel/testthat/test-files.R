require(testthat)
context("test-files.R")

test_that("stri_read/write_lines", {

   text <- c('ala', 'al\u0105\u0104\u0105\u0104\u0118\u017b', 'es8 ug8es jgiose')
   fname <- tempfile()

   stri_write_lines(text, fname, 'utf16')
   expect_identical(text, stri_read_lines(fname, 'auto'))
   expect_identical(text, stri_read_lines(fname, 'utf16'))

   stri_write_lines(text, fname, 'utf8')
   expect_identical(text, stri_read_lines(fname, 'auto'))
   expect_identical(text, stri_read_lines(fname, 'utf8'))

   stri_write_lines(text, fname, 'utf32')
   expect_identical(text, stri_read_lines(fname, 'auto'))
   expect_identical(text, stri_read_lines(fname, 'utf32'))

   if (!stri_info()$ICU.UTF8) {
      stri_write_lines(text, fname, 'latin2')
      suppressMessages(oldCS <- stri_enc_set("latin2"))
      expect_identical(text, stri_read_lines(fname, 'auto'))
      suppressMessages(stri_enc_set(oldCS))
      expect_identical(text, stri_read_lines(fname, 'latin2'))
   }
})
