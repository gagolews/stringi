library("tinytest")
library("stringi")


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
expect_equivalent(stri_enc_isutf8(stri_encode(c(x1, x2, x3), "UTF-8", "UTF-8", to_raw=TRUE)),    c(TRUE, TRUE, TRUE))
expect_equivalent(stri_enc_isutf8(stri_encode(c(x1, x2, x3), "UTF-8", "UTF-16BE", to_raw=TRUE)), c(FALSE, FALSE, FALSE))
expect_equivalent(stri_enc_isutf8(stri_encode(c(x1, x2, x3), "UTF-8", "UTF-16LE", to_raw=TRUE)), c(FALSE, FALSE, FALSE))
expect_equivalent(stri_enc_isutf8(stri_encode(c(x1, x2, x3), "UTF-8", "UTF-32BE", to_raw=TRUE)), c(FALSE, FALSE, FALSE))
expect_equivalent(stri_enc_isutf8(stri_encode(c(x1, x2, x3), "UTF-8", "UTF-32LE", to_raw=TRUE)), c(FALSE, FALSE, FALSE))


x1 <- stri_enc_fromutf32(c(65, 105, 254, 3253, 65537, 1114109))
x3 <- stri_enc_fromutf32(c(65:255))
x2 <- stri_flatten(letters)
expect_equivalent(stri_enc_isutf16le(stri_encode(x1, "UTF-8", "UTF-16LE", to_raw=TRUE)), TRUE)
expect_equivalent(stri_enc_isutf16be(stri_encode(x1, "UTF-8", "UTF-16BE", to_raw=TRUE)), TRUE)
expect_equivalent(stri_enc_isutf16le(stri_encode(x1, "UTF-8", "UTF-8", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf16be(stri_encode(x1, "UTF-8", "UTF-8", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf16le(stri_encode(x1, "UTF-8", "UTF-32LE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf16be(stri_encode(x1, "UTF-8", "UTF-32LE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf16le(stri_encode(x1, "UTF-8", "UTF-32", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf16be(stri_encode(x1, "UTF-8", "UTF-32", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf16le(stri_encode(x1, "UTF-8", "UTF-32BE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf16be(stri_encode(x1, "UTF-8", "UTF-32BE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf16le(stri_encode(x2, "UTF-8", "UTF-16LE", to_raw=TRUE)), TRUE)
expect_equivalent(stri_enc_isutf16be(stri_encode(x2, "UTF-8", "UTF-16BE", to_raw=TRUE)), TRUE)

expect_equivalent(stri_enc_isutf16le(stri_encode(x1, "UTF-8", "UTF-16BE", to_raw=TRUE)), TRUE) # :-(
expect_equivalent(stri_enc_isutf16be(stri_encode(x1, "UTF-8", "UTF-16LE", to_raw=TRUE)), TRUE) # :-(
expect_equivalent(stri_enc_isutf16be(stri_encode(x2, "UTF-8", "UTF-16LE", to_raw=TRUE)), TRUE) # :-(
expect_equivalent(stri_enc_isutf16le(stri_encode(x2, "UTF-8", "UTF-16BE", to_raw=TRUE)), TRUE) # :-(

expect_equivalent(stri_enc_isutf16le(stri_encode(x3, "UTF-8", "UTF-16BE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf16be(stri_encode(x3, "UTF-8", "UTF-16LE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf16be(stri_encode(x3, "UTF-8", "UTF-16BE", to_raw=TRUE)), TRUE)
expect_equivalent(stri_enc_isutf16le(stri_encode(x3, "UTF-8", "UTF-16LE", to_raw=TRUE)), TRUE)

l <- (.Platform$endian == 'little')
expect_equivalent(stri_enc_isutf16le(stri_encode(x1, "UTF-8", "UTF-16", to_raw=TRUE)), l)
expect_equivalent(stri_enc_isutf16le(stri_encode(x2, "UTF-8", "UTF-16", to_raw=TRUE)), l)
expect_equivalent(stri_enc_isutf16le(stri_encode(x3, "UTF-8", "UTF-16", to_raw=TRUE)), l)
expect_equivalent(stri_enc_isutf16be(stri_encode(x1, "UTF-8", "UTF-16", to_raw=TRUE)), !l)
expect_equivalent(stri_enc_isutf16be(stri_encode(x2, "UTF-8", "UTF-16", to_raw=TRUE)), !l)
expect_equivalent(stri_enc_isutf16be(stri_encode(x3, "UTF-8", "UTF-16", to_raw=TRUE)), !l)


x1 <- stri_enc_fromutf32(c(65, 105, 254, 3253, 65537, 1114109))
x3 <- stri_enc_fromutf32(c(65:255))
x2 <- stri_flatten(letters)
expect_equivalent(stri_enc_isutf32le(stri_encode(x1, "UTF-8", "UTF-32LE", to_raw=TRUE)), TRUE)
expect_equivalent(stri_enc_isutf32be(stri_encode(x1, "UTF-8", "UTF-32BE", to_raw=TRUE)), TRUE)
expect_equivalent(stri_enc_isutf32le(stri_encode(x1, "UTF-8", "UTF-32BE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf32be(stri_encode(x1, "UTF-8", "UTF-32LE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf32le(stri_encode(x1, "UTF-8", "UTF-16LE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf32be(stri_encode(x1, "UTF-8", "UTF-16LE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf32le(stri_encode(x1, "UTF-8", "UTF-16BE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf32be(stri_encode(x1, "UTF-8", "UTF-16BE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf32le(stri_encode(x1, "UTF-8", "UTF-16", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf32be(stri_encode(x1, "UTF-8", "UTF-16", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf32le(stri_encode(x1, "UTF-8", "UTF-8", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf32be(stri_encode(x1, "UTF-8", "UTF-8", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf32le(stri_encode(x2, "UTF-8", "UTF-32LE", to_raw=TRUE)), TRUE)
expect_equivalent(stri_enc_isutf32be(stri_encode(x2, "UTF-8", "UTF-32BE", to_raw=TRUE)), TRUE)
expect_equivalent(stri_enc_isutf32be(stri_encode(x2, "UTF-8", "UTF-32LE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf32le(stri_encode(x2, "UTF-8", "UTF-32BE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf32le(stri_encode(x3, "UTF-8", "UTF-32LE", to_raw=TRUE)), TRUE)
expect_equivalent(stri_enc_isutf32be(stri_encode(x3, "UTF-8", "UTF-32BE", to_raw=TRUE)), TRUE)
expect_equivalent(stri_enc_isutf32be(stri_encode(x3, "UTF-8", "UTF-32LE", to_raw=TRUE)), FALSE)
expect_equivalent(stri_enc_isutf32le(stri_encode(x3, "UTF-8", "UTF-32BE", to_raw=TRUE)), FALSE)

l <- (.Platform$endian == 'little')
expect_equivalent(stri_enc_isutf32le(stri_encode(x1, "UTF-8", "UTF-32", to_raw=TRUE)), l)
expect_equivalent(stri_enc_isutf32le(stri_encode(x2, "UTF-8", "UTF-32", to_raw=TRUE)), l)
expect_equivalent(stri_enc_isutf32le(stri_encode(x3, "UTF-8", "UTF-32", to_raw=TRUE)), l)
expect_equivalent(stri_enc_isutf32be(stri_encode(x1, "UTF-8", "UTF-32", to_raw=TRUE)), !l)
expect_equivalent(stri_enc_isutf32be(stri_encode(x2, "UTF-8", "UTF-32", to_raw=TRUE)), !l)
expect_equivalent(stri_enc_isutf32be(stri_encode(x3, "UTF-8", "UTF-32", to_raw=TRUE)), !l)


x1 <- c("\u0105", NA, "\u0104", "\u00F1", "\u1e69") # nfc
x2 <- c("\u0061\u0328", NA, "\u0041\u0328", "\u006E\u0303", "\u0073\u0323\u0307") # nfd
expect_equivalent(stri_enc_isascii(x2), !c(T, NA, T, T, T))
expect_equivalent(stri_enc_isascii(x1), !c(T, NA, T, T, T))
expect_equivalent(stri_enc_isutf8(x2),  c(T, NA, T, T, T))
expect_equivalent(stri_enc_isutf8(x1),  c(T, NA, T, T, T))



expect_equivalent(stri_enc_detect(as.raw(c(65:100)))[[1]]$Encoding[1], "UTF-8")

expect_equivalent(stri_enc_detect2("abc")[[1]]$Encoding, "US-ASCII")

expect_error(stri_enc_detect2("abc", encodings=c("don't know what's that")))

expect_equivalent(stri_enc_detect2(stri_encode("abc", "UTF-8", "UTF-16", to_raw=TRUE))[[1]]$Encoding, "UTF-16")
expect_equivalent(stri_enc_detect2(stri_encode("abc", "UTF-8", "UTF-16LE", to_raw=TRUE))[[1]]$Encoding, "UTF-16LE")
expect_equivalent(stri_enc_detect2(stri_encode("abc", "UTF-8", "UTF-16BE", to_raw=TRUE))[[1]]$Encoding, "UTF-16BE")
expect_equivalent(stri_enc_detect2(stri_encode("abc", "UTF-8", "UTF-32", to_raw=TRUE))[[1]]$Encoding, "UTF-32")
expect_equivalent(stri_enc_detect2(stri_encode("abc", "UTF-8", "UTF-32LE", to_raw=TRUE))[[1]]$Encoding, "UTF-32LE")
expect_equivalent(stri_enc_detect2(stri_encode("abc", "UTF-8", "UTF-32BE", to_raw=TRUE))[[1]]$Encoding, "UTF-32BE")

text <- stri_flatten(stri_enc_fromutf32(65:127))
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-8", to_raw=TRUE))[[1]]$Encoding, "US-ASCII")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-16", to_raw=TRUE))[[1]]$Encoding, "UTF-16")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-16LE", to_raw=TRUE))[[1]]$Encoding, "UTF-16LE")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-16BE", to_raw=TRUE))[[1]]$Encoding, "UTF-16BE")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-32", to_raw=TRUE))[[1]]$Encoding, "UTF-32")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-32LE", to_raw=TRUE))[[1]]$Encoding, "UTF-32LE")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-32BE", to_raw=TRUE))[[1]]$Encoding, "UTF-32BE")

text <- stri_flatten(stri_enc_fromutf32(65:1024))
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-8", to_raw=TRUE))[[1]]$Encoding, "UTF-8")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-16", to_raw=TRUE))[[1]]$Encoding, "UTF-16")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-16LE", to_raw=TRUE))[[1]]$Encoding, "UTF-16LE")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-16BE", to_raw=TRUE))[[1]]$Encoding, "UTF-16BE")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-32", to_raw=TRUE))[[1]]$Encoding, "UTF-32")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-32LE", to_raw=TRUE))[[1]]$Encoding, "UTF-32LE")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-32BE", to_raw=TRUE))[[1]]$Encoding, "UTF-32BE")

if (file.exists('datasets/CS_utf8.txt')) {
    path <- 'datasets'
} else if (file.exists('../datasets/CS_utf8.txt')) {
    path <- '../datasets'
} else if (file.exists('../../datasets/CS_utf8.txt')) {
    path <- '../../datasets'
}

fnames <- c(file.path(path, 'CS_utf8.txt'),
            file.path(path, 'DE_utf8.txt'),
            file.path(path, 'PL_utf8.txt'),
            file.path(path, 'ES_utf8.txt'),
            file.path(path, 'RU_utf8.txt')
#                file.path(path, 'TH_utf8.txt')
            )

for (f in fnames) {
    text <- stri_read_raw(f)
    expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-8", to_raw=TRUE))[[1]]$Encoding, "UTF-8")
    expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-16", to_raw=TRUE))[[1]]$Encoding, "UTF-16")
    expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-16LE", to_raw=TRUE))[[1]]$Encoding, "UTF-16LE")
    expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-16BE", to_raw=TRUE))[[1]]$Encoding, "UTF-16BE")
    expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-32", to_raw=TRUE))[[1]]$Encoding, "UTF-32")
    expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-32LE", to_raw=TRUE))[[1]]$Encoding, "UTF-32LE")
    expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-32BE", to_raw=TRUE))[[1]]$Encoding, "UTF-32BE")
}

text <- stri_read_raw(file.path(path, 'PL_utf8.txt'))
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "cp1250", to_raw=TRUE),
                "pl_PL")[[1]]$Encoding[1], "windows-1250")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "latin2", to_raw=TRUE),
                "pl_PL")[[1]]$Encoding[1], "ISO-8859-2")
#expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "cp852", to_raw=TRUE),
#                                   "pl_PL")[[1]]$Encoding[1], "cp852")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "x-mac-centraleurroman", to_raw=TRUE),
                                    "pl_PL")[[1]]$Encoding[1], "x-mac-centraleurroman")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-8",  to_raw=TRUE),
                "pl_PL")[[1]]$Encoding[1], "UTF-8")

text <- stri_read_raw(file.path(path, 'CS_utf8.txt'))
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "cp1250", to_raw=TRUE),
                                    "cs_CZ")[[1]]$Encoding[1], "windows-1250")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "latin2", to_raw=TRUE),
                                    "cs_CZ")[[1]]$Encoding[1], "ISO-8859-2")
#expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "cp852", to_raw=TRUE),
#                                   "cs_CZ")[[1]]$Encoding[1], "cp852")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "x-mac-centraleurroman", to_raw=TRUE),
                                    "cs_CZ")[[1]]$Encoding[1], "x-mac-centraleurroman")
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "UTF-8",  to_raw=TRUE),
                                    "cs_CZ")[[1]]$Encoding[1], "UTF-8")

text <- stri_read_raw(file.path(path, 'DE_utf8.txt'))
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "latin1", to_raw=TRUE),
                                    "de_DE")[[1]]$Encoding[1], "ISO-8859-1") # windows-1250 is a superset
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "utf-8",  to_raw=TRUE),
                                    "de_DE")[[1]]$Encoding[1], "UTF-8")

text <- stri_read_raw(file.path(path, 'ES_utf8.txt'))
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "latin1", to_raw=TRUE),
                                    "es_ES")[[1]]$Encoding[1], "ISO-8859-1") # windows-1250 is a superset
expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "utf-8",  to_raw=TRUE),
                                    "es_ES")[[1]]$Encoding[1], "UTF-8")

# distinguishing between KOI8-R and Windows-1251 is not so easy
#text <- stri_encode(stri_read_raw(file.path(path, 'RU_utf8.txt')), "UTF-8", "UTF-8")
#expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "KOI8-R", to_raw=TRUE),
#                                   "ru_RU")[[1]]$Encoding[1], "KOI8-R")
#expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "windows-1251", to_raw=TRUE),
#                                   "ru_RU")[[1]]$Encoding[1], "windows-1251")
#expect_equivalent(stri_enc_detect2(stri_encode(text, "UTF-8", "utf-8",  to_raw=TRUE),
#                                   "ru_RU")[[1]]$Encoding[1], "UTF-8")

