require(testthat)


test_that("stri_ucnv_encode", {
   
   suppressWarnings(expect_equivalent(
      stri_ucnv_encode(rep("", 10), "blahblahblah", "nosuchencoding"),
      rep(NA_character_, 10)))
   expect_warning(stri_ucnv_encode("", "blahblahblah", "nosuchencoding"))
   
   expect_equivalent(stri_ucnv_encode("", "", ""), "")
   expect_equivalent(stri_ucnv_encode(LETTERS, "", ""), LETTERS)
   
   expect_equivalent(stri_ucnv_encode(LETTERS, "US-ASCII", "latin1"), LETTERS)
   expect_equivalent(stri_ucnv_encode(letters, "latin1",   "UTF-8"),  letters)
   
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
      charToRaw(stri_ucnv_encode(.polish_chars_latin2, "latin2", "cp1250")),
      charToRaw(.polish_chars_cp1250))
   expect_equivalent(
      charToRaw(stri_ucnv_encode(.polish_chars_cp1250, "cp1250", "utf8")),
      charToRaw(.polish_chars_utf8))
   
})



test_that("stri_ucnv_enclist, stri_ucnv_encinfo", {

   # basic tests (ASCII, border-line):
   
   expect_true(length(stri_ucnv_enclist())>0)
      
   expect_true(length(sapply(
      stri_ucnv_enclist(),
      function(enc) stri_ucnv_encinfo(enc[[1]])$Name.friendly)) > 0)
   
   expect_equivalent(stri_ucnv_encinfo("CP-1250")$Name.friendly, "windows-1250") # CE
   expect_equivalent(stri_ucnv_encinfo("CP-1251")$Name.friendly, "windows-1251") # Cyrillic
   expect_equivalent(stri_ucnv_encinfo("CP-1252")$Name.friendly, "windows-1252") # WE
   expect_equivalent(stri_ucnv_encinfo("CP-1253")$Name.friendly, "windows-1253") # Greek
   expect_equivalent(stri_ucnv_encinfo("CP-1254")$Name.friendly, "windows-1254") # Turkish
   expect_equivalent(stri_ucnv_encinfo("CP-1255")$Name.friendly, "windows-1255") # Hebrew
   expect_equivalent(stri_ucnv_encinfo("CP-1256")$Name.friendly, "windows-1256") # Arabic
   expect_equivalent(stri_ucnv_encinfo("CP-1257")$Name.friendly, "windows-1257") # Baltic
   expect_equivalent(stri_ucnv_encinfo("CP-1258")$Name.friendly, "windows-1258") # Vietnamese
   expect_equivalent(stri_ucnv_encinfo("latin1")$Name.friendly, "ISO-8859-1") # WE
   expect_equivalent(stri_ucnv_encinfo("latin2")$Name.friendly, "ISO-8859-2") # CE
   expect_equivalent(stri_ucnv_encinfo("UTF-8")$Name.friendly, "UTF-8")
   expect_equivalent(stri_ucnv_encinfo("ASCII")$Name.friendly, "US-ASCII")
   expect_equivalent(stri_ucnv_encinfo("Big5")$Name.friendly, "Big5") # Trad. Chinese
   expect_equivalent(stri_ucnv_encinfo("EUC-CN")$Name.friendly, "GB2312") # Simpl. Chinese
   expect_equivalent(stri_ucnv_encinfo("EUC-JP")$Name.friendly, "EUC-JP") # Japanese
   expect_equivalent(stri_ucnv_encinfo("Shift-JIS")$Name.friendly, "Shift_JIS") # Japanese
   expect_equivalent(stri_ucnv_encinfo("EUC-KR")$Name.friendly, "EUC-KR") # Korean
})
