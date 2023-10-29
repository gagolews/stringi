library("tinytest")
library("stringi")


expect_identical(stri_startswith_coll("a", NA), NA)
expect_identical(stri_startswith_coll(NA, "a"), NA)
expect_identical(stri_startswith_coll(NA, NA), NA)
expect_identical(stri_startswith_coll(c("", "ala"), "ala"), c(FALSE, TRUE))
expect_identical(stri_startswith_coll(c("ala", "", "", "bbb"), c("ala", "bbb")),
    c(TRUE, FALSE, FALSE, TRUE))
expect_identical(stri_startswith_coll("kot lorem1", character(0)), logical(0))
expect_identical(stri_startswith_coll(character(0), "ipsum 1234"), logical(0))
expect_identical(stri_startswith_coll(character(0), character(0)), logical(0))
expect_identical(stri_startswith_coll(c("ab", "cab", "ccccab", "abaabaaaa"),
    "ab"), c(T, F, F, T))
expect_identical(stri_startswith_coll(c("Lorem\n123", " ", "kota", "\t\u01054"),
    c(" ", "\t\u0105")), c(F, F, F, T))
expect_warning(stri_startswith_coll(rep("asd", 5), rep("a", 2)))
expect_identical(stri_startswith_coll("\u0104\u0105", stri_trans_nfkd("\u0104\u0105")), TRUE)
expect_equivalent(stri_startswith_coll("aaaab", "ab"), FALSE)
expect_equivalent(stri_startswith_coll("bababababaab", "bab"), TRUE)
expect_equivalent(stri_startswith_coll("bababababaab", "bab", from = c(1, 2,
    3)), c(T, F, T))
expect_equivalent(stri_startswith_coll("\u0105\u0104\u0105\u0104\u0105", "\u0105\u0104\u0105", from = c(1, 2,
    3, 100, -3)), c(T, F, T, F, T))
expect_equivalent(stri_startswith("\u0105\u0104\u0105\u0104\u0105", coll = "\u0105\u0104\u0105", from = c(1,
    2, 3, 100, -3)), c(T, F, T, F, T))
expect_equivalent(stri_startswith_coll("a", "agsdgsjgidjso", c(-1, 1, -2, 2,
    0)), c(F, F, F, F, F))

expect_equivalent(stri_startswith_coll("abc", "a", c(1, 2, 3)), c(TRUE, FALSE,
    FALSE))
expect_equivalent(stri_startswith_coll("abc", "b", c(1, 2, 3)), c(FALSE, TRUE,
    FALSE))
expect_equivalent(stri_startswith_coll("abc", "c", c(1, 2, 3)), c(FALSE, FALSE,
    TRUE))
expect_equivalent(stri_startswith_coll("abc", "a", c(-3, -2, -1)), c(TRUE, FALSE,
    FALSE))
expect_equivalent(stri_startswith_coll("abc", "b", c(-3, -2, -1)), c(FALSE, TRUE,
    FALSE))
expect_equivalent(stri_startswith_coll("abc", "c", c(-3, -2, -1)), c(FALSE, FALSE,
    TRUE))
expect_equivalent(stri_startswith_coll("abc", "c", c(-3, -2, -1), negate=TRUE), !c(FALSE, FALSE,
    TRUE))

expect_equivalent(stri_startswith_coll("abc", "a", c(-1000, 0, 4)), c(TRUE, TRUE,
    FALSE))
expect_equivalent(stri_startswith_coll("ab", "b", c(-1000, 0, 3)), c(FALSE, FALSE,
    FALSE))
expect_equivalent(stri_startswith_coll("a", "b", c(-1000, 0, 2)), c(FALSE, FALSE,
    FALSE))

suppressWarnings(expect_identical(stri_startswith_coll("", ""), NA))
suppressWarnings(expect_identical(stri_startswith_coll("a", ""), NA))
suppressWarnings(expect_identical(stri_startswith_coll("", "a"), FALSE))

expect_equivalent(stri_startswith_coll("\uFDFA\uFDFA\uFDFA\uFDFAXYZ\uFDFA", stri_paste("\u0635\u0644\u0649 \u0627\u0644\u0644\u0647 ",
    "\u0639\u0644\u064A\u0647 \u0648\u0633\u0644\u0645XYZ"), opts_collator = stri_opts_collator(strength = 1, locale="en"),
    from = 4), TRUE)
expect_equivalent(stri_startswith_coll("\uFDFA\uFDFA\uFDFA\uFDFAXYZ\uFDFA", stri_paste("\u0635\u0644\u0649 \u0627\u0644\u0644\u0647 ",
    "\u0639\u0644\u064A\u0647 \u0648\u0633\u0644\u0645XYZ"), negate=TRUE, opts_collator = stri_opts_collator(strength = 1, locale="en"),
    from = 4), !TRUE)
expect_equivalent(stri_startswith_coll(stri_paste("\u0635\u0644\u0649 \u0627\u0644\u0644\u0647 ", "\u0639\u0644\u064A\u0647 \u0648\u0633\u0644\u0645"),
    "\uFDFA", strength = 1, locale="en"), TRUE)
expect_equivalent(stri_startswith_coll(stri_paste("\u0635\u0644\u0649 \u0627\u0644\u0644\u0647 ", "\u0639\u0644\u064A\u0647 \u0648\u0633\u0644\u0645\uFDFA"),
    "\uFDFA", opts_collator = stri_opts_collator(strength = 1, locale="en")), TRUE)

