require(testthat)


# test_that("stri_pad", { #### Don't depend on stringr
#    expect_warning(stri_pad(letters,1:5))
#    #vectorized over str
#    expect_identical(stri_pad(letters,20),stri_join(stri_dup(" ",19),letters))
#    #vectorized over side
#    #expect_identical(stri_pad("ala",9,c("l","r","b")),
#    #                 c(str_pad("ala",9,"l"),str_pad("ala",9,"r"),str_pad("ala",9,"b")))
#    #vectorized over length
#    expect_identical(stri_pad("ala",6:8), c("   ala","    ala","     ala"))
#    expect_identical(stri_pad(c("abc",NA),5),c("  abc",NA)) 
#    #vectorized over pad
#    expect_identical(stri_pad("a",3,pad=LETTERS[1:3]), c("AAa","BBa","CCa"))
#    
#    test <- paste(stri_dup(letters, 1:2600), "A", stri_dup(" ", 1:2600), sep="")
#    
# #    expect_identical(stri_pad(test,150), str_pad(test,150))
# })
