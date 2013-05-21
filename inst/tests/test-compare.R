require(testthat)

test_that("stri_cmp", {
   
   expect_equivalent(stri_cmp(character(0), character(0)), integer(0))
   expect_equivalent(stri_cmp(LETTERS, character(0)), integer(0))
   expect_equivalent(stri_cmp(character(0), LETTERS), integer(0))
   
   expect_equivalent(stri_cmp(LETTERS, LETTERS), rep(0L,  length(LETTERS)))
   expect_equivalent(stri_cmp(letters, LETTERS), rep(-1L, length(LETTERS)))
   expect_equivalent(stri_cmp(LETTERS, letters), rep(+1L, length(LETTERS)))
   expect_equivalent(stri_cmp(c(NA, 'a', 'b'), 'a'), c(NA_integer_, 0L, 1L))
   
   expect_equivalent(stri_cmp("hladny", "chladny", stri_collator_genopts(locale="pl_PL")),  1L)
   expect_equivalent(stri_cmp("hladny", "chladny", stri_collator_genopts(locale="sk_SK")), -1L)
   expect_equivalent(stri_cmp(letters, LETTERS, stri_collator_genopts(strength=2)), rep(0L, length(LETTERS)))
   
   expect_equivalent(stri_cmp("dupa100", "dupa2"), -1)
   expect_equivalent(stri_cmp("dupa100", "dupa2", stri_collator_genopts(numeric=TRUE)), 1)
   expect_equivalent(stri_cmp("above mentioned", "above-mentioned"), -1)
   expect_equivalent(stri_cmp("above mentioned", "above-mentioned", stri_collator_genopts(alternate_shifted=TRUE)), 0)
   
   expect_equivalent(stri_cmp(stri_enc_nfkd('\u0105'), '\u105'), 0L)
   
})


test_that("stri_cmp_codepoints", {
   
   expect_equivalent(stri_cmp(character(0), character(0), collator_opts=NA), integer(0))
   expect_equivalent(stri_cmp(LETTERS, character(0), collator_opts=NA), integer(0))
   expect_equivalent(stri_cmp(character(0), LETTERS, collator_opts=NA), integer(0))
   
   expect_equivalent(stri_cmp(LETTERS, LETTERS, collator_opts=NA), rep(0L,  length(LETTERS)))
   expect_equivalent(stri_cmp(letters, LETTERS, collator_opts=NA), rep(+1L, length(LETTERS)))
   expect_equivalent(stri_cmp(LETTERS, letters, collator_opts=NA), rep(-1L, length(LETTERS)))
   expect_equivalent(stri_cmp(c(NA, 'a', 'b'), 'a', collator_opts=NA), c(NA_integer_, 0L, 1L))
   
   expect_equivalent(stri_cmp("dupa100", "dupa2", collator_opts=NA), -1)
   
   expect_equivalent(stri_cmp(stri_enc_nfkd('\u0105'), '\u105', collator_opts=NA), -1L)
   
})



test_that("stri_order", {
   
   expect_equivalent(stri_order(character(0)), integer(0))
   expect_equivalent(stri_order(LETTERS), 1:length(LETTERS))
   expect_equivalent(stri_order(rev(LETTERS)), length(LETTERS):1)
   expect_equivalent(stri_order(LETTERS, decreasing=TRUE), length(LETTERS):1)

   
   expect_equivalent(stri_order(c('c', NA, 'a', NA, 'b', NA)), c(3, 5, 1, 2, 4, 6)) 
})


test_that("stri_order [codepoints]", {
   
   expect_equivalent(stri_order(character(0), collator_opts=NA), integer(0))
   expect_equivalent(stri_order(LETTERS, collator_opts=NA), 1:length(LETTERS))
   expect_equivalent(stri_order(rev(LETTERS), collator_opts=NA), length(LETTERS):1)
   expect_equivalent(stri_order(LETTERS, decreasing=TRUE, collator_opts=NA), length(LETTERS):1)
   
   
   expect_equivalent(stri_order(c('c', NA, 'a', NA, 'b', NA), collator_opts=NA), c(3, 5, 1, 2, 4, 6)) 
})
