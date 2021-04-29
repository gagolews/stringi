library("tinytest")
library("stringi")


expect_error(stri_replace_all_regex("a", "a", c("b", "d"), vectorize_all = FALSE))
expect_error(stri_replace_all_regex("a", c(), "a", vectorize_all = FALSE))
expect_error(stri_replace_all_regex("a", c("a", "b"), c(), vectorize_all = FALSE))
expect_warning(stri_replace_all_regex("a", c("a", "b", "c"), c("b", "d"), vectorize_all = FALSE))
expect_equivalent(stri_replace_all_regex("a", c("a", NA), c("b", "d"), vectorize_all = FALSE),
    c(NA_character_))
expect_equivalent(stri_replace_all_regex(c("a", "b"), c("a", NA), c("b", "d"),
    vectorize_all = FALSE), c(NA_character_, NA_character_))
expect_equivalent(stri_replace_all_regex(c("aba", "bbbb"), c("a", "c"), c(NA,
    "d"), vectorize_all = FALSE), c(NA, "bbbb"))
expect_equivalent(stri_replace_all_regex(character(0), c("a", "c"), c(NA, "d"),
    vectorize_all = FALSE), character(0))
expect_equivalent(stri_replace_all_regex(c("", "", ""), c("a", "c"), c("e", "d"),
    vectorize_all = FALSE), c("", "", ""))
expect_equivalent(stri_replace_all_regex(c("abacada", "aaa", "fdsueo"), c("a+",
    "b"), c("x", "y"), vectorize_all = FALSE), c("xyxcxdx", "x", "fdsueo"))
expect_equivalent(stri_replace_all_regex("The quick brown fox jumped over the lazy dog.",
    c("quick", "brown", "fox"), c("slow", "black", "bear"), vectorize_all = FALSE),
    "The slow black bear jumped over the lazy dog.")
expect_equivalent(stri_replace_all_regex("The quick brown fox jumped over the lazy dog.",
    c("quick", "brown", "fox", "dog"), c(""), vectorize_all = FALSE), "The    jumped over the lazy .")
expect_identical(stri_replace_all_regex(c("X", "Y"), c("a", "b", "X"), NA, vectorize_all = FALSE),
    c(NA, "Y"))

expect_identical(stri_replace_all_regex("", c("^.*$", "h"), c("hey!", "y"), vectorize_all = FALSE),
    "yey!")
expect_identical(stri_replace_all_regex("  ", c("^.*$", "h"), c("hey!", "y"),
    vectorize_all = FALSE), "yey!")

# not a bug, a feature:
# expect_identical(stri_replace_all_regex('A', '^(.*)', 'ONE($1)'), 'ONE(A)')
# expect_identical(stri_replace_all_regex('ABC', '(.*)$', 'ONE($1)'), 'ONE(A)')
# expect_identical(stri_replace_all_regex('ABC', '(.*)', 'ONE($1)'), 'ONE(A)')
# expect_identical(stri_replace_all_regex('A', '.*', 'ONE($0)'), 'ONE(A)')
# expect_identical(stri_replace_all_regex('A', '^.*', 'ONE($0)'), 'ONE(A)')

expect_identical(stri_replace_all_regex(c("1RR", "NURR", "3"), c("RR", "NULL"),
    c("LL", NA), vectorize_all = FALSE), c("1LL", NA, "3"))

expect_identical(stri_replace_all_regex(character(0), 1, 2), character(0))
expect_identical(stri_replace_all_regex(1, character(0), 2), character(0))
expect_identical(stri_replace_all_regex(1, 2, character(0)), character(0))
expect_identical(stri_replace_all_regex("abab123 a", "a", 1), "1b1b123 1")
expect_identical(stri_replace_all_regex(NA, "A", 1), NA_character_)
expect_identical(stri_replace_all_regex("ALA", NA, "1"), NA_character_)
expect_identical(stri_replace_all_regex("ALA", "A", NA), NA_character_)
expect_identical(stri_replace_all_regex(NA, NA, "A"), NA_character_)
expect_identical(stri_replace_all_regex(NA, "A", NA), NA_character_)
expect_identical(stri_replace_all_regex("A", NA, NA), NA_character_)
expect_identical(stri_replace_all_regex(NA, NA, NA), NA_character_)
expect_warning(stri_replace_all_regex("fasgasgas", c(" ", "o"), 1:3))

expect_identical(stri_replace_all_regex(c("1", "NULL", "3"), "NULL", NA), c("1",
    NA, "3"))

expect_identical(stri_replace_all_regex("", "^.*$", "hey!"), "hey!")
expect_identical(stri_replace_all_regex("  ", "^.*$", "hey!"), "hey!")

expect_identical(stri_replace_all_regex("abc!def!ghi", "(\\p{L})\\p{L}{2}", "$1"),
    "a!d!g")
expect_identical(stri_replace_all_regex("abc!def!ghi", "(\\p{L}{3})", "@$1@"),
    "@abc@!@def@!@ghi@")

expect_identical(stri_replace_all_regex(c("a", "b", "c", "d"), c("[ac]", "[bd]"),
    "!"), rep("!", 4))

