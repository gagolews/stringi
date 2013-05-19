require(testthat)

test_that("stri_join", {
   
   expect_identical(stri_join(LETTERS, LETTERS, sep=NA), rep(NA_character_, length(LETTERS)))
   expect_identical(stri_join(LETTERS, sep=NA), rep(NA_character_, length(LETTERS)))
   expect_identical(stri_join(character(0), character(0)), character(0))
   expect_error(stri_join(LETTERS, LETTERS, sep=character(0)))
   expect_warning(stri_join(LETTERS, LETTERS, sep=LETTERS))
   expect_error(stri_join(LETTERS, LETTERS, sep=character(0)))
   expect_error(stri_join(LETTERS, LETTERS, sep=mean))
   expect_identical(stri_join(NA_character_, LETTERS), rep(NA_character_, length(LETTERS)))
   expect_identical(stri_join(LETTERS, NA_character_), rep(NA_character_, length(LETTERS)))
   expect_identical(stri_join(c('\u0105', '\u104')), c('\u0105', '\u104'))
   expect_identical(stri_join(c('\u0105', '\u104'), collapse=''), c('\u0105\u104'))
   expect_identical(stri_join(LETTERS, letters), paste(LETTERS, letters, sep=''))
   expect_identical(stri_join(LETTERS, letters, '?'), paste(LETTERS, letters, '?', sep=''))
   expect_identical(stri_join(LETTERS, letters, sep='!'), paste(LETTERS, letters, sep='!'))
   expect_identical(stri_join(LETTERS, letters, '?', sep='!'), paste(LETTERS, letters, '?', sep='!'))
   expect_identical(stri_join(LETTERS, letters, sep='!', collapse='?'), paste(LETTERS, letters, sep='!', collapse='?'))
   
})
