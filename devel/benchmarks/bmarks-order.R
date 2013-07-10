require(microbenchmark)

local({

   x <- LETTERS
   print(microbenchmark(
      stri_order(x),
      order(x)
   ))

   x <- rev(LETTERS)
   print(microbenchmark(
      stri_order(x),
      order(x)
   ))


   x <- sample(rep(LETTERS, 100))
   print(microbenchmark(
      stri_sort(x),
      sort(x)
   ))

   x <- stri_dup('aba', 1:100)
   print(microbenchmark(
      stri_sort(x),
      sort(x)
   ))


   x <- sapply(1:100, function(i) rawToChar(as.raw(sample(65:90, as.integer(runif(1, 10, 20)), replace=TRUE))))
   print(microbenchmark(
      stri_sort(x),
      sort(x)
   ))

   x <- sort(x)
   print(microbenchmark(
      stri_sort(x),
      sort(x)
   ))


   for (i in 1:10) { y <- sample(seq_along(x), 2); x[y] <- x[rev(y)] }
   print(microbenchmark(
      stri_sort(x),
      sort(x)
   ))


   x <- rev(x)
   print(microbenchmark(
      stri_order(x),
      order(x)
   ))


   x <- stri_dup('\u0105', 100:1)
   print(microbenchmark(
      stri_order(x),
      order(x)
   ))
})


x <- sapply(1:100000, function(i) rawToChar(as.raw(sample(65:90, as.integer(runif(1, 10, 20)), replace=TRUE))))
system.time(stri_sort(x))
system.time(sort(x))

x <- sort(x)
system.time(stri_sort(x))
system.time(sort(x))


x <- sapply(1:100000, function(i) stri_flatten(sample(c(
   "\u0105", "\u0119", "\u015b", "\u0107", "\u017a", "\u0118", "\u0141", "\u00f3"),
      as.integer(runif(1, 10, 20)), replace=TRUE)))
system.time(stri_sort(x))
system.time(sort(x))

x <- sort(x)
system.time(stri_sort(x))
system.time(sort(x))
