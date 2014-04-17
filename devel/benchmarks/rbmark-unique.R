benchmark_description <- "extracts unique elements from a character vector "%+%
                         "(ASCII + Polish letters, native encoding) "%+%
                         "[random order on input]"

benchmark_do <- function() {
   library('stringi')
   library('stringr')

   plletters <- stri_enc_fromutf32(list(97L, 98L, 99L, 100L, 101L, 102L, 103L,
      104L, 105L, 106L, 107L,  108L, 109L, 110L, 111L, 112L, 113L, 114L, 115L,
      116L, 117L, 118L,  119L, 120L, 121L, 122L, 261L, 263L, 281L, 322L, 324L,
      243L, 347L,  378L, 380L))
   set.seed(123)
   xrand <- stri_rand_strings(10000, floor(abs(rcauchy(10000, 10))+1),
      "["%+%stri_escape_unicode(stri_c(plletters, collapse=""))%+%"]")
   xrand <- enc2native(xrand)

   gc(reset=TRUE)

   benchmark2(
      stri_unique(xrand),
      stri_unique(xrand, opts_collator=NA),
      unique(xrand),
      replications=100L
   )
}
