require(microbenchmark)



s <- stri_flatten(stri_dup(LETTERS, 1:240))
microbenchmark(
   utf8ToInt(enc2utf8(s)),
   stri_enc_toutf32(s)
)
stopifnot(identical(utf8ToInt(s), stri_enc_toutf32(s)[[1]]))




s <- stri_flatten(stri_dup(LETTERS, 1:240))
microbenchmark(
   lapply(c(s,s,s,s), utf8ToInt),
   stri_enc_toutf32(c(s,s,s,s))
)
stopifnot(identical(lapply(c(s,s,s,s), utf8ToInt), stri_enc_toutf32(c(s,s,s,s))))


