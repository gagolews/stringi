library("tinytest")
library("stringi")



expect_equivalent(stri_numbytes(character(0)), integer(0))
expect_equivalent(stri_numbytes(c(NA, '', ' ', 'abc', '\u0104B\u0106')), c(NA, 0, 1, 3, 5))
#expect_equivalent(stri_numbytes(stri_unescape_unicode('\\U7fffffff')), 6) # windows has problems with \U........


expect_equivalent(stri_length(character(0)), integer(0))
expect_equivalent(stri_length(c(NA, '', ' ', 'abc', '\u0104B\u0106')), c(NA, 0, 1, 3, 3))
expect_equivalent(stri_length(10:99), rep(2,90))


x <- "\x99\x85"
Encoding(x) <- "UTF-8"
expect_warning(stri_length(x))
suppressWarnings(expect_identical(stri_length(x), NA_integer_))
expect_warning(stri_length('\U7fffffff'))
suppressWarnings(expect_identical(stri_length('\U7fffffff'), NA_integer_))


cjk_test <- stri_enc_fromutf32(c(24120, 29992, 22283, 23383, 27161, 28310, 23383, 39636, 34920))
expect_equivalent(stri_numbytes(cjk_test), 27)
expect_equivalent(stri_length(cjk_test), 9)

if (!stri_info()$ICU.UTF8) {
    suppressWarnings(suppressMessages(oldenc <- stri_enc_set('Big5')))
    cjk_test_Big5 <- stri_encode(cjk_test, 'UTF-8', 'Big5')
    expect_equivalent(stri_numbytes(cjk_test_Big5), 18)
    expect_equivalent(stri_length(cjk_test_Big5), 9)
    suppressMessages(stri_enc_set(oldenc))
}


expect_equivalent(stri_isempty(c(NA, '', ' ', 'abc', '\u0104B\u0106')), c(NA, T, F, F, F))


expect_equivalent(stri_width(c(NA, '', ' ', 'abc', '\u0104B\u0106')), c(NA, 0, 1, 3, 3))
expect_equivalent(stri_width(character(0)), integer(0))
expect_equivalent(stri_width(LETTERS[1:5]), rep(1L, 5))
expect_equivalent(stri_width(stri_trans_nfkd("\u0105")), 1L)
expect_equivalent(stri_width("\u12468"), 2L)
expect_equivalent(stri_width("\u200b"), 0L) # ZWSP
expect_equivalent(stri_width("\u00ad"), 1L) # SOFT HYPHEN
expect_true(all(stri_width( # Full-width equivalents of ASCII characters:
stri_enc_fromutf32(as.list(c(0x3000, 0xFF01:0xFF5E)))) == 2))
expect_equivalent(stri_width(stri_trans_nfkd("\ubc1f")), 2L)
expect_true(all(stri_width( # Hangul Jamo 0-width stuff
stri_enc_fromutf32(as.list(0x1160:0x11ff))) == 0))
expect_equivalent(stri_width(stri_trans_nfkd("\ubc1f")), 2L)

