require(testthat)


test_that("stri_prepare_arg_string", {

   expect_identical(stringi:::stri_prepare_arg_string(LETTERS),
                    LETTERS)
   expect_identical(stringi:::stri_prepare_arg_string(NA), 
                    NA_character_)
   expect_identical(stringi:::stri_prepare_arg_string(integer(0)), 
                    character(0))
   expect_identical(stringi:::stri_prepare_arg_string(c(TRUE, FALSE, TRUE)), 
                    c("TRUE", "FALSE", "TRUE"))
   expect_identical(stringi:::stri_prepare_arg_string(seq(0,1,0.25)), 
                    as.character(seq(0,1,0.25)))
   expect_identical(stringi:::stri_prepare_arg_string(c(1+1i, 2+2i)), 
                    as.character(c(1+1i, 2+2i)))
   expect_identical(stringi:::stri_prepare_arg_string(as.name("name234")), 
                    "name234")
   expect_identical(stringi:::stri_prepare_arg_string(
                    as.factor(letters[c(1,1,1,2,1,1,1)])), 
                    letters[c(1,1,1,2,1,1,1)])
   
   expect_equivalent(stringi:::stri_prepare_arg_string(
                     matrix(1:10, nrow=2)),
                     matrix(as.character(1:10), nrow=2))
   expect_equivalent(stringi:::stri_prepare_arg_string(
                     matrix(letters[1:10], nrow=2)),
                     matrix(letters[1:10], nrow=2))
   expect_equivalent(stringi:::stri_prepare_arg_string(ts(1:10)),
                     ts(as.character(1:10)))
   
   
   expect_error(stringi:::stri_prepare_arg_string(NULL))
   expect_error(stringi:::stri_prepare_arg_string(list(1, 2, 3)))
   expect_error(stringi:::stri_prepare_arg_string(data.frame(1, 2, 3)))

})

test_that("stri_prepare_arg_integer", {
   expect_equivalent(stringi:::stri_prepare_arg_double(c("1","2")),1:2)
   expect_equivalent(stringi:::stri_prepare_arg_double(character(0)),numeric(0))
   expect_equivalent(stringi:::stri_prepare_arg_double(1:5),1:5)
   expect_equivalent(stringi:::stri_prepare_arg_double(1.5:5),1.5:5)
   expect_equivalent(stringi:::stri_prepare_arg_double(as.factor(1:5)),1:5)
   
   
   expect_error(stringi:::stri_prepare_arg_double(NULL))
   expect_error(stringi:::stri_prepare_arg_double(list(1,2,3)))
   expect_error(stringi:::stri_prepare_arg_double(data.frame(1,2,3)))
})


test_that("stri_prepare_arg_integer", {

   expect_equivalent(stringi:::stri_prepare_arg_integer(1:10), 1:10)
   expect_equivalent(stringi:::stri_prepare_arg_integer(
      seq(0,1,by=0.5)), c(0L,0L,1L))
   expect_equivalent(stringi:::stri_prepare_arg_integer(
      c(TRUE, FALSE)), c(1L, 0L))
   expect_equivalent(stringi:::stri_prepare_arg_integer(
      factor(c("4", "1", "1", "2", "4"))), c(4L, 1L, 1L, 2L, 4L))
   suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_integer(
      c("1", "one", "1.5")), c(1L, NA_integer_, 1L)))
   
   expect_error(stringi:::stri_prepare_arg_integer(NULL))
   expect_error(stringi:::stri_prepare_arg_integer(list(1, 2, 3)))
   expect_error(stringi:::stri_prepare_arg_integer(data.frame(1, 2, 3)))
})

