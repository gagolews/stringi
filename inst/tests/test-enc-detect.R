require(testthat)

test_that("stri_enc_isascii, stri_enc_isutf8", {

   expect_equivalent(stri_enc_isascii(character(0)), logical(0))
   expect_equivalent(stri_enc_isutf8(character(0)), logical(0))

   expect_equivalent(stri_enc_isascii(NA), NA)
   expect_equivalent(stri_enc_isutf8(NA), NA)

   x1 <- c("\u0105", NA, "\u0104", "\u00F1", "\u1e69") # nfc
   x2 <- c("\u0061\u0328", NA, "\u0041\u0328", "\u006E\u0303", "\u0073\u0323\u0307") # nfd
   expect_equivalent(stri_enc_isascii(x2), !c(T, NA, T, T, T))
   expect_equivalent(stri_enc_isascii(x1), !c(T, NA, T, T, T))
   expect_equivalent(stri_enc_isutf8(x2),  c(T, NA, T, T, T))
   expect_equivalent(stri_enc_isutf8(x1),  c(T, NA, T, T, T))
   expect_equivalent(stri_enc_isascii(letters), rep(T,26))
   expect_equivalent(stri_enc_isutf8(letters), rep(T,26))

})
