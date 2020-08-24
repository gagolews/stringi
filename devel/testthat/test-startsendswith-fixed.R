require("testthat")
context("test-startsendswith-fixed.R")

test_that("stri_startswith_fixed", {
    expect_identical(stri_startswith_fixed("a", NA), NA)
    expect_identical(stri_startswith_fixed(NA, "a"), NA)
    expect_identical(stri_startswith_fixed(NA, NA), NA)
    expect_identical(stri_startswith_fixed(c("", "ala"), "ala"), c(FALSE, TRUE))
    expect_identical(stri_startswith_fixed(c("ala", "", "", "bbb"), c("ala", "bbb")),
        c(TRUE, FALSE, FALSE, TRUE))
    expect_identical(stri_startswith_fixed(c("ala", "", "", "bbb"), c("ala", "bbb"), negate=TRUE),
        !c(TRUE, FALSE, FALSE, TRUE))
    expect_identical(stri_startswith_fixed("kot lorem1", character(0)), logical(0))
    expect_identical(stri_startswith_fixed(character(0), "ipsum 1234"), logical(0))
    expect_identical(stri_startswith_fixed(character(0), character(0)), logical(0))
    expect_identical(stri_startswith_fixed(c("ab", "cab", "ccccab", "abaabaaaa"),
        "ab"), c(T, F, F, T))
    expect_identical(stri_startswith_fixed(c("Lorem\n123", " ", "kota", "\tą4"),
        c(" ", "\tą")), c(F, F, F, T))
    expect_identical(stri_startswith_fixed(c("Lorem\n123", " ", "kota", "\tą4"),
        c(" ", "\tą"), negate=TRUE), !c(F, F, F, T))
    expect_warning(stri_startswith_fixed(rep("asd", 5), rep("a", 2)))
    expect_identical(stri_startswith_fixed("Ąą", stri_trans_nfkd("Ąą")), FALSE)
    expect_equivalent(stri_startswith_fixed("aba", "abab"), FALSE)
    expect_equivalent(stri_startswith_fixed("aba", "abab", case_insensitive = TRUE),
        FALSE)
    expect_equivalent(stri_startswith_fixed("abab", "abab"), TRUE)
    expect_equivalent(stri_startswith_fixed("abab", "abab", case_insensitive = TRUE),
        TRUE)
    expect_equivalent(stri_startswith_fixed("aaaab", "ab"), FALSE)
    expect_equivalent(stri_startswith_fixed("bababababaab", "bab"), TRUE)
    expect_equivalent(stri_startswith_fixed("bababababaab", "bab", from = c(1, 2,
        3)), c(T, F, T))
    expect_equivalent(stri_startswith_fixed("bababababaab", "BAB", case_insensitive = TRUE,
        from = c(1, 2, 3)), c(T, F, T))
    expect_equivalent(stri_startswith_fixed("ąĄąĄą", "ąĄą", from = c(1, 2,
        3, 100, -3)), c(T, F, T, F, T))
    expect_equivalent(stri_startswith("ąĄąĄą", fixed = "ąĄą", from = c(1,
        2, 3, 100, -3)), c(T, F, T, F, T))
    expect_equivalent(stri_startswith_fixed("a", "agsdgsjgidjso", c(-1, 1, -2, 2,
        0)), c(F, F, F, F, F))

    for (val in c(FALSE, TRUE)) {
        expect_equivalent(stri_startswith_fixed("abc", "a", c(1, 2, 3), case_insensitive = val),
            c(TRUE, FALSE, FALSE))
        expect_equivalent(stri_startswith_fixed("abc", "b", c(1, 2, 3), case_insensitive = val),
            c(FALSE, TRUE, FALSE))
        expect_equivalent(stri_startswith_fixed("abc", "c", c(1, 2, 3), case_insensitive = val),
            c(FALSE, FALSE, TRUE))
        expect_equivalent(stri_startswith_fixed("abc", "a", c(-3, -2, -1), case_insensitive = val),
            c(TRUE, FALSE, FALSE))
        expect_equivalent(stri_startswith_fixed("abc", "b", c(-3, -2, -1), case_insensitive = val),
            c(FALSE, TRUE, FALSE))
        expect_equivalent(stri_startswith_fixed("abc", "c", c(-3, -2, -1), case_insensitive = val),
            c(FALSE, FALSE, TRUE))

        expect_equivalent(stri_startswith_fixed("abc", "a", c(-1000, 0, 4), case_insensitive = val),
            c(TRUE, TRUE, FALSE))
        expect_equivalent(stri_startswith_fixed("ab", "b", c(-1000, 0, 3), case_insensitive = val),
            c(FALSE, FALSE, FALSE))
        expect_equivalent(stri_startswith_fixed("a", "b", c(-1000, 0, 2), case_insensitive = val),
            c(FALSE, FALSE, FALSE))

        expect_equivalent(stri_startswith_fixed("ĆĄĆĄĆ", "ĆĄĆ", from = c(1,
            2, 3, 100, -3), case_insensitive = val), c(T, F, T, F, T))
        expect_equivalent(stri_startswith_fixed("ĆĄĆĄĆ", "ĆĄĆ", from = c(1,
            2, 3, 100, -3), case_insensitive = val, negate = TRUE), !c(T, F, T, F, T))
        expect_equivalent(stri_startswith("ĆĄĆĄĆ", fixed = "ĆĄĆ", from = c(1,
            2, 3, 100, -3), case_insensitive = val), c(T, F, T, F, T))
    }

    suppressWarnings(expect_identical(stri_startswith_fixed("", ""), NA))
    suppressWarnings(expect_identical(stri_startswith_fixed("a", ""), NA))
    suppressWarnings(expect_identical(stri_startswith_fixed("", "a"), FALSE))
})


