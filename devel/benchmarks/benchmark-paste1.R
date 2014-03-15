do_benchmark <- function() {
   library('stringi')
   library('stringr')
   
   gc(reset=TRUE)
   microbenchmark2(
      paste(letters, collapse=''),
      str_join(letters, collapse=''),
      stri_join(letters, collapse='')
   )
}
