require(stringr)
require(rbenchmark)
require(testthat)

test_that("stri_flatten", {
   bmarks <- NULL
   N <- c(1000,5000,100000)
   for (n in N)
   {
      x <- rep("A", n)
      bmarks <- rbind(bmarks, data.frame(benchmark(
         test2 <- stri_flatten(x),
         test1 <- paste(x, collapse="", sep=""),
         columns=c("test", "relative", "elapsed", "user.self", "sys.self", "replications")
      ), n=n))
      
      expect_that(test2, is_identical_to(test1)) 
   }
   print(bmarks)
})



test_that("stri_flatten", {
   bmarks <- NULL
   N <- c(1000,2000)
   for (n in N)
   {
      x <- stri_dup("A", 1:n)
      bmarks <- rbind(bmarks, data.frame(benchmark(
         test2 <- stri_flatten(x),
         test1 <- paste(x, collapse="", sep=""),
         columns=c("test", "relative", "elapsed", "user.self", "sys.self", "replications")
      ), n=n))
      
      expect_that(test2, is_identical_to(test1)) 
   }
   print(bmarks)
})
