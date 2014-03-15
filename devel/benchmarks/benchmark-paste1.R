benchmark_description <- "collapses a sequence of ASCII characters into a single string"

benchmark_do <- function() {
   library('stringi')
   library('stringr')

   ltrs10kx <- rep(letters, 10000)
   gc(reset=TRUE)
   microbenchmark2(
      paste(ltrs10kx, collapse=''),
      str_join(ltrs10kx, collapse=''),
      stri_join(ltrs10kx, collapse='')
   )
}
