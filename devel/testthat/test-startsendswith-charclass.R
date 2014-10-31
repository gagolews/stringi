require("testthat")

test_that("stri_startswith_charclass", {
   expect_identical(stri_startswith_charclass("a", NA), NA)
   expect_identical(stri_startswith_charclass(NA, "[a]"), NA)
   expect_identical(stri_startswith_charclass(NA, NA), NA)
   expect_identical(stri_startswith_charclass(c("","a"),"[a]"), c(FALSE, TRUE))
   expect_identical(stri_startswith_charclass(c("ala","", "", "bbb"),c("[a]", "[b]")), c(TRUE, FALSE, FALSE, TRUE))
   expect_identical(stri_startswith_charclass("kot lorem1", character(0)), logical(0))
   expect_identical(stri_startswith_charclass(character(0), "[ipsum]"), logical(0))
   expect_identical(stri_startswith_charclass(character(0), character(0)), logical(0))
   expect_identical(stri_startswith_charclass(c("ab", "cab", "ccccab", "abaabaaaa"), "[a]"), c(T, F, F, T))
   expect_identical(stri_startswith(c("ab", "cab", "ccccab", "abaabaaaa"), charclass="[a]"), c(T, F, F, T))

   expect_equivalent(stri_startswith_charclass("abc", "[a]", c(1,2,3)), c(TRUE, FALSE, FALSE))
   expect_equivalent(stri_startswith_charclass("abc", "[b]", c(1,2,3)), c(FALSE, TRUE, FALSE))
   expect_equivalent(stri_startswith_charclass("abc", "[c]", c(1,2,3)), c(FALSE, FALSE, TRUE))
   expect_equivalent(stri_startswith_charclass("abc", "[a]", c(-3,-2,-1)), c(TRUE, FALSE, FALSE))
   expect_equivalent(stri_startswith_charclass("abc", "[b]", c(-3,-2,-1)), c(FALSE, TRUE, FALSE))
   expect_equivalent(stri_startswith_charclass("abc", "[c]", c(-3,-2,-1)), c(FALSE, FALSE, TRUE))

   expect_equivalent(stri_startswith_charclass("abb", "[a]", c(-1000, 0, 4)), c(TRUE, TRUE, FALSE))
   expect_equivalent(stri_startswith_charclass("ab",  "[b]", c(-1000, 0, 3)), c(FALSE, FALSE, FALSE))
   expect_equivalent(stri_startswith_charclass("a",   "[b]", c(-1000, 0, 2)), c(FALSE, FALSE, FALSE))

   expect_equivalent(stri_startswith_charclass("bababababaab", "[b]", from=c(1,2,3)), c(T,F,T))
   expect_equivalent(stri_startswith_charclass("\u0105\u0104\u0105\u0104\u0105", "[\\u0105]",
      from=c(1,2,3,100,-3)), c(T,F,T,F,T))
   expect_equivalent(stri_startswith_charclass("a", "\\p{Wspace}", c(-1,1,-2,2,0)), c(F,F,F,F,F))

   suppressWarnings(expect_identical(stri_startswith_charclass("","[a]"), FALSE))
})


test_that("stri_endswith_charclass", {
   expect_identical(stri_endswith_charclass("a", NA), NA)
   expect_identical(stri_endswith_charclass(NA, "[a]"), NA)
   expect_identical(stri_endswith_charclass(NA, NA), NA)
   expect_identical(stri_endswith_charclass(c("","a"),"[a]"), c(FALSE, TRUE))
   expect_identical(stri_endswith_charclass(c("ala","", "", "bbb"),c("[a]", "[b]")), c(TRUE, FALSE, FALSE, TRUE))
   expect_identical(stri_endswith_charclass("kot lorem1", character(0)), logical(0))
   expect_identical(stri_endswith_charclass(character(0), "[ipsum]"), logical(0))
   expect_identical(stri_endswith_charclass(character(0), character(0)), logical(0))
   expect_identical(stri_endswith_charclass(c("aba", "cab", "ccccab", "abaabaaaa"), "[a]"), c(T, F, F, T))

   expect_equivalent(stri_endswith_charclass("aaaabababbab", "[b]", to=c(-1,-2,-3)), c(T,F,T))
   expect_equivalent(stri_endswith_charclass("\u0105\u0104\u0105\u0104\u0105", "[\\u0105]",
      to=c(-1,-2,-3,-100,3,1)), c(T,F,T,F,T,T))
   expect_equivalent(stri_endswith_charclass("a", "\\p{Wspace}", c(-1,1,-2,2,0)), c(F,F,F,F,F))
   expect_equivalent(stri_endswith("a", charclass="\\p{Wspace}", c(-1,1,-2,2,0)), c(F,F,F,F,F))

   suppressWarnings(expect_identical(stri_endswith_charclass("","[a]"), FALSE))

   expect_equivalent(stri_endswith_charclass("abc", "[a]", c(1,2,3)), c(TRUE, FALSE, FALSE))
   expect_equivalent(stri_endswith_charclass("abc", "[b]", c(1,2,3)), c(FALSE, TRUE, FALSE))
   expect_equivalent(stri_endswith_charclass("abc", "[c]", c(1,2,3)), c(FALSE, FALSE, TRUE))
   expect_equivalent(stri_endswith_charclass("abc", "[a]", c(-3,-2,-1)), c(TRUE, FALSE, FALSE))
   expect_equivalent(stri_endswith_charclass("abc", "[b]", c(-3,-2,-1)), c(FALSE, TRUE, FALSE))
   expect_equivalent(stri_endswith_charclass("abc", "[c]", c(-3,-2,-1)), c(FALSE, FALSE, TRUE))

   expect_equivalent(stri_endswith_charclass("abc", "[a]", c(-1000, 0, 4)), c(FALSE, FALSE, FALSE))
   expect_equivalent(stri_endswith_charclass("ab",  "[b]", c(-1000, 0, 4)), c(FALSE, FALSE, TRUE))
   expect_equivalent(stri_endswith_charclass("a",   "[b]", c(-1000, 0, 4)), c(FALSE, FALSE, FALSE))
})
