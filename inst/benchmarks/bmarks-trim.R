# TO DO
require("rbenchmark")
require("stringr")

bmarks <- NULL

test <- paste(stri_dup(" ", 1:1000), "A", stri_dup(" ", 1:1000), sep="")

bmarks <- rbind(bmarks, benchmark(
   trm1 <- str_trim(test),
   trm2 <- stri_trim(test),
   columns=c("test", "relative", "elapsed", "user.self", "sys.self", "replications")
))
print(bmarks)
expect_that(trm2, is_identical_to(trm1))

test_that("stri_trim", {
   expect_that(length(stri_trim(character(0)))==0, is_true())
   expect_that(stri_trim(c("A", "A ", " A", "    A    ")), is_equivalent_to(rep("A", 4)))
})

