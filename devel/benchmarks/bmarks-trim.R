require("rbenchmark")
require("microbenchmark")
require("stringr")

bmarks <- NULL

test <- paste(stri_dup(" ", 1:1000), "A", stri_dup(" ", 1:1000), sep="")
flat <- stri_flatten(test)

microbenchmark(str_trim(test),stri_trim_both(test)) 
microbenchmark(str_trim(flat),stri_trim_both(flat)) 

microbenchmark(str_trim(test,"left"),stri_trim_left(test))
microbenchmark(str_trim(flat,"left"),stri_trim_left(flat))

microbenchmark(str_trim(test,"right"),stri_trim_right(test)) 
microbenchmark(str_trim(flat,"right"),stri_trim_right(flat)) 






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
