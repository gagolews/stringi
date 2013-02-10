# TO DO
require("rbenchmark")
require("stringr")

# stri_trim

bmarks <- NULL

test <- paste(stri_dup(" ", 1:1000), "A", stri_dup(" ", 1:1000), sep="")

bmarks <- rbind(bmarks, benchmark(
   trm1 <- str_trim(test),
   trm2 <- stri_trim(test),
   columns=c("test", "relative", "elapsed", "user.self", "sys.self", "replications")
))
print(bmarks)
expect_identical(trm2, trm1)

test_that("stri_trim", {
   expect_that(length(stri_trim(character(0)))==0, is_true())
   expect_that(stri_trim(c("A", "A ", " A", "    A    ")), is_equivalent_to(rep("A", 4)))
})


# stri_pad

bmarks <- NULL

test <- paste(stri_dup(letters, 1:1000), "A", stri_dup(" ", 1:1000), sep="")

bmarks <- rbind(bmarks, benchmark(
   pad1 <- str_pad(test,150),
   pad2 <- stri_pad(test,150),
   columns=c("test", "relative", "elapsed", "user.self", "sys.self", "replications")
))
print(bmarks)
expect_identical(pad1, pad2)