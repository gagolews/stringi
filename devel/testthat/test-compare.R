require(testthat)
context("test-compare.R")

test_that("stri_cmp_operators", {

   expect_identical("a" %stri==% c("a", "b"), c(TRUE, FALSE))
   expect_identical("a" %stri==% c("a", NA), c(TRUE, NA))
   expect_identical("a" %stri===% c("a", NA), c(TRUE, NA))
   expect_identical("a" %stri===% c("a", "b"), c(TRUE, FALSE))
   expect_identical("a" %stri!=% c("b", "a"), c(TRUE, FALSE))
   expect_identical("a" %stri!==% c("b", "a"), c(TRUE, FALSE))

   expect_identical("\u0105" %stri==% stri_trans_nfkd("\u0105"), TRUE)
   expect_identical("\u0105" %stri===% stri_trans_nfkd("\u0105"), FALSE)
   expect_identical("\u0105" %stri!=% stri_trans_nfkd("\u0105"), FALSE)
   expect_identical("\u0105" %stri!==% stri_trans_nfkd("\u0105"), TRUE)

   expect_identical("b" %stri<%  c("a", "b", "c"), c(FALSE, FALSE, TRUE))
   expect_identical("b" %stri<=% c("a", "b", "c"), c(FALSE, TRUE, TRUE))
   expect_identical("b" %stri>%  c("a", "b", "c"), c(TRUE, FALSE, FALSE))
   expect_identical("b" %stri>=% c("a", "b", "c"), c(TRUE, TRUE, FALSE))
})

test_that("stri_cmp", {

   expect_equivalent(stri_cmp(character(0), character(0)), integer(0))
   expect_equivalent(stri_cmp(LETTERS, character(0)), integer(0))
   expect_equivalent(stri_cmp(character(0), LETTERS), integer(0))

   expect_equivalent(stri_cmp(LETTERS, LETTERS), rep(0L,  length(LETTERS)))
   expect_equivalent(stri_cmp(letters, LETTERS), rep(-1L, length(LETTERS)))
   expect_equivalent(stri_cmp(LETTERS, letters), rep(+1L, length(LETTERS)))
   expect_equivalent(stri_cmp(c(NA, 'a', 'b'), 'a'), c(NA_integer_, 0L, 1L))

   expect_equivalent(stri_cmp("hladny", "chladny", locale="pl_PL"),  1L)
   expect_equivalent(stri_cmp("hladny", "chladny", locale="sk_SK"), -1L)
   expect_equivalent(stri_cmp(letters, LETTERS, strength=2), rep(0L, length(LETTERS)))

   expect_equivalent(stri_cmp("dupa100", "dupa2"), -1)
   expect_equivalent(stri_cmp("dupa100", NA), NA_integer_)
   expect_equivalent(stri_cmp(NA, "dupa2"), NA_integer_)
   expect_equivalent(stri_cmp("dupa100", "dupa1000"), -1)
   expect_equivalent(stri_cmp("dupa10000", "dupa1000"), 1)
   expect_equivalent(stri_cmp("dupa100", "dupa2", numeric=TRUE), 1)
   expect_equivalent(stri_cmp("above mentioned", "above-mentioned"), -1)
   expect_equivalent(stri_cmp("above mentioned", "above-mentioned", alternate_shifted=TRUE), 0)

   expect_equivalent(stri_cmp(stri_trans_nfkd('\u0105'), '\u105'), 0L)

   expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator=stri_opts_collator(alternate_shifted=NA)))
   expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator=stri_opts_collator(strength=NA)))
   expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator=stri_opts_collator(french=NA)))
   expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator=stri_opts_collator(case_level=NA)))
   expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator=stri_opts_collator(normalization=NA)))
   expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator=stri_opts_collator(numeric=NA)))

   expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator=stri_opts_collator(alternate_shifted="error:)")))
   expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator=stri_opts_collator(french="error:)")))
   expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator=stri_opts_collator(case_level="error:)")))
   expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator=stri_opts_collator(normalization="error:)")))
   expect_error(stri_cmp("above mentioned", "above-mentioned", opts_collator=stri_opts_collator(numeric="error:)")))

})


