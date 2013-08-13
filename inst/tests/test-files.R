require(testthat)

test_that("stri_read/write_lines", {

   text <- c('ala', 'al\u0105', 'es8 ug8es jgiose')
   fname <- tempfile()

   stri_write_lines(text, fname, 'utf16')
#    expect_identical(text, stri_read_lines(fname, 'auto'))  # TO DO: BOMS!
   expect_identical(text, stri_read_lines(fname, 'utf16'))

#    x <- stri_read_lines(file.path(path.package('stringi'), 'textfiles/TH_utf8.txt'))
#    stri_encode(x, '', 'cp1250')
#
#    fname <- "~/Projekty/stringi/inst/textfiles/CZ_utf8.txt"
#    stopifnot(stri_read_lines(fname) == readLines(fname))
#    require(microbenchmark)
#    microbenchmark(
#       stri_read_lines(fname),
#       readLines(fname)
#    )
#
#    system.time(readLines('/tmp/test.txt'))
#    system.time(stri_read_lines('/tmp/test.txt', 'utf-8'))

})
