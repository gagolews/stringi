require("testthat")
context("test-startsendswith-coll.R")

test_that("stri_startswith_coll", {
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
    expect_identical(stri_startswith_coll(c("Lorem\n123", " ", "kota", "\tą4"), 
        c(" ", "\tą")), c(F, F, F, T))
    expect_warning(stri_startswith_coll(rep("asd", 5), rep("a", 2)))
    expect_identical(stri_startswith_coll("Ąą", stri_trans_nfkd("Ąą")), TRUE)
    expect_equivalent(stri_startswith_coll("aaaab", "ab"), FALSE)
    expect_equivalent(stri_startswith_coll("bababababaab", "bab"), TRUE)
    expect_equivalent(stri_startswith_coll("bababababaab", "bab", from = c(1, 2, 
        3)), c(T, F, T))
    expect_equivalent(stri_startswith_coll("ąĄąĄą", "ąĄą", from = c(1, 2, 
        3, 100, -3)), c(T, F, T, F, T))
    expect_equivalent(stri_startswith("ąĄąĄą", coll = "ąĄą", from = c(1, 
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
    
    expect_equivalent(stri_startswith_coll("abc", "a", c(-1000, 0, 4)), c(TRUE, TRUE, 
        FALSE))
    expect_equivalent(stri_startswith_coll("ab", "b", c(-1000, 0, 3)), c(FALSE, FALSE, 
        FALSE))
    expect_equivalent(stri_startswith_coll("a", "b", c(-1000, 0, 2)), c(FALSE, FALSE, 
        FALSE))
    
    suppressWarnings(expect_identical(stri_startswith_coll("", ""), NA))
    suppressWarnings(expect_identical(stri_startswith_coll("a", ""), NA))
    suppressWarnings(expect_identical(stri_startswith_coll("", "a"), FALSE))
    
    expect_equivalent(stri_startswith_coll("ﷺﷺﷺﷺXYZﷺ", stri_paste("صلى الله ", 
        "عليه وسلمXYZ"), opts_collator = stri_opts_collator(strength = 1), 
        from = 4), TRUE)
    expect_equivalent(stri_startswith_coll(stri_paste("صلى الله ", "عليه وسلم"), 
        "ﷺ", strength = 1), TRUE)
    expect_equivalent(stri_startswith_coll(stri_paste("صلى الله ", "عليه وسلمﷺ"), 
        "ﷺ", opts_collator = stri_opts_collator(strength = 1)), TRUE)
})

test_that("stri_endswith_coll", {
    expect_identical(stri_endswith_coll("a", NA), NA)
    expect_identical(stri_endswith_coll(NA, "a"), NA)
    expect_identical(stri_endswith_coll(NA, NA), NA)
    expect_identical(stri_endswith_coll(c("", "ala"), "ala"), c(FALSE, TRUE))
    expect_identical(stri_endswith_coll(c("ala", "", "", "bbb"), c("ala", "bbb")), 
        c(TRUE, FALSE, FALSE, TRUE))
    expect_identical(stri_endswith_coll("kot lorem1", character(0)), logical(0))
    expect_identical(stri_endswith_coll(character(0), "ipsum 1234"), logical(0))
    expect_identical(stri_endswith_coll(character(0), character(0)), logical(0))
    expect_identical(stri_endswith_coll(c("ab", "cab", "ccccab", "abaabaaaa"), "ab"), 
        c(T, T, T, F))
    expect_identical(stri_endswith_coll(c("Lorem\n123", " ", "kota", "4\tą"), c(" ", 
        "\tą")), c(F, F, F, T))
    expect_warning(stri_endswith_coll(rep("asd", 5), rep("a", 2)))
    expect_identical(stri_endswith_coll("Ąą", stri_trans_nfkd("Ąą")), TRUE)
    expect_equivalent(stri_endswith_coll("aaaab", "ab"), TRUE)
    expect_equivalent(stri_endswith_coll("bababababaab", "bab", to = c(-1, -2, -3, 
        -4, 4, 3)), c(F, F, F, T, F, T))
    expect_equivalent(stri_endswith_coll("ąĄąĄąĄąĄąĄĄą", "ąĄą", to = c(-1, 
        -2, -3, -4, 4, 3)), c(F, F, F, T, F, T))
    expect_equivalent(stri_endswith("ąĄąĄąĄąĄąĄĄą", coll = "ąĄą", 
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
    
    expect_equivalent(stri_endswith_coll("ﷺﷺﷺﷺXYZﷺ", stri_paste("صلى الله ", 
        "عليه وسلمXYZ"), opts_collator = stri_opts_collator(strength = 1), 
        to = -2), TRUE)
    expect_equivalent(stri_endswith_coll(stri_paste("صلى الله ", "عليه وسلم"), 
        "ﷺ", strength = 1), TRUE)
    expect_equivalent(stri_endswith_coll(stri_paste("صلى الله ", "عليه وسلمﷺ"), 
        "ﷺ", opts_collator = stri_opts_collator(strength = 1), to = -2), TRUE)
})