test_that("stri_cmp_lt/gt/le/ge", {

   expect_equivalent(stri_cmp_lt(character(0), character(0)), logical(0))
   expect_equivalent(stri_cmp_lt(LETTERS, character(0)), logical(0))
   expect_equivalent(stri_cmp_lt(character(0), LETTERS), logical(0))

   expect_equivalent(stri_cmp_lt(LETTERS, LETTERS), rep(FALSE,  length(LETTERS)))
   expect_equivalent(stri_cmp_le(LETTERS, LETTERS), rep(TRUE,  length(LETTERS)))
   expect_equivalent(stri_cmp_le(c(NA, 'a', 'b'), 'a'), c(NA, TRUE, FALSE))
   expect_equivalent(stri_cmp_le("dupa", "pupa"), TRUE)
   expect_equivalent(stri_cmp_lt("dupa", "pupa"), TRUE)
   expect_equivalent(stri_cmp_ge("dupa", "pupa"), FALSE)
   expect_equivalent(stri_cmp_gt("dupa", "pupa"), FALSE)

})

test_that("stri_cmp_equiv", {

   expect_equivalent(stri_cmp_equiv(character(0), character(0)), logical(0))
   expect_equivalent(stri_cmp_equiv(LETTERS, character(0)), logical(0))
   expect_equivalent(stri_cmp_equiv(character(0), LETTERS), logical(0))

   expect_equivalent(stri_cmp_equiv(LETTERS, LETTERS),  rep(TRUE,  length(LETTERS)))
   expect_equivalent(stri_cmp_nequiv(LETTERS, LETTERS), rep(FALSE,  length(LETTERS)))
   expect_equivalent(stri_cmp_equiv(LETTERS, letters),  rep(FALSE,  length(LETTERS)))
   expect_equivalent(stri_cmp_nequiv(LETTERS, letters), rep(TRUE,  length(LETTERS)))
   expect_equivalent(stri_cmp_equiv(c(NA, 'a', 'b'), 'a'), c(NA, TRUE, FALSE))
   expect_equivalent(stri_cmp_nequiv(c(NA, 'a', 'b'), 'a'), !c(NA, TRUE, FALSE))

   expect_equivalent(stri_cmp_equiv("dupa100", "dupa2"), FALSE)
   expect_equivalent(stri_cmp_equiv("dupa100", "dupa1000"), FALSE)
   expect_equivalent(stri_cmp_equiv("dupa10000", "dupa1000"), FALSE)
   expect_equivalent(stri_cmp_equiv("above mentioned", "above-mentioned"), FALSE)
   expect_equivalent(stri_cmp_equiv("above mentioned", "above-mentioned",
      alternate_shifted=TRUE), TRUE)

   expect_equivalent(stri_cmp_equiv(stri_trans_nfkd('\u0105'), '\u105'), TRUE)

})



test_that("stri_cmp_eq", {

   expect_equivalent(stri_cmp_eq(character(0), character(0)), logical(0))
   expect_equivalent(stri_cmp_eq(LETTERS, character(0)), logical(0))
   expect_equivalent(stri_cmp_eq(character(0), LETTERS), logical(0))

   expect_equivalent(stri_cmp_eq(LETTERS, LETTERS),  rep(TRUE,  length(LETTERS)))
   expect_equivalent(stri_cmp_neq(LETTERS, LETTERS), rep(FALSE,  length(LETTERS)))
   expect_equivalent(stri_cmp_eq(LETTERS, letters),  rep(FALSE,  length(LETTERS)))
   expect_equivalent(stri_cmp_neq(LETTERS, letters), rep(TRUE,  length(LETTERS)))
   expect_equivalent(stri_cmp_eq(c(NA, 'a', 'b'), 'a'), c(NA, TRUE, FALSE))
   expect_equivalent(stri_cmp_neq(c(NA, 'a', 'b'), 'a'), !c(NA, TRUE, FALSE))

   expect_equivalent(stri_cmp_eq("dupa100", "dupa2"), FALSE)
   expect_equivalent(stri_cmp_eq("dupa100", "dupa1000"), FALSE)
   expect_equivalent(stri_cmp_eq("dupa10000", "dupa1000"), FALSE)
   expect_equivalent(stri_cmp_eq("above mentioned", "above-mentioned"), FALSE)

   expect_equivalent(stri_cmp_eq(stri_trans_nfkd('\u0105'), '\u105'), FALSE)

})




