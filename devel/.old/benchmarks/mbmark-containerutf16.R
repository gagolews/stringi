benchmark_description <- "StriContainerUTF16 [internal]"

benchmark_do  <- function() {
   library('stringi')

   set.seed(123)
   plletters <- stri_enc_fromutf32(sample(c(97L, 98L, 99L, 100L, 101L, 102L, 103L,
      104L, 105L, 106L, 107L,  108L, 109L, 110L, 111L, 112L, 113L, 114L, 115L,
      116L, 117L, 118L,  119L, 120L, 121L, 122L, 261L, 263L, 281L, 322L, 324L,
      243L, 347L,  378L, 380L), 100000, replace=TRUE))
   plletters <- enc2native(plletters)

   set.seed(123)
   ascii  <- rep(paste(sample(letters, 100000, replace=TRUE), collapse=''), 100)
   utf8   <- rep(enc2utf8(plletters), 100)
   native <- rep(plletters, 100)

   gc(reset=TRUE)
   microbenchmark2( # very fast - don't use benchmark2
      stringi:::.stri_test_StriContainerUTF16(ascii),
      stringi:::.stri_test_StriContainerUTF16(native),
      stringi:::.stri_test_StriContainerUTF16(utf8)
   )
}
