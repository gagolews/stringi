require(testthat)

test_that("stri_wrap", {
	s <- c("ala ma \u0105 \u00F1 kota i kotek ma alicje oraz dwie gruszeczki oraz gruby czarny pies ma kotka ale nie ma alibaby")
	h <- 20
	expect_identical(stri_wrapC2(s, h,"g"), stri_wrapC(s,h,"g"))
	expect_identical(stri_wrapC2(s, h,"g"), stri_wrap(s,h,"g"))
	expect_identical(stri_wrapC2(s, h,"d"), stri_wrapC(s,h,"d"))
	expect_identical(stri_wrapC2(s, h,"d"), stri_wrap(s,h,"d"))
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
	h <- 25
	expect_identical(stri_wrapC2(s, h,"g"), stri_wrapC(s,h,"g"))
	expect_identical(stri_wrapC2(s, h,"g"), stri_wrap(s,h,"g"))
	expect_identical(stri_wrapC2(s, h,"d"), stri_wrapC(s,h,"d"))
	expect_identical(stri_wrapC2(s, h,"d"), stri_wrap(s,h,"d"))
})