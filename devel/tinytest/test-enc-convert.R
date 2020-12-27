library("tinytest")
library("stringi")
library("stringr")


expect_error(stri_encode("", "blahblahblah", "nosuchencoding"))

expect_equivalent(stri_encode("", "", ""), "")
expect_equivalent(stri_encode(NA_character_, "", ""), NA_character_)
expect_equivalent(stri_encode(LETTERS, "", ""), LETTERS)

expect_equivalent(stri_encode(LETTERS, "US-ASCII", "latin1"), LETTERS)
expect_equivalent(stri_encode(letters, "latin1", "UTF-8"), letters)

expect_equivalent(charToRaw(stri_encode("ąa", "", "cp1250")), as.raw(c(185, 97)))
expect_equivalent(stri_encode(NULL, "cp-1250", ""), NA_character_)
expect_equivalent(stri_encode(as.raw(165), "cp-1250", "iso-8859-2", to_raw = TRUE)[[1]],
    as.raw(161))
expect_equivalent(stri_encode(list(as.raw(165)), "cp-1250", "iso-8859-2", to_raw = TRUE)[[1]],
    as.raw(161))
expect_error(stri_encode(list("shouldberaw"), "", ""))

.polish_chars_latin2 <- rawToChar(as.raw(c(161, 198, 202, 163, 209, 211, 166,
    172, 175, 177, 230, 234, 179, 241, 243, 182, 188, 191)))
Encoding(.polish_chars_latin2) <- "bytes"

.polish_chars_cp1250 <- rawToChar(as.raw(c(165, 198, 202, 163, 209, 211, 140,
    143, 175, 185, 230, 234, 179, 241, 243, 156, 159, 191)))
Encoding(.polish_chars_cp1250) <- "bytes"

.polish_chars_utf8 <- intToUtf8((c(260, 262, 280, 321, 323, 211, 346, 377, 379,
    261, 263, 281, 322, 324, 243, 347, 378, 380)))
Encoding(.polish_chars_utf8) <- "bytes"

expect_equivalent(charToRaw(stri_encode(.polish_chars_latin2, "latin2", "cp1250")),
    charToRaw(.polish_chars_cp1250))
expect_equivalent(charToRaw(stri_encode(.polish_chars_cp1250, "cp1250", "utf8")),
    charToRaw(.polish_chars_utf8))

expect_warning(expect_equivalent(stri_encode(stri_encode(c("ąabcĄ", NA, "�吲"),
    "UTF-8", "latin2", to_raw = TRUE), "latin2", "UTF-8"), c("ąabcĄ", NA, "\032\032")))




x <- charToRaw(stringi::stri_dup("a", 2^3))
expect_equivalent(rawToChar(x), stringi::stri_encode(rawToChar(x), NULL, "utf-8"))
expect_equivalent(rawToChar(x), stringi::stri_encode(rawToChar(x), "utf-8", "utf-8"))
expect_equivalent(rawToChar(x), stringi::stri_encode(list(x), NULL, "utf-8"))
expect_equivalent(rawToChar(x), stringi::stri_encode(list(x), "utf-8", "utf-8"))
expect_equivalent(rawToChar(x), stringi::stri_encode(x, NULL, "utf-8"))
expect_equivalent(rawToChar(x), stringi::stri_encode(x, "utf-8", "utf-8"))



expect_identical(stri_enc_toutf32(character(0)), list())
expect_identical(stri_enc_toutf32(LETTERS), as.list(65:90))
expect_identical(stri_enc_toutf32(c("A", NA, "A")), list(65L, NULL, 65L))
expect_identical(stri_enc_toutf32("aą㐣b")[[1]], utf8ToInt("aą㐣b"))

x <- "\x99\x85"
Encoding(x) <- "UTF-8"
expect_warning(stri_enc_toutf32(x))
suppressWarnings(expect_identical(stri_enc_toutf32(x), list(NULL)))



expect_identical(stri_enc_fromutf32(integer(0)), "")
expect_identical(stri_enc_fromutf32(c(65L, 66L, 67L)), "ABC")
expect_identical(stri_enc_fromutf32(c("65", "66", "67")), "ABC")
expect_identical(stri_enc_fromutf32(c(43, 234, 649, 63, 23532, 23632)),
    intToUtf8(c(43, 234, 649, 63, 23532, 23632)))
