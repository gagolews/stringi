require(testthat)
context("test-split-other.R")

test_that("stri_split_lines", {
    expect_identical(stri_split_lines("ala\r\nma\r\nkota"), list(c("ala", "ma", "kota")))
    expect_identical(stri_split_lines("ala\r\nma\r\nkota\r\n"), list(c("ala", "ma", 
        "kota", "")))
    expect_identical(stri_split_lines1("ala\r\nma\r\nkota"), c("ala", "ma", "kota"))
    expect_identical(stri_split_lines1("ala\r\nma\r\nkota\r\n"), c("ala", "ma", "kota"))
    expect_warning(stri_split_lines1(c("a", "b")))
    suppressWarnings(expect_identical(stri_split_lines1(c("a", "b")), "a"))
    expect_identical(stri_split_lines("ala\r\nma\r\nkota\r\n", omit_empty = TRUE), 
        list(c("ala", "ma", "kota")))
    expect_identical(stri_split_lines(NA_character_), list(NA_character_))
    expect_identical(stri_split_lines(character(0)), list())
    expect_identical(stri_split_lines(""), list(""))
    expect_identical(stri_split_lines(c("", "a", NA)), list("", "a", NA_character_))
    expect_identical(stri_split_lines("", omit_empty = TRUE), list(character(0)))
    expect_identical(stri_split_lines("\n"), list(c("", "")))
    expect_identical(stri_split_lines("\n", omit_empty = TRUE), list(character(0)))
    expect_identical(stri_split_lines("\n\n"), list(c("", "", "")))
    expect_identical(stri_split_lines("a\n\n\na"), list(c("a", "", "", "a")))
    expect_identical(stri_split_lines("a\n\n\na", omit_empty = TRUE), list(c("a", 
        "a")))
    #    expect_identical(stri_split_lines('a\n\n\na\n\na', n=3), list(c('a', '', '\na\n\na')))
    #    expect_identical(stri_split_lines('a\n\n\na\n\na', n=3, omit_empty=TRUE), list(c('a', 'a', '\na')))
})


