library("tinytest")
library("stringi")

expect_equivalent(stri_replace_rstr(NA), NA_character_)
expect_equivalent(stri_replace_rstr(character(0)), character(0))
expect_equivalent(stri_replace_rstr(""), "")
expect_equivalent(stri_replace_rstr(c("$", "\\$", "\\\\$$")), c("\\$", "\\$", "\\\\\\$\\$"))
expect_equivalent(stri_replace_rstr("\\1"), "$1")
expect_equivalent(stri_replace_rstr("\\0"), "0")
expect_equivalent(stri_replace_rstr("\\\\1"), "\\\\1")
expect_equivalent(stri_replace_rstr("\\\\\\1"), "\\\\$1")
expect_equivalent(stri_replace_rstr("\\\\\\\\1"), "\\\\\\\\1")
expect_equivalent(stri_replace_rstr("\\1\\"), "$1")
expect_equivalent(stri_replace_rstr("\\13"), "$1\\3")
expect_equivalent(stri_replace_rstr("\\10"), "$1\\0")
expect_equivalent(stri_replace_rstr("\\a\\1\\abc"), "a$1abc")

# perl=TRUE has \\U, \\L, \\E, but we don't support it
expect_equivalent(stri_replace_rstr("\\U\\K\\U\\L\\E\\L\\E\\"), "UKULELE")
