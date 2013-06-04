# TO DO
require("rbenchmark")
require("microbenchmark")
require("stringr")

# stri_trim

bmarks <- NULL

test <- paste(stri_dup(" ", 1:1000), "A", stri_dup(" ", 1:1000), sep="")
flat <- stri_flatten(test)

bmarks <- rbind(bmarks, benchmark(
   trm1 <- stri_trim_both(test),
   trm2 <- stri_trim(test),
   columns=c("test", "relative", "elapsed", "user.self", "sys.self", "replications")
))
print(bmarks)
expect_identical(trm2, trm1)

microbenchmark(str_trim(test),stri_trim_both(test))
microbenchmark(str_trim(flat),stri_trim_both(flat))

# Unit: milliseconds
# expr       min        lq    median        uq      max neval
# str_trim(test) 48.831169 49.350811 49.556970 49.862412 51.97588   100
# stri_trim_both(test)  8.833461  9.002334  9.061019  9.128485 10.92432   100
# > microbenchmark(str_trim(flat),stri_trim_both(flat))
# Unit: milliseconds
# expr      min       lq   median       uq      max neval
# str_trim(flat) 39.45053 39.73859 39.94127 40.16401 43.42621   100
# stri_trim_both(flat) 11.79601 11.92980 11.99634 12.09874 12.37360   100

microbenchmark(str_trim(test,"l"),stri_trim_left(test))
microbenchmark(str_trim(flat,"l"),stri_trim_left(flat))

microbenchmark(str_trim(test,"r"),stri_trim_right(test))
microbenchmark(str_trim(flat,"r"),stri_trim_right(flat))

microbenchmark(str_trim(test),stri_trim_both(test))
microbenchmark(str_trim(flat),stri_trim_both(flat))

microbenchmark(str_trim(test,"left"),stri_trim_left(test))
microbenchmark(str_trim(flat,"left"),stri_trim_left(flat))

microbenchmark(str_trim(test,"right"),stri_trim_right(test)) # v0.1: 10.7ms, v0.2: 9ms :P
microbenchmark(str_trim(flat,"right"),stri_trim_right(flat)) # v0.1: 10ms, v0.2: 3ms :P






# stri_pad
# TODO : move to bmarks-pad.R

bmarks <- NULL

test <- paste(stri_dup(letters, 1:1000), "A", stri_dup(" ", 1:1000), sep="")

bmarks <- rbind(bmarks, benchmark(
   pad1 <- str_pad(test,150),
   pad2 <- stri_pad(test,150),
   columns=c("test", "relative", "elapsed", "user.self", "sys.self", "replications")
))
print(bmarks)
microbenchmark(str_pad(test,150),stri_pad(test,150))
microbenchmark(str_pad(flat,120),stri_pad(flat,120))
microbenchmark(str_pad(flat,1200000),stri_pad(flat,1200000))
