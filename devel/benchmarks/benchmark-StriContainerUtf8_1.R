do_benchmark <- function() {
   library('stringi')
   x <- c(
      stri_c(letters, collapse=''),
      stri_dup('a\u0105b', 100),
      NA_character_
   )
   
   gc(reset=TRUE)
   microbenchmark2(
      enc2utf8(x),
      stri_enc_toutf8(x)
   )
}
