require(testthat)


test_that("stri_encode", {

   expect_error(stri_encode("", "blahblahblah", "nosuchencoding"))

   expect_equivalent(stri_encode("", "", ""), "")
   expect_equivalent(stri_encode(NA_character_, "", ""), NA_character_)
   expect_equivalent(stri_encode(LETTERS, "", ""), LETTERS)

   expect_equivalent(stri_encode(LETTERS, "US-ASCII", "latin1"), LETTERS)
   expect_equivalent(stri_encode(letters, "latin1",   "UTF-8"),  letters)
   
   expect_equivalent(charToRaw(stri_encode("\u0105a", "", "cp1250")), as.raw(c(0xb9, 0x61)))
   expect_equivalent(stri_encode(NULL, "cp-1250", ""), NA_character_)
   expect_equivalent(stri_encode(as.raw(165), "cp-1250", "iso-8859-2", to_raw=TRUE)[[1]], as.raw(161))
   expect_equivalent(stri_encode(list(as.raw(165)), "cp-1250", "iso-8859-2", to_raw=TRUE)[[1]], as.raw(161))
   expect_error(stri_encode(list("shouldberaw"), "", ""))

   .polish_chars_latin2  <- rawToChar(as.raw(c(161, 198, 202, 163, 209,
      211, 166, 172, 175, 177, 230, 234, 179, 241, 243, 182, 188, 191)))
   Encoding(.polish_chars_latin2) <- "bytes"

   .polish_chars_cp1250  <- rawToChar(as.raw(c(165, 198, 202, 163, 209,
      211, 140, 143, 175, 185, 230, 234, 179, 241, 243, 156, 159, 191)))
   Encoding(.polish_chars_cp1250) <- "bytes"

   .polish_chars_utf8    <- intToUtf8(      (c(260, 262, 280, 321, 323,
      211, 346, 377, 379, 261, 263, 281, 322, 324, 243, 347, 378, 380)))
   Encoding(.polish_chars_utf8) <- "bytes"

   expect_equivalent(
      charToRaw(stri_encode(.polish_chars_latin2, "latin2", "cp1250")),
      charToRaw(.polish_chars_cp1250))
   expect_equivalent(
      charToRaw(stri_encode(.polish_chars_cp1250, "cp1250", "utf8")),
      charToRaw(.polish_chars_utf8))

   suppressWarnings(expect_warning(expect_equivalent(
      stri_encode(stri_encode(c("\u0105abc\u0104", NA, "\ufffd\u5432"), "UTF-8", "latin2", to_raw=TRUE), "latin2", "UTF-8"),
      c("\u0105abc\u0104",    NA,         "\032\032"))))
})


test_that("stri_enc_toutf32", {

   expect_identical(stri_enc_toutf32(character(0)), list())
   expect_identical(stri_enc_toutf32(LETTERS), as.list(65:90))
   expect_identical(stri_enc_toutf32(c("A", NA, "A")), list(65L, NULL, 65L))
   expect_identical(stri_enc_toutf32("a\u0105\u3423b")[[1]], utf8ToInt("a\u0105\u3423b"))
})


test_that("stri_enc_fromutf32", {

   expect_identical(stri_enc_fromutf32(integer(0)), "")
   expect_identical(stri_enc_fromutf32(c(65L, 66L, 67L)), "ABC")
   expect_identical(stri_enc_fromutf32(c(43,234,649,63,23532,23632)), intToUtf8(c(43,234,649,63,23532,23632)))
   expect_warning(stri_enc_fromutf32(c(43,234,649,63,23532,233643642)))

   expect_identical(stri_enc_fromutf32(list()), character(0))
   expect_identical(stri_enc_fromutf32(list(NULL)), NA_character_)
   expect_identical(stri_enc_fromutf32(list(65:67, NULL)), c("ABC", NA_character_))
})



test_that("stri_enc_toutf8", {

   expect_identical(stri_enc_toutf8(character(0)), character(0))
   expect_identical(stri_enc_toutf8(LETTERS), LETTERS)
   s <- c('sgajhgaoi', NA, '\u0105fds\u5432\u0104')
   expect_identical(stri_enc_toutf8(s), s)

   s <- c('\xa3\xb1ka')
   enc <- stri_enc_set('latin-2')
   expect_identical(stri_enc_toutf8(s), "\u0141\u0105ka")
   stri_enc_set(enc)
   expect_identical(stri_enc_toutf8(s, is_unknown_8bit=TRUE), "\ufffd\ufffdka")
})


test_that("stri_enc_toascii", {

   expect_identical(stri_enc_toascii(character(0)), character(0))
   expect_identical(stri_enc_toascii(LETTERS), LETTERS)
   expect_identical(stri_enc_toascii(c('sgajhgaoi', NA, '\u0105fds\u5432\u0104')), c('sgajhgaoi', NA, '\x1afds\x1a\x1a'))

   s <- c('\xa3\xb1ka')
   enc <- stri_enc_set('latin-2')
   expect_identical(stri_enc_toascii(s), "\x1a\x1aka")
   stri_enc_set(enc)
})
