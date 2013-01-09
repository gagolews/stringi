require(testthat)
require(microbenchmark)

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
	s <- rep(s,2)
	h <- 76
	cat(stri_wrapC2(s,h,c("g","d")),sep=paste(c("\n|",rep("-",h-2),"|\n"),collapse=""))
	s <- c("Lorem ipsum dolor sit amet, consectetur adipisicing elit.","Nie ma zatem takiego czlowieka, ktory kocha cierpienie samo w sobie")
	s <- rep(s,3)
	h <- 20
	cat(stri_wrapC2(s,h,c("d","g","g")),sep=paste(c("\n|",rep("-",h-2),"|\n"),collapse=""))
	stri_wrapC2(s,h,"d")
})

strwrap("1 1 1",6)
cat(stri_wrapC2(s,40,"d"))
cat(stri_wrapC2(s,40,"g"))
s <- rep(s,100)
# different stri_wrap versions - greedy 
system.time(stri_wrap(s,25,"g"))
system.time(stri_wrapC(s,25,"g"))
system.time(stri_wrapC2(s,25,"g"))
microbenchmark(stri_wrap(s,25),stri_wrapC(s,25),stri_wrapC2(s,25),times=10)

# different stri_wrap versions - dynamic
system.time(stri_wrap(s,25,"d"))
system.time(stri_wrapC(s,25,"d"))
system.time(stri_wrapC2(s,25,"d"))
microbenchmark(stri_wrap(s,25,"d"),stri_wrapC(s,25,"d"),stri_wrapC2(s,25,"d"),times=10)


# stri_wrap vs strwrap/str_wrap
require(stringr)
system.time(strwrap(s,25))
system.time(str_wrap(s,25))
system.time(stri_wrap(s,25))
system.time(stri_wrapC(s,25))
system.time(stri_wrapC2(s,25))

microbenchmark(strwrap(s,25), str_wrap(s,25),stri_wrap(s,25),stri_wrapC(s,25),stri_wrapC2(s,25),times=10)