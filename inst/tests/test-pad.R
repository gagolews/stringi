require(testthat)
require(stringr)


test_that("stri_pad", {
   expect_warning(stri_pad(letters,1:5))
   #vectorized over str
   expect_identical(stri_pad(letters,20),str_pad(letters,20))
   #vectorized over side
   expect_identical(stri_pad("ala",9,c("l","r","b")),
                    c(str_pad("ala",9,"l"),str_pad("ala",9,"r"),str_pad("ala",9,"b")))
   #vectorized over width
   expect_identical(stri_pad("ala",6:8),
                    c(str_pad("ala",6),str_pad("ala",7),str_pad("ala",8)))
   expect_identical(stri_pad(c("abc",NA),5),c("  abc",NA)) 
   #vectorized over pad
   expect_identical(stri_pad("a",3,pad=LETTERS[1:3]),
                    c(str_pad("a",3,pad="A"),str_pad("a",3,pad="B"),str_pad("a",3,pad="C")))
   
   test <- paste(stri_dup(letters, 1:2600), "A", stri_dup(" ", 1:2600), sep="")
   
   expect_identical(stri_pad(test,150), str_pad(test,150))
})
