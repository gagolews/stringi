require(testthat)

test_that("stri_split", {
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
   expect_warning(stri_split(s,c("o","a")))
   expect_identical(stri_split(s), strsplit(s,'\n',TRUE))
   expect_identical(stri_split(s,' '),strsplit(s,' ',TRUE))
   expect_identical(stri_split(s,'a'),strsplit(s,'a',TRUE))
   expect_identical(stri_split(s,"co"),strsplit(s,"co",TRUE))
   expect_identical(stri_split(s,"rem"),strsplit(s,"rem",TRUE))
   s <- c("abababab babab abab bbaba","a")
   expect_identical(stri_split(s,"bab"),strsplit(s,"bab",TRUE))
})