require(microbenchmark)

s <- c("ala ma \u0105 \u00F1 kota i kotek ma alicje oraz dwie gruszeczki oraz gruby czarny pies ma kotka ale nie ma alibaby")

strwrap("1 1 1",6)
cat(stri_wrapC2(s,40,"d"))
cat(stri_wrapC2(s,40,"g"))
s <- rep(s,100)
# different stri_wrap versions - greedy 
system.time(stri_wrap(s,25,"g"))
system.time(stri_wrapC(s,25,"g"))
system.time(stri_wrapC2(s,25,"g"))
system.time(stri_wrapC3(s,25,"g"))
microbenchmark(stri_wrap(s,25),stri_wrapC(s,25),
               stri_wrapC2(s,25),stri_wrapC3(s,25),times=10)

# different stri_wrap versions - dynamic
system.time(stri_wrap(s,25,"d"))
system.time(stri_wrapC(s,25,"d"))
system.time(stri_wrapC2(s,25,"d"))
microbenchmark(stri_wrap(s,25,"d"),stri_wrapC(s,25,"d"),
               stri_wrapC2(s,25,"d"),stri_wrapC3(s,25,"d"),times=10)


# stri_wrap vs strwrap/str_wrap
require(stringr)
system.time(strwrap(s,25))
system.time(str_wrap(s,25))
system.time(stri_wrap(s,25))
system.time(stri_wrapC(s,25))
system.time(stri_wrapC2(s,25))
system.time(stri_wrapC3(s,25))

microbenchmark(strwrap(s,25), str_wrap(s,25),stri_wrap(s,25),
               stri_wrapC(s,25),stri_wrapC2(s,25),stri_wrapC3(s,25),times=10)