expect_warning(stri_enc_fromutf32(list(c(43, 234, 649, 63, 23532, 233643642), 65)))
suppressWarnings(expect_identical(stri_enc_fromutf32(list(c(43, 234, 649, 63,
    23532, 233643642), 65)), c(NA, "A")))
expect_warning(stri_enc_fromutf32(c(0, 1, 2)))
suppressWarnings(expect_identical(stri_enc_fromutf32(c(0, 1, 2)), NA_character_))

expect_identical(stri_enc_fromutf32(list()), character(0))
expect_identical(stri_enc_fromutf32(list(NULL)), NA_character_)
expect_identical(stri_enc_fromutf32(NULL), NA_character_)
expect_identical(stri_enc_fromutf32(list(65, 66, 67)), LETTERS[1:3])
expect_identical(stri_enc_fromutf32(list(65:67, NULL, 65:67, NULL)), rep(c("ABC",
    NA_character_), 2))



expect_identical(stri_enc_toutf8(character(0)), character(0))
expect_identical(stri_enc_toutf8(LETTERS), LETTERS)
s <- c("sgajhgaoi", NA, "ąfds吲Ą")
expect_identical(stri_enc_toutf8(s), s)

s <- c("stra\xdfe")
Encoding(s) <- "latin1"
expect_identical(stri_enc_toutf8(s), "straße")
expect_identical(stri_enc_toutf8(s, is_unknown_8bit = TRUE), "stra�e")

expect_identical(stri_enc_toutf8("\xef\xbb\xbfabc"), "abc")  # removes BOMs
expect_identical(stri_enc_toutf8("\xef\xbb\xbfabc", is_unknown_8bit = TRUE), "���abc")  # doesn't remove BOMs

x <- "abc\x99\x85"
Encoding(x) <- "UTF-8"
expect_warning(stri_enc_toutf8(x, validate = TRUE))
suppressWarnings(expect_identical(stri_enc_toutf8(x, validate = TRUE), "abc��"))
expect_identical(stri_enc_toutf8(x), x)
expect_warning(stri_enc_toutf8(x, validate = NA))
suppressWarnings(expect_identical(stri_enc_toutf8(x, validate = NA), NA_character_))


expect_identical(stri_enc_toascii(character(0)), character(0))
expect_identical(stri_enc_toascii(LETTERS), LETTERS)
expect_identical(stri_enc_toascii(enc2utf8(c("sgajhgaoi", NA, "ąfds吲Ą"))),
    c("sgajhgaoi", NA, "\032fds\032\032"))


if (!stri_info()$ICU.UTF8) {
    s <- c("\xa3\xb1ka")
    suppressMessages(enc <- stri_enc_set("latin-2"))
    expect_identical(stri_enc_toascii(s), "\032\032ka")
    suppressMessages(stri_enc_set(enc))
}

# # TODO: this doesn't work with tinytest
# if (!stri_info()$ICU.UTF8) {
#     suppressMessages(defenc <- stri_enc_set("iso-8859-2"))
#     expect_equivalent(stri_encode(c("a", "\xb1", NA, "ą"), "", "UTF-8"), c("a", "ą", NA, "ą"))
#     expect_equivalent(stri_encode(c("a", "\xb1", NA, "ą"), "", ""), c("a", "\xb1", NA, "\xb1"))
#     suppressMessages(stri_enc_set(defenc))
# }
#
# # TODO: this doesn't work with tinytest
# if (!stri_info()$ICU.UTF8) {
#     suppressMessages(defenc <- stri_enc_set("cp-1250"))
#     expect_equivalent(stri_encode(c("a", "\xb9", NA, "ą"), NULL, "UTF-8"), c("a", "ą", NA, "ą"))
#     expect_equivalent(stri_encode(c("a", "\xb9", NA, "ą")), c("a", "\xb9", NA, "\xb9"))
#     suppressMessages(stri_enc_set(defenc))
# }
