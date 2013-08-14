require(testthat)


test_that("stri_enc_isascii",{
   expect_identical(stri_enc_isascii(character(0)),logical(0))
   expect_identical(stri_enc_isascii(NA),NA)
   expect_identical(stri_enc_isascii(letters),rep(TRUE,26))
   expect_identical(stri_enc_isascii("\u0120\u0130\u2432"),FALSE)
   expect_identical(stri_enc_isascii("S\xe9bastien"),FALSE)

   expect_equivalent(stri_enc_isascii(NULL), NA)
   expect_equivalent(stri_enc_isascii(character(0)), logical(0))
   expect_equivalent(stri_enc_isascii(list()), logical(0))
   expect_equivalent(stri_enc_isascii(NA), NA)

   expect_equivalent(stri_enc_isascii(as.raw(c(65,66,67))), TRUE)
   expect_equivalent(stri_enc_isascii(as.raw(c(65,66,128))), FALSE)
   expect_equivalent(stri_enc_isascii(list(as.raw(65), as.raw(128))), c(TRUE, FALSE))

   expect_equivalent(stri_enc_isascii(letters), rep(T,26))
   expect_equivalent(stri_enc_isascii('abc'), TRUE)
})


test_that("stri_enc_isutf8",{
   expect_identical(stri_enc_isutf8(character(0)),logical(0))
   expect_identical(stri_enc_isutf8(NA),NA)
   expect_identical(stri_enc_isutf8(letters),rep(TRUE,26))
   expect_identical(stri_enc_isutf8("\u0120\u0130\u2432"),TRUE)
   expect_identical(stri_enc_isutf8("S\xe9bastien"),FALSE)

   expect_equivalent(stri_enc_isutf8(NULL), NA)
   expect_equivalent(stri_enc_isutf8(character(0)), logical(0))
   expect_equivalent(stri_enc_isutf8(list()), logical(0))
   expect_equivalent(stri_enc_isutf8(NA), NA)
   expect_equivalent(stri_enc_isutf8(as.raw(c(65,66,67))), TRUE)
   expect_equivalent(stri_enc_isutf8(as.raw(c(65,66,128))), FALSE)
   expect_equivalent(stri_enc_isutf8(list(as.raw(65), as.raw(128))), c(TRUE, FALSE))

   expect_equivalent(stri_enc_isutf8(letters), rep(T,26))
   expect_equivalent(stri_enc_isutf8('abc'),  TRUE)

   x1 <- stri_enc_fromutf32(c(65, 105, 254, 3253, 65537, 1114109))
   x2 <- stri_flatten(letters)
   x3 <- stri_enc_fromutf32(c(65:255))
   expect_equivalent(stri_enc_isutf8(stri_encode(c(x1, x2, x3), "", "UTF-8", to_raw=TRUE)),    c(TRUE, TRUE, TRUE))
   expect_equivalent(stri_enc_isutf8(stri_encode(c(x1, x2, x3), "", "UTF-16BE", to_raw=TRUE)), c(FALSE, FALSE, FALSE))
   expect_equivalent(stri_enc_isutf8(stri_encode(c(x1, x2, x3), "", "UTF-16LE", to_raw=TRUE)), c(FALSE, FALSE, FALSE))
   expect_equivalent(stri_enc_isutf8(stri_encode(c(x1, x2, x3), "", "UTF-32BE", to_raw=TRUE)), c(FALSE, FALSE, FALSE))
   expect_equivalent(stri_enc_isutf8(stri_encode(c(x1, x2, x3), "", "UTF-32LE", to_raw=TRUE)), c(FALSE, FALSE, FALSE))
})


