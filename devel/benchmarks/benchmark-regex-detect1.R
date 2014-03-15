benchmark_description <- "regex lookup for words with at least 3 consecutive digits"

benchmark_do <- function() {
   library('stringi')
   library('stringr')

   lettersdigits <- c(0:9, stri_enc_fromutf32(list(97L, 98L, 99L, 100L, 101L, 102L, 103L,
      104L, 105L, 106L, 107L,  108L, 109L, 110L, 111L, 112L, 113L, 114L, 115L,
      116L, 117L, 118L,  119L, 120L, 121L, 122L, 261L, 263L, 281L, 322L, 324L,
      243L, 347L,  378L, 380L)))
   lettersdigits <- enc2native(lettersdigits)

   set.seed(123)
   letdig <- replicate(100000, {
      paste(sample(lettersdigits,
         floor(abs(rcauchy(1, 10))+1), replace=TRUE), collapse='')
   })

   gc(reset=TRUE)
   microbenchmark2(
      grepl("[0-9]{3,}", letdig),
      grepl("[0-9]{3,}", letdig, perl=TRUE),
      stri_detect_regex(letdig, "[0-9]{3,}")
   )
}