test_that("stri_order", {

   expect_equivalent(stri_order(rep(NA, 5)), 1:5)
   expect_equivalent(stri_order(rep(NA, 5), na_last=FALSE), 1:5)
   expect_equivalent(stri_order(rep(NA, 5), na_last=NA), integer(0))
   expect_equivalent(stri_order(c(NA, "b", NA, "a")), c(4L, 2L, 1L, 3L))
   expect_equivalent(stri_order(c(NA, "b", NA, "a"), na_last=FALSE), c(1L, 3L, 4L, 2L))
   expect_equivalent(stri_order(c(NA, "b", NA, "a"), na_last=NA),    c(4L, 2L))

   expect_equivalent(stri_order(character(0)), integer(0))
   expect_equivalent(stri_order(LETTERS), 1:length(LETTERS))
   expect_equivalent(stri_order(c('c', 'a', 'b')), order(c('c', 'a', 'b')))
   expect_equivalent(stri_order(rev(LETTERS)), length(LETTERS):1)
   expect_equivalent(stri_order(rev(LETTERS)), rev(stri_order(LETTERS)))
   expect_equivalent(stri_order(LETTERS, decreasing=TRUE), length(LETTERS):1)

   expect_equivalent(stri_order(c("hladny", "chladny"), F, opts_collator=stri_opts_collator(locale="pl_PL")),2:1)
   expect_equivalent(stri_order(c("hladny", "chladny"), F, opts_collator=stri_opts_collator(locale="sk_SK")),1:2)

   expect_equivalent(stri_order(c('c', NA, 'a', NA, 'b', NA)), c(3, 5, 1, 2, 4, 6))
})


# test_that("stri_order [codepoints]", {
#
#    expect_equivalent(stri_order(character(0), opts_collator=NA), integer(0))
#    expect_equivalent(stri_order(LETTERS, opts_collator=NA), 1:length(LETTERS))
#    expect_equivalent(stri_order(rev(LETTERS), opts_collator=NA), length(LETTERS):1)
#    expect_equivalent(stri_order(c('c', 'a', 'b'), opts_collator=NA), order(c('c', 'a', 'b')))
#    expect_equivalent(stri_order(LETTERS, decreasing=TRUE, opts_collator=NA), length(LETTERS):1)
#
#
#    expect_equivalent(stri_order(c('c', NA, 'a', NA, 'b', NA), opts_collator=NA), c(3, 5, 1, 2, 4, 6))
# })

test_that("stri_sort", {

   expect_equivalent(stri_sort(character(0)), character(0))
   #expect_equivalent(stri_sort(NA),character(0))
   expect_equivalent(stri_sort(c("b", NA, "a", NA)), c("a", "b"))
   expect_equivalent(stri_sort(LETTERS[sample(length(LETTERS))]), LETTERS)
   expect_equivalent(stri_sort(rev(LETTERS)), LETTERS)
   expect_equivalent(stri_sort(rev(letters)), letters)
   expect_equivalent(stri_sort(c("abc","aab","baa","ab","aba")),c("aab","ab","aba","abc","baa"))
   expect_equivalent(stri_sort(c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107"),
      opts_collator=list(locale="pl_PL")),
      c("aab", "a\u0105b", "abc", "ab\u0107", "\u0105bc"))
   expect_equivalent(stri_sort(c("abc","aab",NA,"ab","aba"), na_last=TRUE),c("aab","ab","aba","abc",NA))
   expect_equivalent(stri_sort(c("abc","aab",NA,"ab","aba"), na_last=NA),c("aab","ab","aba","abc"))
   expect_equivalent(stri_sort(c("abc","aab",NA,"ab","aba"), na_last=FALSE),c(NA,"aab","ab","aba","abc"))
      expect_equivalent(stri_sort(c(NA,"abc","aab",NA,"ab","aba",NA), na_last=TRUE),c("aab","ab","aba","abc",NA,NA,NA))
   expect_equivalent(stri_sort(c(NA,"abc","aab",NA,"ab","aba",NA), na_last=NA),c("aab","ab","aba","abc"))
   expect_equivalent(stri_sort(c(NA,"abc","aab",NA,"ab","aba",NA), na_last=FALSE),c(NA,NA,NA,"aab","ab","aba","abc"))
})


