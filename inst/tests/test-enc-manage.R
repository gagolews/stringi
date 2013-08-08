require(testthat)


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


