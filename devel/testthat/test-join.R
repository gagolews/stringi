require(testthat)

test_that("stri_join", {
   
   # we have many specialized functions for join, e.g.
   # flatten with sep
   # flatten with no sep
   # join2 with sep and no collapse
   # join2 with sep and collapse
   # join - general, with collapse
   # join - general, no collapse

   expect_identical(stri_join(LETTERS, LETTERS, sep=NA), rep(NA_character_, length(LETTERS)))
   expect_identical(stri_join(LETTERS, LETTERS, sep=NA, collapse=NA), NA_character_)
   expect_identical(stri_join(LETTERS, sep=NA), rep(NA_character_, length(LETTERS)))
   expect_identical(stri_join(character(0), character(0)), character(0))
   expect_error(stri_join(LETTERS, LETTERS, sep=character(0)))
   expect_warning(stri_join(LETTERS, LETTERS, sep=LETTERS))
   expect_error(stri_join(LETTERS, LETTERS, sep=character(0)))
   expect_error(stri_join(LETTERS, LETTERS, sep=mean))
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
})
