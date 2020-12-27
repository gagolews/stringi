library("tinytest")
library("stringi")
library("stringr")

x1 <- c("ą", NA, "Ą", "ñ", "ṩ")  # nfc
x2 <- c("ą", NA, "Ą", "ñ", "ṩ")  # nfd
expect_equivalent(stri_trans_isnfd(x2), c(T, NA, T, T, T))
expect_equivalent(stri_trans_isnfd(x1), !c(T, NA, T, T, T))
expect_equivalent(stri_trans_isnfc(x2), !c(T, NA, T, T, T))
expect_equivalent(stri_trans_isnfc(x1), c(T, NA, T, T, T))
expect_equivalent(stri_trans_nfc(x2), x1)
expect_equivalent(stri_trans_nfd(x1), x2)

x1 <- c(NA, "ﬁ", "2⁵")  # nfc, nfd
x2 <- c(NA, "fi", "25")  # nfkc, nfkd (& nfc, nfd)
expect_equivalent(stri_trans_isnfc(x1), c(NA, T, T))
expect_equivalent(stri_trans_isnfd(x1), c(NA, T, T))
expect_equivalent(stri_trans_isnfkc(x2), c(NA, T, T))
expect_equivalent(stri_trans_isnfkd(x2), c(NA, T, T))
expect_equivalent(stri_trans_isnfkc(x1), !c(NA, T, T))
expect_equivalent(stri_trans_isnfkd(x1), !c(NA, T, T))

expect_equivalent(stri_trans_nfc(x1), x1)
expect_equivalent(stri_trans_nfc(x2), stri_trans_nfd(x2))
expect_equivalent(stri_trans_nfkc(x1), stri_trans_nfkd(x1))
expect_equivalent(stri_trans_nfc(x2), stri_trans_nfkc(x1))
expect_equivalent(stri_trans_nfd(x2), stri_trans_nfkd(x1))
expect_equivalent(stri_trans_nfkc_casefold(x1), x2)
