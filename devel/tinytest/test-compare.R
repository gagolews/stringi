library("tinytest")
library("stringi")



expect_identical("a" %stri==% c("a", "b"), c(TRUE, FALSE))
expect_identical("a" %stri==% c("a", NA), c(TRUE, NA))
expect_identical("a" %stri===% c("a", NA), c(TRUE, NA))
expect_identical("a" %stri===% c("a", "b"), c(TRUE, FALSE))
expect_identical("a" %stri!=% c("b", "a"), c(TRUE, FALSE))
expect_identical("a" %stri!==% c("b", "a"), c(TRUE, FALSE))

expect_identical("ą" %stri==% stri_trans_nfkd("ą"), TRUE)
expect_identical("ą" %stri===% stri_trans_nfkd("ą"), FALSE)
expect_identical("ą" %stri!=% stri_trans_nfkd("ą"), FALSE)
expect_identical("ą" %stri!==% stri_trans_nfkd("ą"), TRUE)

expect_identical("b" %stri<% c("a", "b", "c"), c(FALSE, FALSE, TRUE))
expect_identical("b" %stri<=% c("a", "b", "c"), c(FALSE, TRUE, TRUE))
expect_identical("b" %stri>% c("a", "b", "c"), c(TRUE, FALSE, FALSE))
expect_identical("b" %stri>=% c("a", "b", "c"), c(TRUE, TRUE, FALSE))




expect_equivalent(stri_cmp(character(0), character(0)), integer(0))
expect_equivalent(stri_cmp(LETTERS, character(0)), integer(0))
expect_equivalent(stri_cmp(character(0), LETTERS), integer(0))

expect_equivalent(stri_cmp(LETTERS, LETTERS, locale="en"), rep(0L, length(LETTERS)))
expect_equivalent(stri_cmp(letters, LETTERS, locale="en"), rep(-1L, length(LETTERS)))
expect_equivalent(stri_cmp(LETTERS, letters, locale="en"), rep(+1L, length(LETTERS)))
expect_equivalent(stri_cmp(c(NA, "a", "b"), "a"), c(NA_integer_, 0L, 1L))

expect_false(stri_cmp("å̧", "å̧") == 0)
expect_true(stri_cmp("å̧", "å̧", normalisation = TRUE) == 0)
expect_true(stri_cmp("å̧", "å̧", normalization = TRUE) == 0)

#expect_warning(stri_cmp('å\u0327', 'a\u0327\u030A', nrmaliztion=FALSE)) # DEPRECATED!


expect_equivalent(stri_cmp("hladny", "chladny", locale = "pl_PL"), 1L)
expect_equivalent(stri_cmp("hladny", "chladny", locale = "sk_SK"), -1L)
expect_equivalent(stri_cmp(letters, LETTERS, strength = 2, locale="en"), rep(0L, length(LETTERS)))

expect_equivalent(stri_cmp("dupa100", "dupa2"), -1)
expect_equivalent(stri_cmp("dupa100", NA), NA_integer_)
expect_equivalent(stri_cmp(NA, "dupa2"), NA_integer_)
expect_equivalent(stri_cmp("dupa100", "dupa1000"), -1)
expect_equivalent(stri_cmp("dupa10000", "dupa1000"), 1)
expect_equivalent(stri_cmp("dupa100", "dupa2", numeric = TRUE), 1)
expect_equivalent(stri_cmp("above mentioned", "above-mentioned"), -1)
expect_equivalent(stri_cmp("above mentioned", "above-mentioned", alternate_shifted = TRUE, locale="en"),
    0)

expect_equivalent(stri_cmp(stri_trans_nfkd("ą"), "ą"), 0L)

expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator = stri_opts_collator(alternate_shifted = NA)))
expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator = stri_opts_collator(strength = NA)))
expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator = stri_opts_collator(french = NA)))
expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator = stri_opts_collator(case_level = NA)))
expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator = stri_opts_collator(normalization = NA)))
expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator = stri_opts_collator(numeric = NA)))

expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator = stri_opts_collator(alternate_shifted = "error:)")))
expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator = stri_opts_collator(french = "error:)")))
expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator = stri_opts_collator(case_level = "error:)")))
expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator = stri_opts_collator(normalization = "error:)")))
expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator = stri_opts_collator(numeric = "error:)")))






