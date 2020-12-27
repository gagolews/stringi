library("tinytest")
library("stringi")
library("stringr")

expect_identical(stri_extract_all_regex(character(0), "test"), list())
expect_identical(stri_extract_all_regex("test", character(0)), list())
expect_identical(stri_extract_all_regex(character(0), character(0)), list())
expect_identical(stri_extract_all_regex(NA, "test"), list(NA_character_))
expect_identical(stri_extract_all_regex("test", NA), list(NA_character_))
suppressWarnings(expect_identical(stri_extract_all_regex("test", ""), list(NA_character_)))
expect_identical(stri_extract_all_regex(c("bacab", "bacabaąa", "aa"), "a.a"),
    list("aca", c("aca", "aąa"), NA_character_))

expect_identical(stri_extract_all_regex(c("ąĆć", "ąć"), "Ć*"), list(c("",
    "Ć", "", ""), c("", "", "")))  # match of zero length
expect_identical(stri_extract_all_regex(c("ąĆć", "ąć"), "(?<=Ć)"), list("",
    NA_character_))  # match of zero length:

expect_identical(stri_extract_all_regex("", "^.*$"), list(""))
expect_identical(stri_extract_all_regex("", "^.*$", omit_no_match = TRUE), list(""))
expect_identical(stri_extract_all_regex("", " "), list(NA_character_))
expect_identical(stri_extract_all_regex("", " ", omit_no_match = TRUE), list(character(0)))
expect_identical(stri_extract_all_regex("test", " "), list(NA_character_))
expect_identical(stri_extract_all_regex("test", " ", omit_no_match = TRUE), list(character(0)))

expect_identical(stri_extract(c("ab_c", "d_ef_g", "h", ""), mode = "all", regex = "\\p{L}+",
    simplify = NA), matrix(c("ab", "d", "h", NA, "c", "ef", NA, NA, NA, "g",
    NA, NA), nrow = 4))

expect_identical(stri_extract(c("ab_c", "d_ef_g", "h", ""), mode = "all", regex = "\\p{L}+",
    simplify = TRUE, omit_no_match = TRUE), matrix(c("ab", "d", "h", "", "c",
    "ef", "", "", "", "g", "", ""), nrow = 4))

#    expect_identical(stri_extract_all_regex(c('ababab', NA, 'ab', 'ba'), 'ab'),
#       str_extract_all(c('ababab', NA, 'ab', 'ba'), 'ab'))

# ICU-bugs (#147)
expect_identical(stri_extract_all_regex("aafoo - ICU BUG TEST, #147", "(?<=aa)foo"),
    list("foo"))
expect_identical(stri_extract_all_regex("aąfoo - ICU BUG TEST, #147", "(?<=aą)foo"),
    list("foo"))
expect_identical(stri_extract_all_regex("a𠀀foo - ICU BUG TEST, #147", "(?<=a𠀀)foo"),
    list("foo"))

expect_identical(stri_extract_first_regex(character(0), "test"), character(0))
expect_identical(stri_extract_first_regex("test", character(0)), character(0))
expect_identical(stri_extract_first_regex(character(0), character(0)), character(0))
expect_identical(stri_extract_first_regex(NA, "test"), NA_character_)
expect_identical(stri_extract_first_regex("test", NA), NA_character_)
suppressWarnings(expect_identical(stri_extract_first_regex("test", ""), NA_character_))
expect_identical(stri_extract_first_regex("\U00f0ffffbądeb!d", "b.d"), "bąd")
expect_identical(stri_extract_first_regex("\U00f0ffffbądeb!d", "B.D", stri_opts_regex(case_insensitive = TRUE)),
    "bąd")

expect_identical(stri_extract_first_regex(c("ąĆć", "ąć"), "Ć*"), c("",
    ""))  # match of zero length
expect_identical(stri_extract_first_regex(c("ąĆć", "ąć"), "(?<=Ć)"), c("",
    NA_character_))  # match of zero length:


expect_identical(stri_extract_first_regex(c("ababab", NA, "ab", "ba"), "ab"),
    str_extract(c("ababab", NA, "ab", "ba"), "ab"))

expect_identical(stri_extract_first_regex(c("", " "), "^.*$"), c("", " "))


expect_identical(stri_extract_last_regex(c("", " "), "^.*$"), c("", " "))
expect_identical(stri_extract_last_regex(character(0), "test"), character(0))
expect_identical(stri_extract_last_regex("test", character(0)), character(0))
expect_identical(stri_extract_last_regex(character(0), character(0)), character(0))
expect_identical(stri_extract_last_regex(NA, "test"), NA_character_)
expect_identical(stri_extract_last_regex("test", NA), NA_character_)
suppressWarnings(expect_identical(stri_extract_last_regex("test", ""), NA_character_))
expect_identical(stri_extract_last_regex("b!d\U00f0ffffbąde", "b.d"), "bąd")
expect_identical(stri_extract_last_regex("b!d\U00f0ffffbąde", "B.D", stri_opts_regex(case_insensitive = TRUE)),
    "bąd")

expect_identical(stri_extract_last_regex(c("ąĆć", "ąć"), "Ć*"), c("", ""))  # match of zero length
expect_identical(stri_extract_last_regex(c("ąĆć", "ąć"), "(?<=Ć)"), c("",
    NA_character_))  # match of zero length:
