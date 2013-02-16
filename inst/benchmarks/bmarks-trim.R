# TO DO
require("rbenchmark")
require("microbenchmark")
require("stringr")

# stri_trim

bmarks <- NULL

test <- paste(stri_dup(" ", 1:1000), "A", stri_dup(" ", 1:1000), sep="")
flat <- stri_flatten(test)

bmarks <- rbind(bmarks, benchmark(
   trm1 <- str_trim(test),
   trm2 <- stri_trim(test),
   columns=c("test", "relative", "elapsed", "user.self", "sys.self", "replications")
))
print(bmarks)
expect_identical(trm2, trm1)

microbenchmark(str_trim(test),stri_trim(test))
microbenchmark(str_trim(flat),stri_trim(flat))

microbenchmark(str_trim(test,"l"),stri_ltrim(test))
microbenchmark(str_trim(flat,"l"),stri_ltrim(flat))

microbenchmark(str_trim(test,"r"),stri_rtrim(test))
microbenchmark(str_trim(flat,"r"),stri_rtrim(flat))

# stri_trim_all

microbenchmark(stri_trim_all(test),str_trim(test),times=10)

microbenchmark(stri_trim_all(flat),str_trim(flat),times=10)
f <- rep(flat, 25)
microbenchmark(stri_trim_all(f),str_trim(f),times=10)

# stri_pad

bmarks <- NULL

test <- paste(stri_dup(letters, 1:1000), "A", stri_dup(" ", 1:1000), sep="")

bmarks <- rbind(bmarks, benchmark(
   pad1 <- str_pad(test,150),
   pad2 <- stri_pad(test,150),
   columns=c("test", "relative", "elapsed", "user.self", "sys.self", "replications")
))
print(bmarks)
microbenchmark(str_pad(test,150),stri_pad(test,150))