test_that("stri_unique", {

   expect_equivalent(stri_unique(character(0)), character(0))
   expect_equivalent(stri_unique(NA),NA_character_)
   expect_equivalent(stri_unique(c("b", NA, "a", NA)), c("b",NA,"a"))
   expect_equivalent(stri_unique(rep(letters,10)), letters)
   expect_equivalent(stri_unique(rep(letters,each=10)), letters)
   expect_equivalent(stri_unique(rev(LETTERS)), rev(LETTERS))
   expect_equivalent(stri_unique(c("\u0105", stri_trans_nfd("\u0105"))), "\u0105")
   expect_equivalent(stri_unique(c("abc","ab","abc","ab","aba")),c("abc","ab","aba"))
   expect_equivalent(stri_unique(c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107","a\u0105b"),
            opts_collator=list(locale="pl_PL")),
            c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107"))
   expect_equivalent(stri_unique(c("abc", "ABC"),opts_collator=list(strength=1)), c("abc"))
})


test_that("stri_duplicated", {

   expect_equivalent(stri_duplicated(character(0)), logical(0))
   expect_equivalent(stri_duplicated(NA),FALSE)
   expect_equivalent(stri_duplicated(c("b", NA, "a", NA)), c(rep(FALSE,3),TRUE))
   expect_equivalent(stri_duplicated(rep(letters,10)), c(rep(FALSE,length(letters)),rep(TRUE,length(letters)*9)))
   expect_equivalent(stri_duplicated(rep(letters,each=10)), rep(c(F,rep(T,9)),length(letters)))
   expect_equivalent(stri_duplicated(rev(LETTERS)), rep(FALSE,length(letters)))
   expect_equivalent(stri_duplicated(c("\u0105", stri_trans_nfd("\u0105"))), c(F,T))
   expect_equivalent(stri_duplicated(c("abc","ab","abc","ab","aba")),c(F,F,T,T,F))
   expect_equivalent(stri_duplicated(c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107","a\u0105b"),
      opts_collator=list(locale="pl_PL")), c(F,F,F,F,F,T))

   expect_equivalent(stri_duplicated(character(0),TRUE), logical(0))
   expect_equivalent(stri_duplicated(NA,TRUE),FALSE)
   expect_equivalent(stri_duplicated(c("b", NA, "a", NA),TRUE), c(FALSE,TRUE,rep(FALSE,2)))
   expect_equivalent(stri_duplicated(rep(letters,10),TRUE), c(rep(TRUE,length(letters)*9),rep(FALSE,length(letters))))
   expect_equivalent(stri_duplicated(rep(letters,each=10),TRUE), rep(c(rep(T,9),F),length(letters)))
   expect_equivalent(stri_duplicated(rev(LETTERS),TRUE), rep(FALSE,length(letters)))
   expect_equivalent(stri_duplicated(c("\u0105", stri_trans_nfd("\u0105")),TRUE), c(T,F))
   expect_equivalent(stri_duplicated(c("abc","ab","abc","ab","aba"),TRUE),c(T,T,F,F,F))
   expect_equivalent(stri_duplicated(c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107","a\u0105b"),TRUE,
      opts_collator=list(locale="pl_PL")), c(F,F,T,F,F,F))
   expect_equivalent(stri_duplicated(c("abc", "ABC"),FALSE,
      opts_collator=list(strength=1)), c(F,T))
})


test_that("stri_duplicated_any", {

   expect_equivalent(stri_duplicated_any(character(0)), 0)
   expect_equivalent(stri_duplicated_any(NA),0)
   expect_equivalent(stri_duplicated_any(c("b", NA, "a", NA)), 4)
   expect_equivalent(stri_duplicated_any(rep(letters,10)), length(letters)+1)
   expect_equivalent(stri_duplicated_any(rep(letters,each=10)), 2)
   expect_equivalent(stri_duplicated_any(rev(LETTERS)), 0)
   expect_equivalent(stri_duplicated_any(c("\u0105", stri_trans_nfd("\u0105"))), 2)
   expect_equivalent(stri_duplicated_any(c("abc","ab","abc","ab","aba")),3)
   expect_equivalent(stri_duplicated_any(c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107","a\u0105b"),
      opts_collator=list(locale="pl_PL")), 6)

   expect_equivalent(stri_duplicated_any(character(0),TRUE), 0)
   expect_equivalent(stri_duplicated_any(NA,TRUE),0)
   expect_equivalent(stri_duplicated_any(c("b", NA, "a", NA),TRUE), 2)
   expect_equivalent(stri_duplicated_any(rep(letters,10),TRUE), length(letters)*9)
   expect_equivalent(stri_duplicated_any(rep(letters,each=10),TRUE), length(letters)*10-1)
   expect_equivalent(stri_duplicated_any(rev(LETTERS),TRUE), 0)
   expect_equivalent(stri_duplicated_any(c("\u0105", stri_trans_nfd("\u0105")),TRUE), 1)
   expect_equivalent(stri_duplicated_any(c("abc","ab","abc","ab","aba"),TRUE),2)
   expect_equivalent(stri_duplicated_any(c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107","a\u0105b"),TRUE,
      opts_collator=list(locale="pl_PL")), 3)
})