if (!stri_info()$ICU.UTF8) {
    suppressMessages(origenc <- stri_enc_set("latin2"))
    expect_identical(stri_replace_all_regex(iconv("ąść", "UTF-8", "latin2"),
        iconv("ąść", "UTF-8", "latin2"), iconv("ęłź", "UTF-8", "latin2")),
        "ęłź")  # output is always UTF-8
    suppressMessages(stri_enc_set(origenc))
}

if (!stri_info()$ICU.UTF8) {
    suppressMessages(origenc <- stri_enc_set("cp1250"))
    expect_identical(stri_replace_all_regex(iconv("ąść", "UTF-8", "cp1250"),
        iconv("ąść", "UTF-8", "cp1250"), iconv("ęłź", "UTF-8", "cp1250")),
        "ęłź")  # output is always UTF-8
    suppressMessages(stri_enc_set(origenc))
}

x1 <- rawToChar(as.raw(198))
x2 <- rawToChar(as.raw(230))
Encoding(x1) <- "latin1"
Encoding(x2) <- "latin1"
expect_identical(stri_replace_all_regex(x1, x1, x2), "æ")

expect_identical(stri_replace_all_regex("X𤭢X", c("𤭢", "𤭣", "X"), ""),
    c("XX", "X𤭢X", "𤭢"))

expect_identical(stri_replace_all_regex(c("ąĆć", "ąć"), "Ć*", "Ĉ"), c("ĈąĈĈćĈ",
    "ĈąĈćĈ"))  # match of zero length
expect_identical(stri_replace_all_regex(c("ąĆć", "ąć"), "(?<=Ć)", "Ĉ"),
    c("ąĆĈć", "ąć"))  # match of zero length:


expect_identical(stri_replace_first_regex("abc!def!ghi", "(\\p{L})\\p{L}{2}",
    "$1"), "a!def!ghi")
expect_identical(stri_replace_first_regex("abc!def!ghi", "(\\p{L}{3})", "@$1@"),
    "@abc@!def!ghi")
expect_identical(stri_replace_first_regex("123!345!456", "(\\p{L}{3})", "@$1@"),
    "123!345!456")
expect_identical(stri_replace_first_regex("abc", "a", "2"), "2bc")
expect_identical(stri_replace_first_regex("abc", "d", "2"), "abc")

expect_identical(stri_replace_first_regex(NA, "A", 1), NA_character_)
expect_identical(stri_replace_first_regex("ALA", NA, "1"), NA_character_)
expect_identical(stri_replace_first_regex("ALA", "A", NA), NA_character_)
expect_identical(stri_replace_first_regex(NA, NA, "A"), NA_character_)
expect_identical(stri_replace_first_regex(NA, "A", NA), NA_character_)
expect_identical(stri_replace_first_regex("A", NA, NA), NA_character_)
expect_identical(stri_replace_first_regex(NA, NA, NA), NA_character_)



expect_identical(stri_replace_first_regex(c("ąĆć", "ąć"), "Ć*", "Ĉ"),
    c("ĈąĆć", "Ĉąć"))  # match of zero length
expect_identical(stri_replace_first_regex(c("ąĆć", "ąć"), "(?<=Ć)", "Ĉ"),
    c("ąĆĈć", "ąć"))  # match of zero length:
expect_identical(stri_replace_first_regex("", "^.*$", "hey!"), "hey!")
expect_identical(stri_replace_first_regex("  ", "^.*$", "hey!"), "hey!")

expect_identical(stri_replace_first_regex(c("1", "NULL", "3"), "NULL", NA), c("1",
    NA, "3"))

expect_identical(stri_replace_last_regex("abc!def!ghi", "(\\p{L})\\p{L}{2}",
    "$1"), "abc!def!g")
expect_identical(stri_replace_last_regex("abc!def!ghi!", "(\\p{L}{3})", "@$1@"),
    "abc!def!@ghi@!")
expect_identical(stri_replace_last_regex("123!345!456", "(\\p{L}{3})", "@$1@"),
    "123!345!456")
expect_identical(stri_replace_last_regex("abc", "c", "2"), "ab2")
expect_identical(stri_replace_last_regex("abc", "d", "2"), "abc")

expect_identical(stri_replace_last_regex(NA, "A", 1), NA_character_)
expect_identical(stri_replace_last_regex("ALA", NA, "1"), NA_character_)
expect_identical(stri_replace_last_regex("ALA", "A", NA), NA_character_)
expect_identical(stri_replace_last_regex(NA, NA, "A"), NA_character_)
expect_identical(stri_replace_last_regex(NA, "A", NA), NA_character_)
expect_identical(stri_replace_last_regex("A", NA, NA), NA_character_)
expect_identical(stri_replace_last_regex(NA, NA, NA), NA_character_)

expect_identical(stri_replace_last_regex(c("ąĆć", "ąć"), "Ć*", "Ĉ"), c("ąĆćĈ",
    "ąćĈ"))  # match of zero length
expect_identical(stri_replace_last_regex(c("ąĆć", "ąć"), "(?<=Ć)", "Ĉ"),
    c("ąĆĈć", "ąć"))  # match of zero length:

expect_identical(stri_replace_last_regex("", "^.*$", "hey!"), "hey!")
expect_identical(stri_replace_last_regex("  ", "^.*$", "hey!"), "hey!")

expect_identical(stri_replace_last_regex(c("1", "NULL", "3"), "NULL", NA), c("1",
    NA, "3"))

