require(testthat)

test_that("stri_sub", {
	s <- c("ala ma \u0105 \u00F1 ą kota i kotek ma alicje oraz dwie gruszeczki oraz gruby czarny pies ma kotka ale nie ma alibaby")
	expect_identical(stri_sub(s), s)
	expect_identical(stri_sub(s, 1:4,3:4), c("ala","la ","a"," "))
	expect_identical(stri_sub(character(0)), character(0))
	expect_identical(stri_sub(c(NA,"ala"), 1:4,length=1), c(NA,"l",NA,""))
   expect_identical(stri_sub(s,c(1,NA),1),c("a",NA))
	expect_identical(stri_sub(s,1:2,NA),c(NA_character_,NA))
   expect_identical(stri_sub(s,2,stri_length(s)-1),stri_sub(s,2,-2))
   expect_identical(stri_sub(s,10,8),"")
	expect_identical(stri_sub(s,1,stri_length(s)+10),s)

})