test_that("stri_split_boundaries", {
    expect_error(stri_split_boundaries("aaa", opts_brkiter = stri_opts_brkiter(type = "???")))
    expect_error(stri_split_boundaries("aaa", opts_brkiter = stri_opts_brkiter(type = "word2")))
    expect_error(stri_split_boundaries("aaa", opts_brkiter = list()))
    expect_identical(stri_split_boundaries(c(NA, NA), opts_brkiter = stri_opts_brkiter(type = "word")), 
        list(NA_character_, NA_character_))
    expect_identical(stri_split_boundaries("", opts_brkiter = stri_opts_brkiter(type = "word")), 
        list(character(0)))
    expect_identical(stri_split_boundaries("    \t\n   ", opts_brkiter = stri_opts_brkiter(type = "word", 
        skip_word_none = TRUE)), list(character(0)))
    expect_identical(stri_split_boundaries("ąąą", opts_brkiter = stri_opts_brkiter(type = "word")), 
        list("ąąą"))
    expect_identical(stri_split_boundaries("aaa", opts_brkiter = stri_opts_brkiter(type = "line")), 
        list("aaa"))
    expect_identical(stri_split_boundaries("aaa", opts_brkiter = stri_opts_brkiter(type = "sentence")), 
        list("aaa"))
    expect_identical(stri_split_boundaries(stri_trans_nfkd("aą"), type = "chara")[[1]], 
        stri_trans_nfkd(c("a", "ą")))
    
    
    expect_identical(stri_split_boundaries("   aaa bbb ccc ddd   ", opts_brkiter = stri_opts_brkiter(type = "word", 
        skip_word_none = TRUE)), list(c("aaa", "bbb", "ccc", "ddd")))
    
    expect_identical(stri_split_boundaries("   ąąą ĆĆĆ ć ĈĈĈĈ   ", opts_brkiter = stri_opts_brkiter(type = "word", 
        skip_word_none = TRUE)), list(c("ąąą", "ĆĆĆ", "ć", "ĈĈĈĈ")))
    
    expect_identical(stri_split_boundaries("   aaa bbb ccc ddd   ", n = 3, opts_brkiter = stri_opts_brkiter(type = "word", 
        skip_word_none = TRUE)), list(c("aaa", "bbb", "ccc ddd   ")))
    
    expect_identical(stri_split_boundaries("   aaa bbb ccc ddd   ", n = 4, type = "word", 
        skip_word_none = TRUE), list(c("aaa", "bbb", "ccc", "ddd   ")))
    
    expect_identical(stri_split_boundaries("   aaa bbb ccc ddd   ", n = 5, opts_brkiter = stri_opts_brkiter(type = "word", 
        skip_word_none = TRUE)), list(c("aaa", "bbb", "ccc", "ddd")))
    
    expect_identical(stri_split_boundaries("   aaa bbb ccc ddd   ", n = 2, opts_brkiter = stri_opts_brkiter(type = "word", 
        skip_word_none = TRUE)), list(c("aaa", "bbb ccc ddd   ")))
    
    expect_identical(stri_split_boundaries("   aaa bbb ccc ddd   ", n = 1, opts_brkiter = stri_opts_brkiter(type = "word", 
        skip_word_none = TRUE)), list(c("aaa bbb ccc ddd   ")))
    
    expect_identical(stri_split_boundaries("   aaa bbb ccc ddd   ", n = 0:5, tokens_only = TRUE, 
        opts_brkiter = stri_opts_brkiter(type = "word", skip_word_none = TRUE)), 
        lapply(c(0:4, 4), function(i) c("aaa", "bbb", "ccc", "ddd")[seq_len(i)]))
    
    expect_identical(stri_split_boundaries("   aaa bbb ccc ddd   ", n = 3, tokens_only = TRUE, 
        opts_brkiter = stri_opts_brkiter(type = "word", skip_word_none = TRUE)), 
        list(c("aaa", "bbb", "ccc")))
    
    expect_identical(stri_split_boundaries("   aaa bbb ccc ddd   ", n = 4, tokens_only = TRUE, 
        opts_brkiter = stri_opts_brkiter(type = "word", skip_word_none = TRUE)), 
        list(c("aaa", "bbb", "ccc", "ddd")))
    
    expect_identical(stri_split_boundaries("   aaa bbb ccc ddd   ", n = 5, tokens_only = TRUE, 
        opts_brkiter = stri_opts_brkiter(type = "word", skip_word_none = TRUE)), 
        list(c("aaa", "bbb", "ccc", "ddd")))
    
    expect_identical(stri_split_boundaries("   aaa bbb ccc ddd   ", n = 4, tokens_only = TRUE, 
        simplify = TRUE, opts_brkiter = stri_opts_brkiter(type = "word", skip_word_none = TRUE)), 
        matrix(c("aaa", "bbb", "ccc", "ddd"), byrow = TRUE, nrow = 1))
    
    expect_identical(stri_split_boundaries("   aaa bbb ccc ddd   ", n = 5, tokens_only = TRUE, 
        simplify = TRUE, opts_brkiter = stri_opts_brkiter(type = "word", skip_word_none = TRUE)), 
        matrix(c("aaa", "bbb", "ccc", "ddd", ""), byrow = TRUE, nrow = 1))
    
    expect_identical(stri_split_boundaries("   aaa bbb ccc ddd   ", n = 5, tokens_only = TRUE, 
        simplify = NA, opts_brkiter = stri_opts_brkiter(type = "word", skip_word_none = TRUE)), 
        matrix(c("aaa", "bbb", "ccc", "ddd", NA), byrow = TRUE, nrow = 1))
    
    expect_identical(stri_split_boundaries(c("aaa bbb", "ccc"), type = "word", skip_word_none = TRUE), 
        list(c("aaa", "bbb"), "ccc"))
    
    expect_identical(stri_split_boundaries(c("aaa bbb", "ccc"), simplify = NA, opts_brkiter = stri_opts_brkiter(type = "word", 
        skip_word_none = TRUE)), matrix(c("aaa", "bbb", "ccc", NA), nrow = 2, byrow = TRUE))
    
    expect_identical(stri_split_boundaries(c("aaa bbb", "ccc"), simplify = TRUE, 
        opts_brkiter = stri_opts_brkiter(type = "word", skip_word_none = TRUE)), 
        matrix(c("aaa", "bbb", "ccc", ""), nrow = 2, byrow = TRUE))
})
