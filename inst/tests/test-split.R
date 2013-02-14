require(testthat)
require(stringr)

test_that("stri_split", {
   expect_identical(stri_split(character(0)," "),list())   
   expect_identical(stri_split(NA,"a",TRUE),list(NA_character_))
   expect_identical(stri_split("NA",NA,TRUE),list(NA_character_))
   expect_identical(stri_split("NA","a",NA),list(NA_character_))
   expect_identical(stri_split(" "," "),list(rep("",2)))
   expect_identical(stri_split("aa","a"),list(rep("",3)))
   
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
   expect_identical(stri_split(s), str_split(s,'\n'))
   expect_identical(stri_split(s,' '),str_split(s,' '))
   expect_identical(stri_split(s,'a'),str_split(s,'a'))
   expect_identical(stri_split(s,"co"),str_split(s,"co"))
   expect_identical(stri_split(s,"rem"),str_split(s,"rem"))
   s <- c("abababab babab abab bbaba","a")
   expect_identical(stri_split(s,"bab"),strsplit(s,"bab"))
   expect_identical(stri_split("lalal","l"),str_split("lalal","l"))
   
})

