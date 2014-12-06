require(testthat)
context("test-split-coll.R")

test_that("stri_split_coll", {
   expect_identical(stri_split_coll(character(0)," "),list())
   expect_identical(stri_split_coll("","Z"),list(""))
   expect_identical(stri_split_coll("","Z", omit_empty=TRUE),list(character(0)))
   expect_identical(stri_split_coll("gas","Z", n=0),list(character(0)))
   expect_identical(stri_split_coll(NA,NA),list(NA_character_))
   expect_identical(stri_split_coll(NA,"a"),list(NA_character_))
   expect_identical(stri_split_coll("NA",NA),list(NA_character_))
   expect_identical(stri_split_coll("NA","a",NA),list(NA_character_))
   expect_identical(stri_split_coll(" "," "),list(rep("",2)))
   expect_identical(stri_split_coll("aa","a"),list(rep("",3)))
   expect_identical(stri_split_coll("aa","a",omit_empty=TRUE),list(character(0)))

   s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin
   nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel
   lorem. Etiam pellentesque aliquet tellus. Phasellus pharetra nulla ac
   diam. Quisque semper justo at risus. Donec venenatis, turpis vel
   hendrerit interdum, dui ligula ultricies purus, sed posuere libero dui
   id orci. Nam congue, pede vitae dapibus aliquet, elit magna vulputate
   arcu, vel tempus metus leo non est. Etiam sit amet lectus quis est
   congue mollis. Phasellus congue lacus eget neque. Phasellus ornare,
   ante vitae consectetuer consequat, purus sapien ultricies dolor, et
   mollis pede metus eget nisi. Praesent sodales velit quis augue. Cras
   suscipit, urna at aliquam rhoncus, urna quam viverra nisi, in interdum
   massa nibh nec erat."
   s <- rep(s,3)
   expect_warning(stri_split_coll(s,c("o","a")))
   s <- c("abababab babab abab bbaba","a")
   expect_identical(stri_split_coll(s,"bab"),strsplit(s,"bab"))

   expect_identical(stri_split_coll("sss","s",1:3),list("sss",c("","ss"),c("","","s")))

   # n
   expect_identical(stri_split_coll(";123", ";", n=2), list(c("", "123")))
   expect_identical(stri_split_coll(";123", ";", n=2, omit_empty=TRUE), list("123"))
   expect_identical(stri_split_coll("123;456", ";", n=2), list(c("123", "456")))
   expect_identical(stri_split_coll("123;456;789", ";", n=2), list(c("123", "456;789")))


   # tokens_only
   expect_identical(stri_split_coll("a_b_c_d", "_"), list(c("a", "b", "c", "d")))
   expect_identical(stri_split_coll("a_b_c__d", "_"), list(c("a", "b", "c", "", "d")))
   expect_identical(stri_split_coll("a_b_c__d", "_", omit_empty=TRUE), list(c("a", "b", "c", "d")))
   expect_identical(stri_split_coll("a_b_c__d", "_", n=2, tokens_only=FALSE), list(c("a", "b_c__d")))
   expect_identical(stri_split_coll("a_b_c__d", "_", n=2, tokens_only=TRUE), list(c("a", "b")))
   expect_identical(stri_split_coll("a_b_c__d", "_", n=4, omit_empty=TRUE, tokens_only=TRUE), list(c("a", "b", "c", "d")))
   expect_identical(stri_split_coll("a_b_c__d", "_", n=4, omit_empty=FALSE, tokens_only=TRUE), list(c("a", "b", "c", "")))
   expect_identical(stri_split_coll(c("ab_c", "d_ef_g", "h", ""), "_", n=1, tokens_only=TRUE, omit_empty=TRUE), list("ab", "d", "h", character(0)))
   expect_identical(stri_split_coll(c("ab_c", "d_ef_g", "h", ""), "_", n=2, tokens_only=TRUE, omit_empty=TRUE), list(c("ab", "c"), c("d", "ef"), "h", character(0)))
   expect_identical(stri_split_coll(c("ab_c", "d_ef_g", "h", ""), "_", n=3, tokens_only=TRUE, omit_empty=TRUE), list(c("ab", "c"), c("d", "ef", "g"), "h", character(0)))

   expect_identical(stri_split_coll(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=TRUE, simplify=NA),
      matrix(c("ab", "d", "h", NA, "c", "ef", NA, NA, NA, "g", NA, NA), nrow=4))
   expect_identical(stri_split_coll(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=FALSE, simplify=NA),
      matrix(c("ab", "d", "", "", "c", "ef", "h", NA, NA, "g", NA, NA), nrow=4))
   expect_identical(stri_split_coll(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=NA, simplify=NA),
      matrix(c("ab", "d", NA, NA, "c", "ef", "h", NA, NA, "g", NA, NA), nrow=4))

   expect_identical(stri_split_coll(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=TRUE, simplify=TRUE),
      matrix(c("ab", "d", "h", "", "c", "ef", "", "", "", "g", "", ""), nrow=4))
   expect_identical(stri_split_coll(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=FALSE, simplify=TRUE),
      matrix(c("ab", "d", "", "", "c", "ef", "h", "", "", "g", "", ""), nrow=4))
   expect_identical(stri_split_coll(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=NA, simplify=TRUE),
      matrix(c("ab", "d", NA, NA, "c", "ef", "h", "", "", "g", "", ""), nrow=4))

   expect_identical(stri_split_coll(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=FALSE, simplify=TRUE, n=4),
      matrix(c("ab", "d", "", "", "c", "ef", "h", "", "", "g", "", "", "", "", "", ""), nrow=4))

   expect_identical(stri_split_coll(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=TRUE),
      list(c("ab", "c"), c("d", "ef", "g"), "h", character()))
   expect_identical(stri_split_coll(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=FALSE),
      list(c("ab", "c"), c("d", "ef", "g"), c("", "h"), ""))
   expect_identical(stri_split_coll(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=NA),
      list(c("ab", "c"), c("d", "ef", "g"), c(NA, "h"), NA_character_))
})