expect_equivalent(stri_cmp_lt(character(0), character(0)), logical(0))
expect_equivalent(stri_cmp_lt(LETTERS, character(0)), logical(0))
expect_equivalent(stri_cmp_lt(character(0), LETTERS), logical(0))

expect_equivalent(stri_cmp_lt(LETTERS, LETTERS), rep(FALSE, length(LETTERS)))
expect_equivalent(stri_cmp_le(LETTERS, LETTERS), rep(TRUE, length(LETTERS)))
expect_equivalent(stri_cmp_le(c(NA, "a", "b"), "a"), c(NA, TRUE, FALSE))
expect_equivalent(stri_cmp_le("dupa", "pupa"), TRUE)
expect_equivalent(stri_cmp_lt("dupa", "pupa"), TRUE)
expect_equivalent(stri_cmp_ge("dupa", "pupa"), FALSE)
expect_equivalent(stri_cmp_gt("dupa", "pupa"), FALSE)



expect_equivalent(stri_cmp_equiv(character(0), character(0)), logical(0))
expect_equivalent(stri_cmp_equiv(LETTERS, character(0)), logical(0))
expect_equivalent(stri_cmp_equiv(character(0), LETTERS), logical(0))

expect_equivalent(stri_cmp_equiv(LETTERS, LETTERS), rep(TRUE, length(LETTERS)))
expect_equivalent(stri_cmp_nequiv(LETTERS, LETTERS), rep(FALSE, length(LETTERS)))
expect_equivalent(stri_cmp_equiv(LETTERS, letters), rep(FALSE, length(LETTERS)))
expect_equivalent(stri_cmp_nequiv(LETTERS, letters), rep(TRUE, length(LETTERS)))
expect_equivalent(stri_cmp_equiv(c(NA, "a", "b"), "a"), c(NA, TRUE, FALSE))
expect_equivalent(stri_cmp_nequiv(c(NA, "a", "b"), "a"), !c(NA, TRUE, FALSE))

expect_equivalent(stri_cmp_equiv("dupa100", "dupa2"), FALSE)
expect_equivalent(stri_cmp_equiv("dupa100", "dupa1000"), FALSE)
expect_equivalent(stri_cmp_equiv("dupa10000", "dupa1000"), FALSE)
expect_equivalent(stri_cmp_equiv("above mentioned", "above-mentioned"), FALSE)
expect_equivalent(stri_cmp_equiv("above mentioned", "above-mentioned", alternate_shifted = TRUE, locale="en"),
    TRUE)

expect_equivalent(stri_cmp_equiv(stri_trans_nfkd("ą"), "ą"), TRUE)



expect_equivalent(stri_cmp_eq(character(0), character(0)), logical(0))
expect_equivalent(stri_cmp_eq(LETTERS, character(0)), logical(0))
expect_equivalent(stri_cmp_eq(character(0), LETTERS), logical(0))

expect_equivalent(stri_cmp_eq(LETTERS, LETTERS), rep(TRUE, length(LETTERS)))
expect_equivalent(stri_cmp_neq(LETTERS, LETTERS), rep(FALSE, length(LETTERS)))
expect_equivalent(stri_cmp_eq(LETTERS, letters), rep(FALSE, length(LETTERS)))
expect_equivalent(stri_cmp_neq(LETTERS, letters), rep(TRUE, length(LETTERS)))
expect_equivalent(stri_cmp_eq(c(NA, "a", "b"), "a"), c(NA, TRUE, FALSE))
expect_equivalent(stri_cmp_neq(c(NA, "a", "b"), "a"), !c(NA, TRUE, FALSE))

expect_equivalent(stri_cmp_eq("dupa100", "dupa2"), FALSE)
expect_equivalent(stri_cmp_eq("dupa100", "dupa1000"), FALSE)
expect_equivalent(stri_cmp_eq("dupa10000", "dupa1000"), FALSE)
expect_equivalent(stri_cmp_eq("above mentioned", "above-mentioned"), FALSE)

expect_equivalent(stri_cmp_eq(stri_trans_nfkd("ą"), "ą"), FALSE)
