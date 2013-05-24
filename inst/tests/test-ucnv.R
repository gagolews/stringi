require(testthat)


test_that("stri_encode", {
   
   expect_error(stri_encode("", "blahblahblah", "nosuchencoding"))
   
   expect_equivalent(stri_encode("", "", ""), "")
   expect_equivalent(stri_encode(LETTERS, "", ""), LETTERS)
   
   expect_equivalent(stri_encode(LETTERS, "US-ASCII", "latin1"), LETTERS)
   expect_equivalent(stri_encode(letters, "latin1",   "UTF-8"),  letters)
   
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
   
})



test_that("stri_enc_list, stri_enc_info", {

   # basic tests (ASCII, border-line):
   
   expect_true(length(stri_enc_list())>0)
      
   suppressWarnings(expect_true(length(sapply(
      stri_enc_list(),
      function(enc) stri_enc_info(enc[[1]])$Name.friendly
   )) > 0))
   
   expect_equivalent(stri_enc_info("CP-1250")$Name.friendly, "windows-1250") # CE
   expect_equivalent(stri_enc_info("CP-1251")$Name.friendly, "windows-1251") # Cyrillic
   expect_equivalent(stri_enc_info("CP-1252")$Name.friendly, "windows-1252") # WE
   expect_equivalent(stri_enc_info("CP-1253")$Name.friendly, "windows-1253") # Greek
   expect_equivalent(stri_enc_info("CP-1254")$Name.friendly, "windows-1254") # Turkish
   expect_equivalent(stri_enc_info("CP-1255")$Name.friendly, "windows-1255") # Hebrew
   expect_equivalent(stri_enc_info("CP-1256")$Name.friendly, "windows-1256") # Arabic
   expect_equivalent(stri_enc_info("CP-1257")$Name.friendly, "windows-1257") # Baltic
   expect_equivalent(stri_enc_info("CP-1258")$Name.friendly, "windows-1258") # Vietnamese
   expect_equivalent(stri_enc_info("latin1")$Name.friendly, "ISO-8859-1") # WE
   expect_equivalent(stri_enc_info("latin2")$Name.friendly, "ISO-8859-2") # CE
   expect_equivalent(stri_enc_info("UTF-8")$Name.friendly, "UTF-8")
   expect_equivalent(stri_enc_info("ASCII")$Name.friendly, "US-ASCII")
   expect_equivalent(stri_enc_info("Big5")$Name.friendly, "Big5") # Trad. Chinese
   expect_equivalent(stri_enc_info("EUC-CN")$Name.friendly, "GB2312") # Simpl. Chinese
   expect_equivalent(stri_enc_info("EUC-JP")$Name.friendly, "EUC-JP") # Japanese
   expect_equivalent(stri_enc_info("Shift-JIS")$Name.friendly, "Shift_JIS") # Japanese
   expect_equivalent(stri_enc_info("EUC-KR")$Name.friendly, "EUC-KR") # Korean
})


test_that("stri_enc_isascii",{
   expect_identical(stri_enc_isascii(character(0)),logical(0))
   expect_identical(stri_enc_isascii(NA),NA)
   expect_identical(stri_enc_isascii(letters),rep(TRUE,26))
   expect_identical(stri_enc_isascii("\u0120\u0130\u2432"),FALSE)
   expect_identical(stri_enc_isascii("S\xe9bastien"),FALSE)
   
})


test_that("stri_enc_isutf8",{
   expect_identical(stri_enc_isutf8(character(0)),logical(0))
   expect_identical(stri_enc_isutf8(NA),NA)
   expect_identical(stri_enc_isutf8(letters),rep(TRUE,26))
   expect_identical(stri_enc_isutf8("\u0120\u0130\u2432"),TRUE)
   expect_identical(stri_enc_isutf8("S\xe9bastien"),FALSE)
   
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


