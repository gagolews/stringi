require(testthat)

test_that("stri_cmp", {

   # basic tests (ASCII, border-line):
   
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
   
   expect_equivalent(stri_cmp(stri_enc_nfkd('\u0105'), '\u105'), 0L)
})

