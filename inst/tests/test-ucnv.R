require(testthat)

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
