require(testthat)

test_that("stri_read/write_lines", {

   text <- c('ala', 'al\u0105', 'es8 ug8es jgiose')
   fname <- tempfile()

   stri_write_lines(text, fname, 'utf16')
   expect_identical(text, stri_read_lines(fname, 'auto'))  # TO DO: BOMS!
   expect_identical(text, stri_read_lines(fname, 'utf16'))
})
