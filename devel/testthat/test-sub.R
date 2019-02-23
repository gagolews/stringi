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

   s <- c("a;b", "c:d"); stri_sub(s, stri_locate_first_fixed(s, ";"), omit_na=TRUE) <- c("_", NA); expect_identical(s, c("a_b", NA))
   s <- c("a;b", "c:d"); stri_sub(s, stri_locate_first_fixed(s, ";"), omit_na=FALSE) <- c("_", NA); expect_identical(s, c("a_b", NA))
   s <- c("a;b", "c:d"); stri_sub(s, stri_locate_first_fixed(s, ";")) <- c("_", NA); expect_identical(s, c("a_b", NA))

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

   expect_identical(stri_sub_replace("abc", omit_na=TRUE, value=c("def", "", NA)), c("def", "", NA))
   expect_identical(stri_sub_replace("abc", omit_na=FALSE, value=c("def", "", NA)), c("def", "", NA))

   expect_identical(stri_sub_replace("abcdef", c(5,3,1), length=1, value=c("E","C","A")), c("abcdEf", "abCdef", "Abcdef"))

   x <- c("123 45 htf 789754754745", "abc", "667", "", NA)
   expect_identical(stri_sub_replace(x, stri_locate_first_regex(x, "[0-9]+"), omit_na=TRUE, value="***"),
    stri_replace_first_regex(x, "[0-9]+", "***"))
   expect_identical(stri_sub_replace(x, stri_locate_last_regex(x, "[0-9]+"), omit_na=TRUE, value="***"),
    stri_replace_last_regex(x, "[0-9]+", "***"))

   expect_identical(stri_sub_replace(x, stri_locate_first_regex(x, "[0-9]+"), omit_na=TRUE, value=LETTERS[seq_len(length(x))]),
    stri_replace_first_regex(x, "[0-9]+", LETTERS[seq_len(length(x))]))
   expect_identical(stri_sub_replace(x, stri_locate_last_regex(x, "[0-9]+"), omit_na=TRUE, value=LETTERS[seq_len(length(x))]),
    stri_replace_last_regex(x, "[0-9]+", LETTERS[seq_len(length(x))]))
})




test_that("stri_sub_issue227", {
   expect_equivalent(stri_sub("as", from=-c(1,2,1)), c("s", "as", "s"))
   expect_equivalent(stri_sub("as", from=-c(1,2,3,2,1)), c("s", "as", "as", "as", "s"))
   expect_equivalent(stri_sub("ąś", from=-c(1,2,1)), c("ś", "ąś", "ś"))
   expect_equivalent(stri_sub("ąś", from=-c(1,2,3,2,1)), c("ś", "ąś", "ąś", "ąś", "ś"))

   expect_identical(stri_sub("as", from=c(4,3,2)), c("", "", "s"))
   expect_identical(stri_sub("ąś", from=c(4,3,2)), c("", "", "ś"))

   expect_equivalent(stri_sub("as", from=-c(1,2,3,4,3,4,3,2,1)), c("s", "as", "as", "as", "as", "as", "as", "as", "s"))
   expect_equivalent(stri_sub("ąś", from=-c(1,2,3,4,3,4,3,2,1)), c("ś", "ąś", "ąś", "ąś", "ąś", "ąś", "ąś", "ąś", "ś"))

   expect_equivalent({x <- "as"; stri_sub(x, from=-c(1,2,3,2,1)) <- "*"; x}, c("a*", "*", "*", "*", "a*"))
   expect_equivalent({x <- "ąś"; stri_sub(x, from=-c(1,2,3,2,1)) <- "*"; x}, c("ą*", "*", "*", "*", "ą*"))

   stri_sub("ąś", to=-c(1,2,4,2,1))

   s <- "tißć„óóþ”µć„"
   idx <- 1:8
   expect_equivalent(sapply(idx, function(x) stri_sub(s, from = -c(6, x)))[2,], stri_sub(s, from = -idx))
   expect_equivalent(sapply(idx, function(x) stri_sub(s, from = -c(7, x)))[2,], stri_sub(s, from = -idx))
   expect_equivalent(sapply(idx, function(x) stri_sub(s, from = -c(8, x)))[2,], stri_sub(s, from = -idx))
   expect_equivalent(sapply(idx, function(x) stri_sub(s, from = -c(9, x)))[2,], stri_sub(s, from = -idx))

   try <- 1:20
   for (t in try) expect_equivalent(sapply(idx, function(x) stri_sub(s, from = -c(t, x)))[2,], stri_sub(s, from = -idx))
})



