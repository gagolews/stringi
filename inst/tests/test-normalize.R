require(testthat)

test_that("stri_enc_nf*", {
   
   x1 <- c("\u0105", "\u0104", "\u00F1", "\u1e69") # nfc
   x2 <- c("\u0061\u0328", "\u0041\u0328", "\u006E\u0303", "\u0073\u0323\u0307") # nfd
   expect_equivalent(stri_enc_nfc(x2), x1)
   expect_equivalent(stri_enc_nfd(x1), x2)
   
   x1 <- c("\ufb01", "\u0032\u2075") # nfc, nfd
   x2 <- c("\u0066\u0069", "\u0032\u0035") # nfkc, nfkd
   expect_equivalent(stri_enc_nfc(x1), x1)
   expect_equivalent(stri_enc_nfc(x2), stri_enc_nfd(x2))
   expect_equivalent(stri_enc_nfkc(x1), stri_enc_nfkd(x1))
   expect_equivalent(stri_enc_nfc(x2), stri_enc_nfkc(x1))
   expect_equivalent(stri_enc_nfd(x2), stri_enc_nfkd(x1))
   expect_equivalent(stri_enc_nfkc_casefold(x1), x2)
   
   # stri_enc_nfkc_casefold("АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ")
})
