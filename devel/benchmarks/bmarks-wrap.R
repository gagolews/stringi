require(microbenchmark)
require(stringr)

s <- c("ala ma \u0105 \u00F1 kota i kotek ma alicje oraz dwie gruszeczki oraz gruby czarny pies ma kotka ale nie ma alibaby")

microbenchmark(strwrap(s,45), str_wrap(s,45), stri_wrap(s,45))

s <- rep(s,100)

microbenchmark(strwrap(s,25), str_wrap(s,25), stri_wrap(s,25),times=10)