test_that("stri_sub_all", {
   expect_identical(stri_sub_all(character(0)), list())
   expect_identical(stri_sub_all("abc"), list("abc"))
   expect_identical(stri_sub_all(c("abc", NA, "def", "")), as.list(c("abc", NA, "def", "")))

   expect_identical(stri_sub_all("abc", list(1:3)), list(c("abc", "bc", "c")))
   expect_identical(stri_sub_all("abc", list(3:1)), list(rev(c("abc", "bc", "c"))))
   expect_identical(stri_sub_all("abc", list(1:3), list(1:3)), list(c("a", "b", "c")))
   expect_identical(stri_sub_all("abc", list(1:3), 3), list(c("abc", "bc", "c")))
   expect_identical(stri_sub_all("abc", 1, rep(3,3)), list(c("abc", "abc", "abc")))
   expect_identical(stri_sub_all("abc", 1, 3), list(c("abc")))
   expect_warning(stri_sub_all("abc", 1:2, 1:3))
   expect_identical(suppressWarnings(stri_sub_all("abc", 1:2, 1:3)), list(c("a", "b", "abc")))
   expect_identical(stri_sub_all("abc", 1, 1:3), list(c("a", "ab", "abc")))
   expect_identical(stri_sub_all("abc", list(1:3), length=list(3:1)), list(c("abc", "bc", "c")))

   x <- c("123 45 htf 789754754745", "abc", "667", "", NA)
   from <- stri_locate_all_regex(x, "[0-9]+")
   expect_identical(stri_sub_all(x, from), stri_extract_all_regex(x, "[0-9]+"))
   expect_identical(stri_sub_all(x, lapply(from, function(from) from[,1]), lapply(from, function(from) from[,2])),
      stri_extract_all_regex(x, "[0-9]+"))
   expect_identical(stri_sub_all(x, lapply(from, function(from) from[,1]),
                                  length=lapply(from, function(from) from[,2]-from[,1]+1)),
     stri_extract_all_regex(x, "[0-9]+"))

   expect_identical(stri_sub_all(x, stri_locate_all_regex(x, "[0-9]+", omit_no_match=TRUE)),
                    stri_extract_all_regex(x, "[0-9]+", omit_no_match=TRUE))

   expect_error(stri_sub_all("abc", list(1, 2, mean)))
})


