require(stringr)
require(rbenchmark)
require(testthat)

test_that("stri_dup", {
   bmarks <- NULL
   N <- c(10, 100, 250)
   for (n in N)
   {
      bmarks <- rbind(bmarks, data.frame(benchmark(
         test2 <- stri_dup(c("AAAAAA", "A"), 1:n),
         test1 <-  str_dup(c("AAAAAA", "A"), 1:n),
         columns=c("test", "relative", "elapsed", "user.self", "sys.self", "replications")
      ), n=n))
      
      expect_that(test2, is_identical_to(test1)) 
   }
   
   for (n in N)
   {
      bmarks <- rbind(bmarks, data.frame(benchmark(
         test3 <- paste(str_dup("X", 1:n), str_dup("Y", n), str_dup("Z", 1:n), sep=""),
         test4a <- paste(stri_dup("X", 1:n), stri_dup("Y", n), stri_dup("Z", 1:n), sep=""),
         test4b <- stri_dup("X", 1:n) %+% stri_dup("Y", n) %+% stri_dup("Z", 1:n),
         columns=c("test", "relative", "elapsed", "user.self", "sys.self", "replications")
      ), n=n))
      
      expect_that(test4a, is_identical_to(test3)) 
      expect_that(test4b, is_identical_to(test3)) 
   }
   
   for (n in N)
   {
      bmarks <- rbind(bmarks, data.frame(benchmark(
         test5 <- str_dup("C", n:1),
         test6 <- stri_dup("C", n:1),
      columns=c("test", "relative", "elapsed", "user.self", "sys.self", "replications")
      ), n=n))
      
      expect_that(test6, is_identical_to(test5)) 
   }
   
   for (n in N)
   {
      bmarks <- rbind(bmarks, data.frame(benchmark(
         test8 <- stri_dup("U", 1:n),
         test7 <- str_dup("U", 1:n),
         columns=c("test", "relative", "elapsed", "user.self", "sys.self", "replications")
      ), n=n))
      
      expect_that(test8, is_identical_to(test7)) 
   }
   print(bmarks)
})


test_that("stri_dup2", {
   expect_that(stri_dup("A", 3), is_identical_to(str_dup("A", 3)))
   expect_that(stri_dup(c("A", "B"), 3), is_identical_to(str_dup(c("A", "B"), 3)))
   expect_that(stri_dup(c("A", "B"), c(2,3)), is_identical_to(str_dup(c("A", "B"), c(2,3))))
   expect_that(stri_dup(c("A", "B"), c(2,3,4)), is_identical_to(c("AA", "BBB", "AAAA")))
   
   
   expect_that(length(stri_dup(character(0), integer(0)))==0, is_true())
   expect_that(length(stri_dup("char", integer(0)))==0, is_true())
   expect_that(length(stri_dup(character(0), 1))==0, is_true())
})

# str_dup("A", -1)  # throws error
# stri_dup("A", -1) # returns NA

# str_dup("A", 0)  # empty
# stri_dup("A", 0) # empty

#  str_dup(c(NA, "A", "AA"), 3) # incorrect behavior
#  stri_dup(c(NA, "A", "AA"), 3)

# str_dup("A", c(NA, 1, 2))  # error
# stri_dup("A", c(NA, 1, 2)) # NA, A, AA
