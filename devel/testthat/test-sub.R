require(testthat)
context("test-sub.R")

test_that("stri_sub", {
   s <- c("ala ma \u0105 \u00F1 \u0105 kota i kotek ma alicje oraz dwie gruszeczki oraz gruby czarny pies ma kotka ale nie ma alibaby")
   expect_identical(stri_sub(s), s)
   expect_identical(stri_sub("12", 1, 2), "12")
   expect_identical(stri_sub("12", 2, 2), "2")
   expect_identical(stri_sub("12", 1, 1), "1")
   expect_identical(stri_sub(s, 1:4,3:4), c("ala","la ","a"," "))
   expect_identical(stri_sub(character(0)), character(0))
   expect_identical(stri_sub("test", from=numeric(0), to=1), character(0))
   expect_identical(stri_sub("test", to=numeric(0), from=1), character(0))
   expect_identical(stri_sub("test", length=numeric(0), from=1), character(0))
   expect_identical(stri_sub(c(NA,"ala"), 1:4,length=1), c(NA,"l",NA,""))
   expect_identical(stri_sub(s,c(1,NA),1),c("a",NA))
   expect_identical(stri_sub(s,1:2,NA),c(NA_character_,NA))
   expect_identical(stri_sub(s,2,stri_length(s)-1),stri_sub(s,2,-2))
   expect_identical(stri_sub(s,10,8),"")
   expect_identical(stri_sub(s,1,stri_length(s)+10),s)
   #for = two column matrix
   expect_identical(stri_sub(s,matrix(as.double(1:6),ncol=2)),stri_sub(s,as.double(1:3),as.double(4:6)))
   expect_identical(stri_sub(s,matrix(1:6,ncol=2)),stri_sub(s,1:3,4:6))
   expect_warning(stri_sub(s,matrix(1:6,ncol=2),to=-1))
   expect_identical(stri_sub(s,length=-1:1),c("","","a"))

   expect_identical(stri_sub("\u0105\u0104\u0103\u0102\u0101", 1:5, 1:5),
      stri_extract_all_regex("\u0105\u0104\u0103\u0102\u0101", ".")[[1]])
   expect_identical(stri_sub("\u0105\u0104\u0103\u0102\u0101", 3, 4), "\u0103\u0102")
   expect_identical(stri_sub("\u0105\u0104\u0103\u0102\u0101", 3, -2), "\u0103\u0102")

   expect_identical(stri_sub("\u0105\u0104\u0103\u0102\u0101", 5:1, 5:1),
      rev(stri_extract_all_regex("\u0105\u0104\u0103\u0102\u0101", ".")[[1]]))

   expect_identical(stri_sub("abcde", 1:5, 1:5),
      stri_extract_all_regex("abcde", ".")[[1]])
   expect_identical(stri_sub("abcde", 3, 4), "cd")
   expect_identical(stri_sub("abcde", 3, -2), "cd")

   expect_identical(stri_sub("123",-1),"3")
   expect_identical(stri_sub("123",-3),"123")
   expect_identical(stri_sub("123",3,length=-1:3),c("","","3","3","3"))
   expect_identical(stri_sub("123",2,length=-1:3),c("","","2","23","23"))
   expect_identical(stri_sub("123",1,length=-1:3),c("","","1","12","123"))
   expect_identical(stri_sub("123",-1,length=-1:3),c("","","3","3","3"))
   expect_identical(stri_sub("123",-2,length=-1:3),c("","","2","23","23"))
   expect_identical(stri_sub("123",-3,length=-1:3),c("","","1","12","123"))
})

