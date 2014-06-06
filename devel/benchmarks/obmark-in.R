library(stringi)

x <- as.character(outer(letters, outer(letters, outer(letters, letters, paste0), paste0), paste0))
x <- sample(x)
x100 <- x[1:100]
x1000 <- x[1:1000]
x10000 <- x[1:10000]
x100000 <- x[1:100000]

srch <- tail(x, 100)

library(microbenchmark)

microbenchmark(match(srch, x100), match(srch, x1000), match(srch, x10000), match(srch, x100000),
   stri_in_fixed(srch, x100), stri_in_fixed(srch, x1000), stri_in_fixed(srch, x10000), stri_in_fixed(srch, x100000))
microbenchmark(match(x100, x100), match(x1000, x1000), match(x10000, x10000), match(x100000, x100000),
   stri_in_fixed(x100, x100), stri_in_fixed(x1000, x1000), stri_in_fixed(x10000, x10000), stri_in_fixed(x100000, x100000))
microbenchmark(match("gsded", x100), match("gsded", x1000), match("gsded", x10000), match("gsded", x100000),
   stri_in_fixed("gsded", x100), stri_in_fixed("gsded", x1000), stri_in_fixed("gsded", x10000), stri_in_fixed("gsded", x100000))