test_that("stri_enc_isutf16",{
   x1 <- stri_enc_fromutf32(c(65, 105, 254, 3253, 65537, 1114109))
   x3 <- stri_enc_fromutf32(c(65:255))
   x2 <- stri_flatten(letters)
   expect_equivalent(stri_enc_isutf16le(stri_encode(x1, "", "UTF-16LE", to_raw=TRUE)), TRUE)
   expect_equivalent(stri_enc_isutf16be(stri_encode(x1, "", "UTF-16BE", to_raw=TRUE)), TRUE)
   expect_equivalent(stri_enc_isutf16le(stri_encode(x1, "", "UTF-8", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf16be(stri_encode(x1, "", "UTF-8", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf16le(stri_encode(x1, "", "UTF-32LE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf16be(stri_encode(x1, "", "UTF-32LE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf16le(stri_encode(x1, "", "UTF-32", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf16be(stri_encode(x1, "", "UTF-32", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf16le(stri_encode(x1, "", "UTF-32BE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf16be(stri_encode(x1, "", "UTF-32BE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf16le(stri_encode(x2, "", "UTF-16LE", to_raw=TRUE)), TRUE)
   expect_equivalent(stri_enc_isutf16be(stri_encode(x2, "", "UTF-16BE", to_raw=TRUE)), TRUE)

   expect_equivalent(stri_enc_isutf16le(stri_encode(x1, "", "UTF-16BE", to_raw=TRUE)), TRUE) # :-(
   expect_equivalent(stri_enc_isutf16be(stri_encode(x1, "", "UTF-16LE", to_raw=TRUE)), TRUE) # :-(
   expect_equivalent(stri_enc_isutf16be(stri_encode(x2, "", "UTF-16LE", to_raw=TRUE)), TRUE) # :-(
   expect_equivalent(stri_enc_isutf16le(stri_encode(x2, "", "UTF-16BE", to_raw=TRUE)), TRUE) # :-(

   expect_equivalent(stri_enc_isutf16le(stri_encode(x3, "", "UTF-16BE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf16be(stri_encode(x3, "", "UTF-16LE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf16be(stri_encode(x3, "", "UTF-16BE", to_raw=TRUE)), TRUE)
   expect_equivalent(stri_enc_isutf16le(stri_encode(x3, "", "UTF-16LE", to_raw=TRUE)), TRUE)

   l <- (.Platform$endian == 'little')
   expect_equivalent(stri_enc_isutf16le(stri_encode(x1, "", "UTF-16", to_raw=TRUE)), l)
   expect_equivalent(stri_enc_isutf16le(stri_encode(x2, "", "UTF-16", to_raw=TRUE)), l)
   expect_equivalent(stri_enc_isutf16le(stri_encode(x3, "", "UTF-16", to_raw=TRUE)), l)
   expect_equivalent(stri_enc_isutf16be(stri_encode(x1, "", "UTF-16", to_raw=TRUE)), !l)
   expect_equivalent(stri_enc_isutf16be(stri_encode(x2, "", "UTF-16", to_raw=TRUE)), !l)
   expect_equivalent(stri_enc_isutf16be(stri_encode(x3, "", "UTF-16", to_raw=TRUE)), !l)
})


test_that("stri_enc_isutf32",{
   x1 <- stri_enc_fromutf32(c(65, 105, 254, 3253, 65537, 1114109))
   x3 <- stri_enc_fromutf32(c(65:255))
   x2 <- stri_flatten(letters)
   expect_equivalent(stri_enc_isutf32le(stri_encode(x1, "", "UTF-32LE", to_raw=TRUE)), TRUE)
   expect_equivalent(stri_enc_isutf32be(stri_encode(x1, "", "UTF-32BE", to_raw=TRUE)), TRUE)
   expect_equivalent(stri_enc_isutf32le(stri_encode(x1, "", "UTF-32BE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf32be(stri_encode(x1, "", "UTF-32LE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf32le(stri_encode(x1, "", "UTF-16LE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf32be(stri_encode(x1, "", "UTF-16LE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf32le(stri_encode(x1, "", "UTF-16BE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf32be(stri_encode(x1, "", "UTF-16BE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf32le(stri_encode(x1, "", "UTF-16", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf32be(stri_encode(x1, "", "UTF-16", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf32le(stri_encode(x1, "", "UTF-8", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf32be(stri_encode(x1, "", "UTF-8", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf32le(stri_encode(x2, "", "UTF-32LE", to_raw=TRUE)), TRUE)
   expect_equivalent(stri_enc_isutf32be(stri_encode(x2, "", "UTF-32BE", to_raw=TRUE)), TRUE)
   expect_equivalent(stri_enc_isutf32be(stri_encode(x2, "", "UTF-32LE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf32le(stri_encode(x2, "", "UTF-32BE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf32le(stri_encode(x3, "", "UTF-32LE", to_raw=TRUE)), TRUE)
   expect_equivalent(stri_enc_isutf32be(stri_encode(x3, "", "UTF-32BE", to_raw=TRUE)), TRUE)
   expect_equivalent(stri_enc_isutf32be(stri_encode(x3, "", "UTF-32LE", to_raw=TRUE)), FALSE)
   expect_equivalent(stri_enc_isutf32le(stri_encode(x3, "", "UTF-32BE", to_raw=TRUE)), FALSE)

   l <- (.Platform$endian == 'little')
   expect_equivalent(stri_enc_isutf32le(stri_encode(x1, "", "UTF-32", to_raw=TRUE)), l)
   expect_equivalent(stri_enc_isutf32le(stri_encode(x2, "", "UTF-32", to_raw=TRUE)), l)
   expect_equivalent(stri_enc_isutf32le(stri_encode(x3, "", "UTF-32", to_raw=TRUE)), l)
   expect_equivalent(stri_enc_isutf32be(stri_encode(x1, "", "UTF-32", to_raw=TRUE)), !l)
   expect_equivalent(stri_enc_isutf32be(stri_encode(x2, "", "UTF-32", to_raw=TRUE)), !l)
   expect_equivalent(stri_enc_isutf32be(stri_encode(x3, "", "UTF-32", to_raw=TRUE)), !l)
})


test_that("stri_enc_isascii, stri_enc_isutf8", {
   x1 <- c("\u0105", NA, "\u0104", "\u00F1", "\u1e69") # nfc
   x2 <- c("\u0061\u0328", NA, "\u0041\u0328", "\u006E\u0303", "\u0073\u0323\u0307") # nfd
   expect_equivalent(stri_enc_isascii(x2), !c(T, NA, T, T, T))
   expect_equivalent(stri_enc_isascii(x1), !c(T, NA, T, T, T))
   expect_equivalent(stri_enc_isutf8(x2),  c(T, NA, T, T, T))
   expect_equivalent(stri_enc_isutf8(x1),  c(T, NA, T, T, T))
})


test_that("stri_enc_detect", {

   expect_equivalent(stri_enc_detect(as.raw(c(65:100)))[[1]]$Encoding[1], "UTF-8")

   expect_equivalent(stri_enc_detect2("abc")[[1]]$Encoding, "ASCII")

   expect_equivalent(stri_enc_detect2(stri_encode("abc", "", "UTF-16", to_raw=TRUE))[[1]]$Encoding, "UTF-16")
   expect_equivalent(stri_enc_detect2(stri_encode("abc", "", "UTF-16LE", to_raw=TRUE))[[1]]$Encoding, "UTF-16LE")
   expect_equivalent(stri_enc_detect2(stri_encode("abc", "", "UTF-16BE", to_raw=TRUE))[[1]]$Encoding, "UTF-16BE")
   expect_equivalent(stri_enc_detect2(stri_encode("abc", "", "UTF-32", to_raw=TRUE))[[1]]$Encoding, "UTF-32")
   expect_equivalent(stri_enc_detect2(stri_encode("abc", "", "UTF-32LE", to_raw=TRUE))[[1]]$Encoding, "UTF-32LE")
   expect_equivalent(stri_enc_detect2(stri_encode("abc", "", "UTF-32BE", to_raw=TRUE))[[1]]$Encoding, "UTF-32BE")

   text <- stri_flatten(stri_enc_fromutf32(65:127))
   expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-8", to_raw=TRUE))[[1]]$Encoding, "ASCII")
   expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-16", to_raw=TRUE))[[1]]$Encoding, "UTF-16")
   expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-16LE", to_raw=TRUE))[[1]]$Encoding, "UTF-16LE")
   expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-16BE", to_raw=TRUE))[[1]]$Encoding, "UTF-16BE")
   expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-32", to_raw=TRUE))[[1]]$Encoding, "UTF-32")
   expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-32LE", to_raw=TRUE))[[1]]$Encoding, "UTF-32LE")
   expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-32BE", to_raw=TRUE))[[1]]$Encoding, "UTF-32BE")

   text <- stri_flatten(stri_enc_fromutf32(65:1024))
   expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-8", to_raw=TRUE))[[1]]$Encoding, "UTF-8")
   expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-16", to_raw=TRUE))[[1]]$Encoding, "UTF-16")
   expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-16LE", to_raw=TRUE))[[1]]$Encoding, "UTF-16LE")
   expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-16BE", to_raw=TRUE))[[1]]$Encoding, "UTF-16BE")
   expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-32", to_raw=TRUE))[[1]]$Encoding, "UTF-32")
   expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-32LE", to_raw=TRUE))[[1]]$Encoding, "UTF-32LE")
   expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-32BE", to_raw=TRUE))[[1]]$Encoding, "UTF-32BE")
   
   fnames <- c(file.path(path.package('stringi'), 'textfiles/CZ_utf8.txt'),
               file.path(path.package('stringi'), 'textfiles/DE_utf8.txt'),
               file.path(path.package('stringi'), 'textfiles/PL_utf8.txt'),
               file.path(path.package('stringi'), 'textfiles/ES_utf8.txt'),
               file.path(path.package('stringi'), 'textfiles/RU_utf8.txt')
#                file.path(path.package('stringi'), 'textfiles/TH_utf8.txt')
               )
   
   for (f in fnames) {
      text <- stri_encode(stri_read_raw(f), "", "UTF-8")
      expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-8", to_raw=TRUE))[[1]]$Encoding, "UTF-8")
      expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-16", to_raw=TRUE))[[1]]$Encoding, "UTF-16")
      expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-16LE", to_raw=TRUE))[[1]]$Encoding, "UTF-16LE")
      expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-16BE", to_raw=TRUE))[[1]]$Encoding, "UTF-16BE")
      expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-32", to_raw=TRUE))[[1]]$Encoding, "UTF-32")
      expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-32LE", to_raw=TRUE))[[1]]$Encoding, "UTF-32LE")
      expect_equivalent(stri_enc_detect2(stri_encode(text, "", "UTF-32BE", to_raw=TRUE))[[1]]$Encoding, "UTF-32BE")
   }
})