test_that("stri_sub_all<-", {
   expect_identical(stri_sub_replace_all(character(0), value=LETTERS), character(0))
   expect_identical(stri_sub_replace_all(LETTERS, value=list()), character(0))
   expect_identical(stri_sub_replace_all(LETTERS, from=list(integer(0)), value=""), LETTERS)
   expect_identical(stri_sub_replace_all(LETTERS, to=list(integer(0)), value=""), LETTERS)
   expect_error(stri_sub_replace_all("abc", list(1, 2, mean), value="a"))
   expect_warning(stri_sub_replace_all(LETTERS, value=list(NULL)))
   expect_identical(suppressWarnings(stri_sub_replace_all(LETTERS, value=list(NULL))), rep(NA_character_, length(LETTERS)))
   expect_warning(stri_sub_replace_all("abc", from=1:3, to=1:3, value=1:2))
   expect_error(stri_sub_replace_all("abc", from=1:3, to=-1, value=1))
   expect_error(stri_sub_replace_all("abc", from=1, to=1:2, value=1))
   expect_error(stri_sub_replace_all("abc", from=c(1,3,2), length=1, value=1))
   expect_identical(stri_sub_replace_all(LETTERS, value=NA), rep(NA_character_, length(LETTERS)))

   expect_identical(stri_sub_replace_all("a", from=NA, value="", omit_na=TRUE), "a")
   expect_identical(stri_sub_replace_all("a", from=NA, value="", omit_na=FALSE), NA_character_)
   expect_identical(stri_sub_replace_all("a", to=NA, value="", omit_na=TRUE), "a")
   expect_identical(stri_sub_replace_all("a", to=NA, value="", omit_na=FALSE), NA_character_)

   expect_identical(stri_sub_replace_all("\U0010FFFFa\u0105b", 0, length=0, value="*"), "*\U0010FFFFa\u0105b")
   expect_identical(stri_sub_replace_all("\U0010FFFFa\u0105b", 1, length=0, value="*"), "*\U0010FFFFa\u0105b")
   expect_identical(stri_sub_replace_all("\U0010FFFFa\u0105b", 1, length=1, value="*"), "*a\u0105b")
   expect_identical(stri_sub_replace_all("\U0010FFFFa\u0105b", 2, length=0, value="*"), "\U0010FFFF*a\u0105b")
   expect_identical(stri_sub_replace_all("\U0010FFFFa\u0105b", 2, length=1, value="*"), "\U0010FFFF*\u0105b")
   expect_identical(stri_sub_replace_all("\U0010FFFFa\u0105b", 3, length=0, value="*"), "\U0010FFFFa*\u0105b")
   expect_identical(stri_sub_replace_all("\U0010FFFFa\u0105b", 3, length=1, value="*"), "\U0010FFFFa*b")
   expect_identical(stri_sub_replace_all("\U0010FFFFa\u0105b", 4, length=0, value="*"), "\U0010FFFFa\u0105*b")
   expect_identical(stri_sub_replace_all("\U0010FFFFa\u0105b", 4, length=1, value="*"), "\U0010FFFFa\u0105*")
   expect_identical(stri_sub_replace_all("\U0010FFFFa\u0105b", 5, length=0, value="*"), "\U0010FFFFa\u0105b*")
   expect_identical(stri_sub_replace_all("\U0010FFFFa\u0105b", 500, length=650, value="*"), "\U0010FFFFa\u0105b*")

   expect_identical(stri_sub_replace_all(
         "\U0010FFFFa\u0105b",
         from  =list(1,1,2,2,3,3,4,4,5),
         length=list(0,1,0,1,0,1,0,1,0),
         value="*"),
      stri_sub_replace(
         "\U0010FFFFa\u0105b",
         from  =c(1,1,2,2,3,3,4,4,5),
         length=c(0,1,0,1,0,1,0,1,0),
         value="*")
   )
   expect_identical(stri_sub_replace_all(
      "\U0010FFFFa\u0105b",
      from  =list(1,1,2,2,3,3,4,4,5),
      length=list(0,1,0,1,0,1,0,1,0),
      value="\U0010FFFFa"),
      stri_sub_replace(
         "\U0010FFFFa\u0105b",
         from  =c(1,1,2,2,3,3,4,4,5),
         length=c(0,1,0,1,0,1,0,1,0),
         value="\U0010FFFFa")
   )
   expect_identical(stri_sub_replace_all(
      "\U0010FFFFa\u0105b",
      from  =list(1,1,2,2,3,3,4,4,5),
      length=list(0,1,0,1,0,1,0,1,0),
      value="\u0105\U0010FFFFauiyughdfugie54yughk5re"),
      stri_sub_replace(
         "\U0010FFFFa\u0105b",
         from  =c(1,1,2,2,3,3,4,4,5),
         length=c(0,1,0,1,0,1,0,1,0),
         value="\u0105\U0010FFFFauiyughdfugie54yughk5re")
   )
   expect_identical(stri_sub_replace_all(
      "\U0010FFFFa\u0105b",
      from   =list(-5,-4,-4,-3,-3,-2,-2,-1,-1),
      length =list(0,1,0,1,0,1,0,1,0),
      value="\U0010FFFFah5ru5n\U0010FFFFa\U0010FFFFa\U0010FFFFa"),
      stri_sub_replace(
         "\U0010FFFFa\u0105b",
         from  =c(-5,-4,-4,-3,-3,-2,-2,-1,-1),
         length=c(0,1,0,1,0,1,0,1,0),
         value="\U0010FFFFah5ru5n\U0010FFFFa\U0010FFFFa\U0010FFFFa")
   )

   expect_identical(
      stri_sub_replace_all("\U0010FFFFa\u0105b\u0108", c(2, 4), length=1, value=""),
      "\U0010FFFF\u0105\u0108")

   expect_identical(
      stri_sub_replace_all("\U0010FFFFa\u0105b\u0108", c(2, 4), length=1, value=list("", "\U0010FFFF", "\u0105")),
      c("\U0010FFFF\u0105\u0108","\U0010FFFF\U0010FFFF\u0105\U0010FFFF\u0108","\U0010FFFF\u0105\u0105\u0105\u0108"))


   expect_identical(
      stri_sub_replace_all("\U0010FFFFa\u0105b\u0108", c(2, 4), length=1, value=list(c("", "\U0010FFFF"), c("\u0105", "gasgas"))),
      c("\U0010FFFF\u0105\U0010FFFF\u0108","\U0010FFFF\u0105\u0105gasgas\u0108"))

   expect_warning(stri_sub_replace_all("abc", 1, 1, value=list(c("", ""))))


   x <- c("123 45 htf 789754754745", "abc", "667", "", NA)
   stri_sub_replace_all(x, stri_locate_all_regex(x, "[0-9]+"), omit_na=TRUE, value="***")
   stri_sub_replace_all(x, stri_locate_all_regex(x, "[0-9]+"), omit_na=TRUE,
                        value=list("1", "whatever", "3", "whatever", "whatever"))
   stri_sub_replace_all(x, stri_locate_all_regex(x, "[0-9]+"), omit_na=TRUE,
                        value=list(c("1", "2", "3"), "whatever", "4", "whatever", "whatever"))

   x <- c("a b c")
   stri_sub_all(x, c(1, 3, 5), c(1, 3, 5)) <- c("A", "B", "C")
   expect_identical(x, "A B C")

})


