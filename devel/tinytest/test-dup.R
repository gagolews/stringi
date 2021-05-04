library("tinytest")
library("stringi")



# basic tests (ASCII, border-line):
suppressWarnings(expect_identical(stri_dup(c("A", "B"), c(2, 3, 4)), c("AA",
    "BBB", "AAAA")))
expect_warning(stri_dup(c("A", "B"), c(2, 3, 4)))

expect_identical(stri_dup("1", 3), "111")
expect_identical(stri_dup(1, 3), "111")
expect_identical(stri_dup(1L, 3), "111")
expect_identical(stri_dup(factor("1"), 3), "111")

expect_identical(stri_paste(stri_dup("a", 5), "b"), "a"%s*%5%s+%"b")
expect_identical(stri_paste(stri_dup("a", 5), "b"), "a"%stri*%5%stri+%"b")

expect_identical(stri_dup(NA, NA), NA_character_)
expect_identical(stri_dup(NA, 3), NA_character_)
expect_identical(stri_dup("A", NA), NA_character_)
expect_identical(stri_dup(character(0), integer(0)), character(0))
expect_identical(stri_dup("char", integer(0)), character(0))
expect_identical(stri_dup(character(0), 10), character(0))
expect_identical(stri_dup(LETTERS, 1), LETTERS)
expect_identical(stri_dup(LETTERS, 2), paste(LETTERS, LETTERS, sep = ""))
expect_identical(stri_dup(LETTERS, 1:13), LETTERS %s*% 1:13)
expect_identical(stri_dup("ABC", 0), "")
expect_identical(stri_dup("A", c(1.5, 1.99, 0.1)), c("A", "A", ""))
expect_warning(stri_dup("A", ":-("))
expect_identical(stri_dup(c("ABC", "", "A"), c(0, 100, 0)), c("", "", ""))
expect_identical(stri_dup("A", c(-1, 0, 1, NA)), c(NA, "", "A", NA))
expect_identical(stri_dup(LETTERS[1:4], 1:2), c("A", "BB", "C", "DD"))
expect_warning(stri_dup(LETTERS[1:3], 1:2))

# UTF-8
expect_identical(stri_dup("\u9999", 1:2), c("\u9999", "\u9999\u9999"))
expect_identical(stri_dup("\0209999", 2), "\0209999\0209999")

expect_identical(stri_dup(enc2native("\u0105"), 1:2), c("\u0105", "\u0105\u0105"))


# Other 8-bit encodings
if (!stri_info()$ICU.UTF8) {
    suppressMessages(oldenc <- stri_enc_set("latin2"))
    expect_identical(stri_dup("\xa1\xb1", 2), "\u0104\u0105\u0104\u0105")
    suppressMessages(stri_enc_set(oldenc))
}

if (!stri_info()$ICU.UTF8) {
    suppressMessages(oldenc <- stri_enc_set("cp1250"))
    expect_identical(stri_dup("\xa5\xb9", 2), "\u0104\u0105\u0104\u0105")
    suppressMessages(stri_enc_set(oldenc))
    #expect_warning(stri_dup('\xa5\xb9', 2)) #only in utf-8
}