test_that("stri_sub<-", {
   expect_identical({s <- "test"; stri_sub(s)<-"a"; s}, "a")
   #s is NA_character, but function returns NA_logical
   expect_identical({s <- "test"; stri_sub(s)<-NA_character_; s}, NA_character_)
   #character(0) has priority over NA
   expect_identical({s <- "test"; stri_sub(s)<-character(0); s}, character(0))

   expect_identical({s <- "test"; stri_sub(s, from=numeric(0), to=1) <- "test"; s}, character(0))
   expect_identical({s <- "test"; stri_sub(s, to=numeric(0), from=1) <- "test"; s}, character(0))
   expect_identical({s <- "test"; stri_sub(s, length=numeric(0), from=1) <- "test"; s}, character(0))

   s <- "\U0010FFFFa\u0105";  stri_sub(s,2,2) <- "x";   expect_identical(s, "\U0010FFFFx\u0105")
   s <- "\U0010FFFFa\u0105";  stri_sub(s,3,3) <- "x";   expect_identical(s, "\U0010FFFFax")
   s <- "\U0010FFFFa\u0105";  stri_sub(s,9,9) <- "x";   expect_identical(s, "\U0010FFFFa\u0105x")
   s <- "\U0010FFFFa\u0105";  stri_sub(s,0,0) <- "x";   expect_identical(s, "x\U0010FFFFa\u0105")

   s <- "\U0010FFFFa\u0105";  stri_sub(s,-3,length=1) <- "x";   expect_identical(s, "xa\u0105")
   s <- "\U0010FFFFa\u0105";  stri_sub(s,-2,length=1) <- "x";   expect_identical(s, "\U0010FFFFx\u0105")
   s <- "\U0010FFFFa\u0105";  stri_sub(s,-1,length=1) <- "x";   expect_identical(s, "\U0010FFFFax")

   s <- c("a;b", "c:d"); stri_sub(s, stri_locate_first_fixed(s, ";"), omit_na=TRUE) <- "_"; expect_identical(s, c("a_b", "c:d"))
   s <- c("a;b", "c:d"); stri_sub(s, stri_locate_first_fixed(s, ";"), omit_na=FALSE) <- "_"; expect_identical(s, c("a_b", NA))
   s <- c("a;b", "c:d"); stri_sub(s, stri_locate_first_fixed(s, ";")) <- "_"; expect_identical(s, c("a_b", NA))

   s <- "\u0106a\u0105";  stri_sub(s,0,to=0) <- "x"; expect_identical(s, "x\u0106a\u0105")
   s <- "\u0106a\u0105";  stri_sub(s,1,to=0) <- "x"; expect_identical(s, "x\u0106a\u0105")
   s <- "\u0106a\u0105";  stri_sub(s,2,to=0) <- "x"; expect_identical(s, "\u0106xa\u0105")
   s <- "\u0106a\u0105";  stri_sub(s,3,to=0) <- "x"; expect_identical(s, "\u0106ax\u0105")
   s <- "\u0106a\u0105";  stri_sub(s,3,to=2) <- "x"; expect_identical(s, "\u0106ax\u0105")
   s <- "\u0106a\u0105";  stri_sub(s,4,to=0) <- "x"; expect_identical(s, "\u0106a\u0105x")

   s <- "\u0106a\u0105";  stri_sub(s,0,length=0) <- "x"; expect_identical(s, "x\u0106a\u0105")
   s <- "\u0106a\u0105";  stri_sub(s,1,length=0) <- "x"; expect_identical(s, "x\u0106a\u0105")
   s <- "\u0106a\u0105";  stri_sub(s,2,length=0) <- "x"; expect_identical(s, "\u0106xa\u0105")
   s <- "\u0106a\u0105";  stri_sub(s,3,length=0) <- "x"; expect_identical(s, "\u0106ax\u0105")
   s <- "\u0106a\u0105";  stri_sub(s,4,length=0) <- "x"; expect_identical(s, "\u0106a\u0105x")

   s <- "\u0106a\u0105";  stri_sub(s,-3,to=0) <- "x"; expect_identical(s, "x\u0106a\u0105")
   s <- "\u0106a\u0105";  stri_sub(s,-2,to=0) <- "x"; expect_identical(s, "\u0106xa\u0105")
   s <- "\u0106a\u0105";  stri_sub(s,-1,to=0) <- "x"; expect_identical(s, "\u0106ax\u0105")

   s <- "\u0106a\u0105";  stri_sub(s,-3,length=0) <- "x"; expect_identical(s, "x\u0106a\u0105")
   s <- "\u0106a\u0105";  stri_sub(s,-2,length=0) <- "x"; expect_identical(s, "\u0106xa\u0105")
   s <- "\u0106a\u0105";  stri_sub(s,-1,length=0) <- "x"; expect_identical(s, "\u0106ax\u0105")
})

test_that("stri_sub_issue227", {
   s <- "tißć„óóþ”µć„"
   idx <- 1:8
   expect_equivalent(sapply(idx, function(x) stri_sub(s, from = -c(6, x)))[2,], stri_sub(s, from = -idx))
   expect_equivalent(sapply(idx, function(x) stri_sub(s, from = -c(7, x)))[2,], stri_sub(s, from = -idx))
   expect_equivalent(sapply(idx, function(x) stri_sub(s, from = -c(8, x)))[2,], stri_sub(s, from = -idx))
   expect_equivalent(sapply(idx, function(x) stri_sub(s, from = -c(9, x)))[2,], stri_sub(s, from = -idx))

   try <- 1:20
   for (t in try) expect_equivalent(sapply(idx, function(x) stri_sub(s, from = -c(t, x)))[2,], stri_sub(s, from = -idx))
})

