require(testthat)

test_that("stri_cmp", {

   expect_equivalent(stri_cmp(character(0), character(0)), integer(0))
   expect_equivalent(stri_cmp(LETTERS, character(0)), integer(0))
   expect_equivalent(stri_cmp(character(0), LETTERS), integer(0))

   expect_equivalent(stri_cmp(LETTERS, LETTERS), rep(0L,  length(LETTERS)))
   expect_equivalent(stri_cmp(letters, LETTERS), rep(-1L, length(LETTERS)))
   expect_equivalent(stri_cmp(LETTERS, letters), rep(+1L, length(LETTERS)))
   expect_equivalent(stri_cmp(c(NA, 'a', 'b'), 'a'), c(NA_integer_, 0L, 1L))

   expect_equivalent(stri_cmp("hladny", "chladny", stri_opts_collator(locale="pl_PL")),  1L)
   expect_equivalent(stri_cmp("hladny", "chladny", stri_opts_collator(locale="sk_SK")), -1L)
   expect_equivalent(stri_cmp(letters, LETTERS, stri_opts_collator(strength=2)), rep(0L, length(LETTERS)))

   expect_equivalent(stri_cmp("dupa100", "dupa2"), -1)
   expect_equivalent(stri_cmp("dupa100", "dupa1000"), -1)
   expect_equivalent(stri_cmp("dupa10000", "dupa1000"), 1)
   expect_equivalent(stri_cmp("dupa100", "dupa2", stri_opts_collator(numeric=TRUE)), 1)
   expect_equivalent(stri_cmp("above mentioned", "above-mentioned"), -1)
   expect_equivalent(stri_cmp("above mentioned", "above-mentioned", stri_opts_collator(alternate_shifted=TRUE)), 0)

   expect_equivalent(stri_cmp(stri_enc_nfkd('\u0105'), '\u105'), 0L)

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


test_that("stri_cmp_lt/gt/le/ge_bytewise", {

   expect_equivalent(stri_cmp_lt(character(0), character(0), opts_collator=NA), logical(0))
   expect_equivalent(stri_cmp_lt(LETTERS, character(0), opts_collator=NA), logical(0))
   expect_equivalent(stri_cmp_lt(character(0), LETTERS, opts_collator=NA), logical(0))

   expect_equivalent(stri_cmp_lt(LETTERS, LETTERS, opts_collator=NA), rep(FALSE,  length(LETTERS)))
   expect_equivalent(stri_cmp_le(LETTERS, LETTERS, opts_collator=NA), rep(TRUE,  length(LETTERS)))
   expect_equivalent(stri_cmp_le(LETTERS, letters, opts_collator=NA), rep(TRUE,  length(LETTERS)))
   expect_equivalent(stri_cmp_gt(LETTERS, letters, opts_collator=NA), rep(FALSE,  length(LETTERS)))
   expect_equivalent(stri_cmp_le(c(NA, 'a', 'b'), 'a', opts_collator=NA), c(NA, TRUE, FALSE))
   expect_equivalent(stri_cmp_le("dupa", "pupa", opts_collator=NA), TRUE)
   expect_equivalent(stri_cmp_lt("dupa", "pupa", opts_collator=NA), TRUE)
   expect_equivalent(stri_cmp_ge("dupa", "pupa", opts_collator=NA), FALSE)
   expect_equivalent(stri_cmp_gt("dupa", "pupa", opts_collator=NA), FALSE)
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
   expect_equivalent(stri_cmp_eq("above mentioned", "above-mentioned",
      stri_opts_collator(alternate_shifted=TRUE)), TRUE)

   expect_equivalent(stri_cmp_eq(stri_enc_nfkd('\u0105'), '\u105'), TRUE)

})



test_that("stri_cmp_eq_bytewise", {

   expect_equivalent(stri_cmp_eq(character(0), character(0), opts_collator=NA), logical(0))
   expect_equivalent(stri_cmp_eq(LETTERS, character(0), opts_collator=NA), logical(0))
   expect_equivalent(stri_cmp_eq(character(0), LETTERS, opts_collator=NA), logical(0))

   expect_equivalent(stri_cmp_eq(LETTERS, LETTERS, opts_collator=NA),  rep(TRUE,  length(LETTERS)))
   expect_equivalent(stri_cmp_neq(LETTERS, LETTERS, opts_collator=NA), rep(FALSE,  length(LETTERS)))
   expect_equivalent(stri_cmp_eq(LETTERS, letters, opts_collator=NA),  rep(FALSE,  length(LETTERS)))
   expect_equivalent(stri_cmp_neq(LETTERS, letters, opts_collator=NA), rep(TRUE,  length(LETTERS)))
   expect_equivalent(stri_cmp_eq(c(NA, 'a', 'b'), 'a', opts_collator=NA), c(NA, TRUE, FALSE))
   expect_equivalent(stri_cmp_neq(c(NA, 'a', 'b'), 'a', opts_collator=NA), !c(NA, TRUE, FALSE))

   expect_equivalent(stri_cmp_eq("dupa100", "dupa2", opts_collator=NA), FALSE)
   expect_equivalent(stri_cmp_eq("dupa100", "dupa1000", opts_collator=NA), FALSE)
   expect_equivalent(stri_cmp_eq("dupa10000", "dupa1000", opts_collator=NA), FALSE)
   expect_equivalent(stri_cmp_eq("above mentioned", "above-mentioned", opts_collator=NA), FALSE)

   expect_equivalent(stri_cmp_eq(stri_enc_nfkd('\u0105'), '\u105', opts_collator=NA), FALSE)

})


test_that("stri_cmp_codepoints", {

   expect_equivalent(stri_cmp(character(0), character(0), opts_collator=NA), integer(0))
   expect_equivalent(stri_cmp(LETTERS, character(0), opts_collator=NA), integer(0))
   expect_equivalent(stri_cmp(character(0), LETTERS, opts_collator=NA), integer(0))

   expect_equivalent(stri_cmp(LETTERS, LETTERS, opts_collator=NA), rep(0L,  length(LETTERS)))
   expect_equivalent(stri_cmp(letters, LETTERS, opts_collator=NA), rep(+1L, length(LETTERS)))
   expect_equivalent(stri_cmp(LETTERS, letters, opts_collator=NA), rep(-1L, length(LETTERS)))
   expect_equivalent(stri_cmp(c(NA, 'a', 'b'), 'a', opts_collator=NA), c(NA_integer_, 0L, 1L))

   expect_equivalent(stri_cmp("dupa100", "dupa2", opts_collator=NA), -1)
   expect_equivalent(stri_cmp("dupa100", "dupa1000", opts_collator=NA), -1)
   expect_equivalent(stri_cmp("dupa10000", "dupa1000", opts_collator=NA), 1)
   

   expect_equivalent(stri_cmp(stri_enc_nfkd('\u0105'), '\u105', opts_collator=NA), -1L)

})



test_that("stri_order", {

   expect_equivalent(stri_order(character(0)), integer(0))
   expect_equivalent(stri_order(LETTERS), 1:length(LETTERS))
   expect_equivalent(stri_order(rev(LETTERS)), length(LETTERS):1)
   expect_equivalent(stri_order(rev(LETTERS)), rev(stri_order(LETTERS)))
   expect_equivalent(stri_order(LETTERS, decreasing=TRUE), length(LETTERS):1)

   expect_equivalent(stri_order(c("hladny", "chladny"), F, stri_opts_collator(locale="pl_PL")),2:1)
   expect_equivalent(stri_order(c("hladny", "chladny"), F, stri_opts_collator(locale="sk_SK")),1:2)

   expect_equivalent(stri_order(c('c', NA, 'a', NA, 'b', NA)), c(3, 5, 1, 2, 4, 6))
})


test_that("stri_order [codepoints]", {

   expect_equivalent(stri_order(character(0), opts_collator=NA), integer(0))
   expect_equivalent(stri_order(LETTERS, opts_collator=NA), 1:length(LETTERS))
   expect_equivalent(stri_order(rev(LETTERS), opts_collator=NA), length(LETTERS):1)
   expect_equivalent(stri_order(LETTERS, decreasing=TRUE, opts_collator=NA), length(LETTERS):1)


   expect_equivalent(stri_order(c('c', NA, 'a', NA, 'b', NA), opts_collator=NA), c(3, 5, 1, 2, 4, 6))
})

test_that("stri_sort", {

   expect_equivalent(stri_sort(character(0)), character(0))
   expect_equivalent(stri_sort(NA),NA)
   expect_equivalent(stri_sort(LETTERS[sample(length(LETTERS))]), LETTERS)
   expect_equivalent(stri_sort(rev(LETTERS)), LETTERS)
   expect_equivalent(stri_sort(rev(letters)), letters)
   expect_equivalent(stri_sort(c("abc","aab","baa","ab","aba")),c("aab","ab","aba","abc","baa"))
   expect_equivalent(stri_sort(c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107"),
      opts_collator=list(locale="pl_PL")),
      c("aab", "a\u0105b", "abc", "ab\u0107", "\u0105bc"))
})
