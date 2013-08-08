require(testthat)


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


test_that("stri_enc_isascii, stri_enc_isutf8", {

   expect_equivalent(stri_enc_isascii(NULL), NA)
   expect_equivalent(stri_enc_isutf8(NULL), NA)
   
   expect_equivalent(stri_enc_isascii(character(0)), logical(0))
   expect_equivalent(stri_enc_isutf8(character(0)), logical(0))
   
   expect_equivalent(stri_enc_isascii(list()), logical(0))
   expect_equivalent(stri_enc_isutf8(list()), logical(0))

   expect_equivalent(stri_enc_isascii(NA), NA)
   expect_equivalent(stri_enc_isutf8(NA), NA)

   expect_equivalent(stri_enc_isascii(as.raw(c(65,66,67))), TRUE)
   expect_equivalent(stri_enc_isascii(as.raw(c(65,66,128))), FALSE)
   expect_equivalent(stri_enc_isutf8(as.raw(c(65,66,67))), TRUE)
   expect_equivalent(stri_enc_isutf8(as.raw(c(65,66,128))), FALSE)
   expect_equivalent(stri_enc_isascii(list(as.raw(65), as.raw(128))), c(TRUE, FALSE))
   expect_equivalent(stri_enc_isutf8(list(as.raw(65), as.raw(128))), c(TRUE, FALSE))
   
   x1 <- c("\u0105", NA, "\u0104", "\u00F1", "\u1e69") # nfc
   x2 <- c("\u0061\u0328", NA, "\u0041\u0328", "\u006E\u0303", "\u0073\u0323\u0307") # nfd
   expect_equivalent(stri_enc_isascii(x2), !c(T, NA, T, T, T))
   expect_equivalent(stri_enc_isascii(x1), !c(T, NA, T, T, T))
   expect_equivalent(stri_enc_isutf8(x2),  c(T, NA, T, T, T))
   expect_equivalent(stri_enc_isutf8(x1),  c(T, NA, T, T, T))
   expect_equivalent(stri_enc_isascii(letters), rep(T,26))
   expect_equivalent(stri_enc_isutf8(letters), rep(T,26))
   expect_equivalent(stri_enc_isascii('abc'), TRUE)
   expect_equivalent(stri_enc_isutf8('abc'),  TRUE)

})


test_that("stri_enc_detect", {
   
   expect_equivalent(stri_enc_detect(as.raw(c(65:100)))[[1]]$Encoding, "UTF-8")
   
})
