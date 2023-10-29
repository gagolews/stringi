library("tinytest")
library("stringi")


x1 <- c("\u0105", NA, "\u0104", "\u00F1", "\u1E69")  # nfc
x2 <- c("a\u0328", NA, "A\u0328", "n\u0303", "s\u0323\u0307")  # nfd
expect_equivalent(stri_trans_isnfd(x2), c(T, NA, T, T, T))
expect_equivalent(stri_trans_isnfd(x1), !c(T, NA, T, T, T))
expect_equivalent(stri_trans_isnfc(x2), !c(T, NA, T, T, T))
expect_equivalent(stri_trans_isnfc(x1), c(T, NA, T, T, T))
expect_equivalent(stri_trans_nfc(x2), x1)
expect_equivalent(stri_trans_nfd(x1), x2)

x1 <- c(NA, "\uFB01", "2\u2075")  # nfc, nfd
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