test_that("stri_endswith_fixed", {
    expect_identical(stri_endswith_fixed("a", NA), NA)
    expect_identical(stri_endswith_fixed(NA, "a"), NA)
    expect_identical(stri_endswith_fixed(NA, NA), NA)
    expect_identical(stri_endswith_fixed(c("", "ala"), "ala"), c(FALSE, TRUE))
    expect_identical(stri_endswith_fixed(c("ala", "", "", "bbb"), c("ala", "bbb")),
        c(TRUE, FALSE, FALSE, TRUE))
    expect_identical(stri_endswith_fixed(c("ala", "", "", "bbb"), c("ala", "bbb"), negate=TRUE),
        !c(TRUE, FALSE, FALSE, TRUE))
    expect_identical(stri_endswith_fixed("kot lorem1", character(0)), logical(0))
    expect_identical(stri_endswith_fixed(character(0), "ipsum 1234"), logical(0))
    expect_identical(stri_endswith_fixed(character(0), character(0)), logical(0))
    expect_identical(stri_endswith_fixed(c("ab", "cab", "ccccab", "abaabaaaa"), "ab"),
        c(T, T, T, F))
    expect_identical(stri_endswith_fixed(c("Lorem\n123", " ", "kota", "4\tą"), c(" ",
        "\tą")), c(F, F, F, T))
    expect_warning(stri_endswith_fixed(rep("asd", 5), rep("a", 2)))
    expect_identical(stri_endswith_fixed("Ąą", stri_trans_nfkd("Ąą")), FALSE)
    expect_equivalent(stri_endswith_fixed("bababababaab", "bab", to = c(-1, -2, -3,
        -4, 4, 3)), c(F, F, F, T, F, T))
    expect_equivalent(stri_endswith_fixed("aaaab", "ab"), TRUE)
    expect_equivalent(stri_endswith_fixed("aaaab", "ab", case_insensitive = TRUE),
        TRUE)
    expect_equivalent(stri_endswith_fixed("aba", "ababa"), FALSE)
    expect_equivalent(stri_endswith_fixed("aba", "ababa", case_insensitive = TRUE),
        FALSE)

    expect_equivalent(stri_endswith_fixed("aba", "a", c(-1, -1e+08, 0, 1e+07)), c(T,
        F, F, T))
    expect_equivalent(stri_endswith_fixed("a", "agsdgsjgidjso", c(-1, 1, -2, 2, 0)),
        c(F, F, F, F, F))
    suppressWarnings(expect_identical(stri_endswith_fixed("", ""), NA))
    suppressWarnings(expect_identical(stri_endswith_fixed("a", ""), NA))
    suppressWarnings(expect_identical(stri_endswith_fixed("", "a"), FALSE))

    expect_equivalent(stri_endswith_fixed("bababababaab", "BAB", case_insensitive = TRUE,
        to = c(-1, -2, -3, -4, 4, 3)), c(F, F, F, T, F, T))

    for (val in c(FALSE, TRUE)) {
        expect_equivalent(stri_endswith_fixed("abc", "a", c(1, 2, 3), case_insensitive = val),
            c(TRUE, FALSE, FALSE))
        expect_equivalent(stri_endswith_fixed("abc", "b", c(1, 2, 3), case_insensitive = val),
            c(FALSE, TRUE, FALSE))
        expect_equivalent(stri_endswith_fixed("abc", "c", c(1, 2, 3), case_insensitive = val),
            c(FALSE, FALSE, TRUE))
        expect_equivalent(stri_endswith_fixed("abc", "a", c(-3, -2, -1), case_insensitive = val),
            c(TRUE, FALSE, FALSE))
        expect_equivalent(stri_endswith_fixed("abc", "a", c(-3, -2, -1), case_insensitive = val, negate=TRUE),
            !c(TRUE, FALSE, FALSE))
        expect_equivalent(stri_endswith_fixed("abc", "b", c(-3, -2, -1), case_insensitive = val),
            c(FALSE, TRUE, FALSE))
        expect_equivalent(stri_endswith_fixed("abc", "c", c(-3, -2, -1), case_insensitive = val),
            c(FALSE, FALSE, TRUE))

        expect_equivalent(stri_endswith_fixed("abc", "a", c(-1000, 0), case_insensitive = val),
            c(FALSE, FALSE))
        expect_equivalent(stri_endswith_fixed("ab", "b", c(-1000, 0), case_insensitive = val),
            c(FALSE, FALSE))
        expect_equivalent(stri_endswith_fixed("a", "b", c(-1000, 0), case_insensitive = val),
            c(FALSE, FALSE))

        expect_equivalent(stri_endswith_fixed("abc", "a", c(-1000, 0, 4), case_insensitive = val),
            c(FALSE, FALSE, FALSE))
        expect_equivalent(stri_endswith_fixed("ab", "b", c(-1000, 0, 4), case_insensitive = val),
            c(FALSE, FALSE, TRUE))
        expect_equivalent(stri_endswith_fixed("a", "b", c(-1000, 0, 4), case_insensitive = val),
            c(FALSE, FALSE, FALSE))

        expect_equivalent(stri_endswith_fixed("ĆĄĆĄĆĄĆĄĆĄĄĆ", "ĆĄĆ",
            to = c(-1, -2, -3, -4, 4, 3), case_insensitive = val), c(F, F, F, T,
            F, T))
        expect_equivalent(stri_endswith("ĆĄĆĄĆĄĆĄĆĄĄĆ", fixed = "ĆĄĆ",
            to = c(-1, -2, -3, -4, 4, 3), case_insensitive = val), c(F, F, F, T,
            F, T))
    }
})
