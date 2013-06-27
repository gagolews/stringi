require(testthat)

test_that("stri_dup", {

   # basic tests (ASCII, border-line):
   suppressWarnings(expect_identical(stri_dup(c("A", "B"), c(2,3,4)), c("AA", "BBB", "AAAA")))
   expect_warning(stri_dup(c("A", "B"), c(2,3,4)))
   
   expect_identical(stri_dup(NA,NA),NA_character_)
   expect_identical(stri_dup(NA,3),NA_character_)
   expect_identical(stri_dup("A",NA),NA_character_)
   expect_identical(stri_dup(character(0), integer(0)), character(0))
   expect_identical(stri_dup("char", integer(0)), character(0))
   expect_identical(stri_dup(character(0), 10), character(0))
   expect_identical(stri_dup(LETTERS, 1), LETTERS)
   expect_identical(stri_dup(LETTERS, 2), paste(LETTERS, LETTERS, sep=""))
   expect_identical(stri_dup("ABC", 0), "")
   expect_identical(stri_dup("A", c(1.5, 1.99, 0.1)), c("A", "A", ""))
   expect_warning(stri_dup("A", ":-("))
   expect_identical(stri_dup(c("ABC", "", "A"), c(0, 100, 0)), c("", "", ""))
   expect_identical(stri_dup("A", c(-1, 0, 1, NA)), c(NA, "", "A", NA))
   
   # UTF-8
   expect_identical(stri_dup('\u9999', 1:2), c('\u9999', '\u9999\u9999'))
   expect_identical(stri_dup('\u00109999', 2), '\u00109999\u00109999')
   
   # Other 8-bit encodings
   oldenc <- stri_enc_set('latin2')
   expect_identical(stri_dup('\xa1\xb1', 2), '\u0104\u0105\u0104\u0105')
   stri_enc_set(oldenc)
   
   oldenc <- stri_enc_set('cp1250')
   expect_identical(stri_dup('\xa5\xb9', 2), '\u0104\u0105\u0104\u0105')
   stri_enc_set(oldenc)
})


# expect_that(stri_dup("A", 3), is_identical_to(str_dup("A", 3)))
# expect_that(stri_dup(c("A", "B"), 3), is_identical_to(str_dup(c("A", "B"), 3)))
# expect_that(stri_dup(c("A", "B"), c(2,3)), is_identical_to(str_dup(c("A", "B"), c(2,3))))

# str_dup("A", -1)  # throws error
# stri_dup("A", -1) # returns NA

# str_dup("A", 0)  # empty
# stri_dup("A", 0) # empty

#  str_dup(c(NA, "A", "AA"), 3) # incorrect behavior
#  stri_dup(c(NA, "A", "AA"), 3)

# str_dup("A", c(NA, 1, 2))  # error
# stri_dup("A", c(NA, 1, 2)) # NA, A, AA
