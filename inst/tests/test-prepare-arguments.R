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



