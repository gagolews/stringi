library("tinytest")
library("stringi")


expect_equivalent(stri_remove_empty(stri_na2empty(c("a", NA, "", "b"))), c("a",
    "b"))
expect_equivalent(stri_remove_empty(c("a", NA, "", "b")), c("a", NA, "b"))
expect_equivalent(stri_remove_empty(c("a", NA, "", "b"), TRUE), c("a", "b"))

expect_equivalent(stri_omit_empty_na(c("a", NA, "", "b")), c("a", "b"))


expect_equivalent(stri_na2empty(c("a", NA, "", "b")), c("a", "", "", "b"))
expect_equivalent(stri_na2empty(c("a", NA, "", "b")), stri_replace_na(c("a",
    NA, "", "b"), ""))

s <- c("ala", NA, "kota")
expect_identical(stri_replace_na(s, "brak"), c("ala", "brak", "kota"))
expect_identical(stri_replace_na(s, ""), c("ala", "", "kota"))
expect_identical(stri_replace_na(s, NA), c("ala", NA, "kota"))
expect_warning(stri_replace_na(s, character(3)))
expect_error(stri_replace_na(s, character(0)))

x <- stri_enc_tonative(stri_dup("\u0105", 1:100))
x[sample(seq_along(x), 20)] <- NA_character_
expect_equivalent(stri_replace_na(x, "???"), {
    x2 <- stri_enc_toutf8(x)
    x2[is.na(x2)] <- "???"
    x2
})

expect_equivalent(stri_remove_na(c("1", "", "2", NA, NA, "", "3")), c("1", "",
    "2", "", "3"))
expect_equivalent(stri_omit_na(c("1", "", "2", NA, NA, "", "3")), c("1", "",
    "2", "", "3"))
expect_equivalent(stri_remove_empty_na(c("1", "", "2", NA, NA, "", "3")), c("1",
    "2", "3"))
expect_equivalent(stri_omit_empty_na(c("1", "", "2", NA, NA, "", "3")), c("1",
    "2", "3"))
expect_equivalent(stri_remove_empty(c("1", "", "2", NA, NA, "", "3")), c("1",
    "2", NA, NA, "3"))
expect_equivalent(stri_omit_empty(c("1", "", "2", NA, NA, "", "3")), c("1", "2",
    NA, NA, "3"))

expect_equivalent("value='%d'" %s$% 3, "value='3'")
expect_equivalent("value='%d'" %s$% 1:3, c("value='1'", "value='2'", "value='3'"))
expect_equivalent("%s='%d'" %s$% list("value", 3), "value='3'")
expect_equivalent("%s='%d'" %s$% list("value", 1:3), c("value='1'", "value='2'", "value='3'"))
expect_equivalent("%s='%d'" %s$% list(c("a", "b", "c"), 1), c("a='1'", "b='1'", "c='1'"))
expect_equivalent("%s='%d'" %s$% list(c("\u0105", "\u015B", "\u0107"), 1), c("\u0105='1'", "\u015B='1'", "\u0107='1'"))
expect_equivalent("%s='%d'" %s$% list(factor(c("\u0105", "\u015B", "\u0107")), 1), c("\u0105='1'", "\u015B='1'", "\u0107='1'"))
expect_equivalent("%s='%d'" %s$% list(c("a", "b", "c"), 1:3), c("a='1'", "b='2'", "c='3'"))

expect_equivalent("%s='%d'" %s$% list(c("a", NA, "c"), 1:3), c("a='1'", NA, "c='3'"))

expect_equivalent("%s='%d'" %s$% list(c("a", "b", "c"), NA), c(NA_character_, NA_character_, NA_character_))

expect_equivalent("%s='%d'" %s$% list(character(0), NA_character_), character(0))
expect_equivalent("%s" %s$% character(0), character(0))

expect_equivalent(character(0) %s$% character(0), character(0))
expect_equivalent(character(0) %s$% c(c("a", "b", "c"), 1), character(0))
expect_equivalent(character(0) %s$% c(NA_character_, NA_character_), character(0))
expect_equivalent(c(NA_character_, "%s", NA_character_) %s$% "a", c(NA_character_, "a", NA_character_))
expect_equivalent(c(NA_character_, "%s", NA_character_) %s$% c("a", NA_character_, "a"), c(NA_character_, NA_character_, NA_character_))
expect_equivalent(c(NA_character_) %s$% list("a", NA_character_, "a"), c(NA_character_))
expect_equivalent(c(NA_character_) %s$% list(c("a", NA_character_, "a")), c(NA_character_, NA_character_, NA_character_))
expect_equivalent(c(NA_character_, "%s", NA_character_) %s$% c("a", "a", "a"), c(NA_character_, "a", NA_character_))
expect_equivalent(c(NA_character_, "%s") %s$% c("a", NA_character_, "a", NA_character_), c(NA_character_, NA_character_, NA_character_, NA_character_))
expect_equivalent(c(NA_character_, "%s") %s$% c(NA_character_, "a", NA_character_, "a"), c(NA_character_, "a", NA_character_, "a"))
