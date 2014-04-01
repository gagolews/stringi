benchmark_description <- "collapses a long sequence of ASCII letters into a single string"

benchmark_do <- function() {
   library('stringi')
   library('stringr')

   ltrs10kx <- rep(letters, 10000)
   gc(reset=TRUE)
   benchmark2(
      paste(ltrs10kx, collapse=''),
      str_join(ltrs10kx, collapse=''),
      stri_join(ltrs10kx, collapse=''),
      replications=100L
   )
}