expect_identical(stri_endswith_coll("a", NA), NA)
expect_identical(stri_endswith_coll(NA, "a"), NA)
expect_identical(stri_endswith_coll(NA, NA), NA)
expect_identical(stri_endswith_coll(c("", "ala"), "ala"), c(FALSE, TRUE))
expect_identical(stri_endswith_coll(c("ala", "", "", "bbb"), c("ala", "bbb")),
    c(TRUE, FALSE, FALSE, TRUE))
expect_identical(stri_endswith_coll(c("ala", "", "", "bbb"), c("ala", "bbb"), negate=TRUE),
    !c(TRUE, FALSE, FALSE, TRUE))
expect_identical(stri_endswith_coll("kot lorem1", character(0)), logical(0))
expect_identical(stri_endswith_coll(character(0), "ipsum 1234"), logical(0))
expect_identical(stri_endswith_coll(character(0), character(0)), logical(0))
expect_identical(stri_endswith_coll(c("ab", "cab", "ccccab", "abaabaaaa"), "ab"),
    c(T, T, T, F))
expect_identical(stri_endswith_coll(c("Lorem\n123", " ", "kota", "4\t\u0105"), c(" ",
    "\t\u0105")), c(F, F, F, T))
expect_warning(stri_endswith_coll(rep("asd", 5), rep("a", 2)))
expect_identical(stri_endswith_coll("\u0104\u0105", stri_trans_nfkd("\u0104\u0105")), TRUE)
expect_equivalent(stri_endswith_coll("aaaab", "ab"), TRUE)
expect_equivalent(stri_endswith_coll("bababababaab", "bab", to = c(-1, -2, -3,
    -4, 4, 3)), c(F, F, F, T, F, T))
expect_equivalent(stri_endswith_coll("\u0105\u0104\u0105\u0104\u0105\u0104\u0105\u0104\u0105\u0104\u0104\u0105", "\u0105\u0104\u0105", to = c(-1,
    -2, -3, -4, 4, 3)), c(F, F, F, T, F, T))
expect_equivalent(stri_endswith("\u0105\u0104\u0105\u0104\u0105\u0104\u0105\u0104\u0105\u0104\u0104\u0105", coll = "\u0105\u0104\u0105",
    to = c(-1, -2, -3, -4, 4, 3)), c(F, F, F, T, F, T))

expect_equivalent(stri_endswith_coll("aba", "a", c(-1, -1e+08, 0, 1e+07)), c(T,
    F, F, T))
expect_equivalent(stri_endswith_coll("a", "agsdgsjgidjso", c(-1, 1, -2, 2, 0)),
    c(F, F, F, F, F))
suppressWarnings(expect_identical(stri_endswith_coll("", ""), NA))
suppressWarnings(expect_identical(stri_endswith_coll("a", ""), NA))
suppressWarnings(expect_identical(stri_endswith_coll("", "a"), FALSE))

expect_equivalent(stri_endswith_coll("abc", "a", c(1, 2, 3)), c(TRUE, FALSE,
    FALSE))
expect_equivalent(stri_endswith_coll("abc", "b", c(1, 2, 3)), c(FALSE, TRUE,
    FALSE))
expect_equivalent(stri_endswith_coll("abc", "b", c(1, 2, 3), negate=TRUE), !c(FALSE, TRUE,
    FALSE))
expect_equivalent(stri_endswith_coll("abc", "c", c(1, 2, 3)), c(FALSE, FALSE,
    TRUE))
expect_equivalent(stri_endswith_coll("abc", "a", c(-3, -2, -1)), c(TRUE, FALSE,
    FALSE))
expect_equivalent(stri_endswith_coll("abc", "b", c(-3, -2, -1)), c(FALSE, TRUE,
    FALSE))
expect_equivalent(stri_endswith_coll("abc", "c", c(-3, -2, -1)), c(FALSE, FALSE,
    TRUE))

expect_equivalent(stri_endswith_coll("abc", "a", c(-1000, 0, 4)), c(FALSE, FALSE,
    FALSE))
expect_equivalent(stri_endswith_coll("ab", "b", c(-1000, 0, 4)), c(FALSE, FALSE,
    TRUE))
expect_equivalent(stri_endswith_coll("a", "b", c(-1000, 0, 4)), c(FALSE, FALSE,
    FALSE))

expect_equivalent(stri_endswith_coll("\uFDFA\uFDFA\uFDFA\uFDFAXYZ\uFDFA", stri_paste("\u0635\u0644\u0649 \u0627\u0644\u0644\u0647 ",
    "\u0639\u0644\u064A\u0647 \u0648\u0633\u0644\u0645XYZ"), opts_collator = stri_opts_collator(strength = 1, locale="en"),
    to = -2), TRUE)
expect_equivalent(stri_endswith_coll(stri_paste("\u0635\u0644\u0649 \u0627\u0644\u0644\u0647 ", "\u0639\u0644\u064A\u0647 \u0648\u0633\u0644\u0645"),
    "\uFDFA", strength = 1, locale="en"), TRUE)
expect_equivalent(stri_endswith_coll(stri_paste("\u0635\u0644\u0649 \u0627\u0644\u0644\u0647 ", "\u0639\u0644\u064A\u0647 \u0648\u0633\u0644\u0645\uFDFA"),
    "\uFDFA", opts_collator = stri_opts_collator(strength = 1, locale="en"), to = -2), TRUE)

