require(testthat)
context("test-trans-normalize.R")

test_that("stri_trans_nf*, stri_trans_isnf*", {

   x1 <- c("\u0105", NA, "\u0104", "\u00F1", "\u1e69") # nfc
   x2 <- c("\u0061\u0328", NA, "\u0041\u0328", "\u006E\u0303", "\u0073\u0323\u0307") # nfd
   expect_equivalent(stri_trans_isnfd(x2),  c(T, NA, T, T, T))
   expect_equivalent(stri_trans_isnfd(x1), !c(T, NA, T, T, T))
   expect_equivalent(stri_trans_isnfc(x2), !c(T, NA, T, T, T))
   expect_equivalent(stri_trans_isnfc(x1),  c(T, NA, T, T, T))
   expect_equivalent(stri_trans_nfc(x2), x1)
   expect_equivalent(stri_trans_nfd(x1), x2)

   x1 <- c(NA, "\ufb01", "\u0032\u2075") # nfc, nfd
   x2 <- c(NA, "\u0066\u0069", "\u0032\u0035") # nfkc, nfkd (& nfc, nfd)
   expect_equivalent(stri_trans_isnfc(x1),   c(NA, T, T))
   expect_equivalent(stri_trans_isnfd(x1),   c(NA, T, T))
   expect_equivalent(stri_trans_isnfkc(x2),  c(NA, T, T))
   expect_equivalent(stri_trans_isnfkd(x2),  c(NA, T, T))
   expect_equivalent(stri_trans_isnfkc(x1), !c(NA, T, T))
   expect_equivalent(stri_trans_isnfkd(x1), !c(NA, T, T))

   expect_equivalent(stri_trans_nfc(x1), x1)
   expect_equivalent(stri_trans_nfc(x2), stri_trans_nfd(x2))
   expect_equivalent(stri_trans_nfkc(x1), stri_trans_nfkd(x1))
   expect_equivalent(stri_trans_nfc(x2), stri_trans_nfkc(x1))
   expect_equivalent(stri_trans_nfd(x2), stri_trans_nfkd(x1))
   expect_equivalent(stri_trans_nfkc_casefold(x1), x2)

})
